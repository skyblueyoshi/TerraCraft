---@class TC.MouseItemData
local MouseItemData = class("MouseItemData")
local SettingsData = require("settings.SettingsData")

local s_instance
---@return TC.MouseItemData
function MouseItemData.getInstance()
    if s_instance == nil then
        s_instance = MouseItemData.new()
    end
    return s_instance
end

function MouseItemData:__init()
    self.inventory = Inventory.new(1)
    self.slot = nil  ---@type Slot
    self.touchingPosition = Vector2.new()
    self.originSlot = nil  ---@type Slot
    self.originContainer = nil  ---@type Container
    self.originSlotIndex = -1

    self.pickingOneByOne = false
    self.isPcCurrentPicking = false
    self.pcSelectingSlots = {}
    self.pcSelectingContainerAndSlotIndices = {}
    self.pcIsAverageMode = false
    self._pickingTicks = 0
    self._pickingStep = 30
    self._pickingSpeed = 4
    self._firstPicking = false
    self._ticks = 0
    self._iconScale = Vector2.new(1, 1)
    self._displayOffsetX = 64
    self._keepingTip = false

    self._itemInfoTable = {}
end

---showTip
---@param itemStack ItemStack
---@param touchingPosition Vector2
---@param keepTicks
function MouseItemData:showTip(itemStack, touchingPosition, keepTicks)
    self._itemInfoTable = {}
    local item = itemStack:GetItem()
    local showDebugTip = true
    local StringUtil = require("util.StringUtil")

    local itemName = LangUtils.ItemName(item.id)
    if itemName == "" then
        itemName = itemStack:GetItem().idName
    end
    table.insert(self._itemInfoTable, itemName)

    local enchantments = item.enchantments

    for i = 0, itemStack.enchantmentCount - 1 do
        local enchantment = itemStack:GetEnchantmentByIndex(i)
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>%s %s</c>",
                LangUtils.EnchantmentName(enchantment.id), StringUtil.NumberToRoman(enchantment.level)))
    end

    if #enchantments > 0 then
        table.insert(self._itemInfoTable, " ")
    end

    local buffs = item.buffs
    for _, buff in ipairs(buffs) do
        table.insert(self._itemInfoTable, string.format("<c=#5454FCFF>%s  %s</c>",
                LangUtils.BuffName(buff.id), StringUtil.TicksToTimeFormat(buff.time)))
    end

    local intro = LangUtils.ItemIntroduction(item.id)
    if intro ~= "" then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>%s</c>", intro))
    end

    if item.maxDurable > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>耐久 %d/%d</c>", itemStack.durable, item.maxDurable))
    end

    if item.baseAttack.attack > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>攻击 +%d</c>", item.baseAttack.attack))
    end

    if item.baseAttack.knockBack > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>击退 +%d</c>", item.baseAttack.knockBack))
    end

    if item.baseAttack.crit > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>暴击 +%d</c>", item.baseAttack.crit))
    end

    if item.defense > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>防御 +%d</c>", item.defense))
    end

    if item.noConsumeChance > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>弹药节省 +%d%%</c>", math.ceil(item.noConsumeChance * 100)))
    end

    if item.consumeMana > 0 then
        table.insert(self._itemInfoTable, string.format("<c=#A8A8A8FF>魔耗 %d</c>", item.consumeMana))
    end

    if showDebugTip then
        table.insert(self._itemInfoTable, string.format("<c=#545454FF>%s</c>", item.idName))
    end

    local modName = item.mod.displayName
    if modName ~= "" then
        table.insert(self._itemInfoTable, string.format("<c=#5454FCFF>%s</c>", modName))
    end

    local TipUI = require("TipUI")
    if TipUI.isShowing() then
        TipUI.changeNewContent(self._itemInfoTable)
        TipUI.resetKeepTime()
    else
        TipUI.generate(self._itemInfoTable, keepTicks, 1)
    end

    TipUI.adaptPosition(touchingPosition)
    self._keepingTip = true
end

function MouseItemData:closeTip()
    local TipUI = require("TipUI")
    TipUI.close()
    self:stopKeepingTip()
end

function MouseItemData:stopKeepingTip()
    self._keepingTip = false
end

function MouseItemData:startDragging(originContainer, originSlotIndex)
    self.originSlot = originContainer:GetSlot(originSlotIndex)
    self.originContainer = originContainer
    self.originSlotIndex = originSlotIndex
end

function MouseItemData:stopDragging()
    self.originSlot = nil
    self.originContainer = nil
    self.originSlotIndex = -1
end

function MouseItemData:fixDisplayOffset()
    if SettingsData.isMobileOperation then
        self._displayOffsetX = 64 * ((self.touchingPosition.x > GameWindow.width * 0.5) and -1.0 or 1.0)
    else
        self._displayOffsetX = 64
    end
end

function MouseItemData:updateDisplayOffset()
    if SettingsData.isMobileOperation then
        local moveSpeed = 4
        self._displayOffsetX = math.min(math.max(
                self._displayOffsetX + moveSpeed *
                        ((self.touchingPosition.x > GameWindow.width * 0.5) and -1 or 1), -64), 64)
    else
        self:fixDisplayOffset()
    end
end

function MouseItemData:startPicking()
    self.pickingOneByOne = true
    self._pickingTicks = 0
    self._pickingStep = 12
    self._pickingSpeed = 2
    self._firstPicking = true
    self:fixDisplayOffset()
end

function MouseItemData:stopPicking()
    if self.pickingOneByOne then
        self.pickingOneByOne = false
    end
end

function MouseItemData:update()
    assert(ClientState.current == ClientState.Gaming, "current client state must be Gaming!")

    if not SettingsData.isMobileOperation then
        self.touchingPosition = Input.mouse.position
    end

    local TipUI = require("TipUI")
    if TipUI.isShowing() and TipUI.getShowTag() == 1 then
        TipUI.adaptPosition(self.touchingPosition)
        if self._keepingTip then
            TipUI.resetKeepTime()
        end
    end

    if self.slot == nil then
        local player = PlayerUtils.GetCurrentClientPlayer()
        self.slot = player.mouseInventory:GetSlot(0)
        ---@type TC.GPlayer
        local globalPlayer = player:GetGlobalPlayer("tc:GPlayer")
        --print(globalPlayer.sayWord)
    end
    local mouseSlot = self.slot
    if mouseSlot.hasStack then
        if self.pickingOneByOne and self.originSlot ~= nil then
            if self.originSlot.hasStack then
                self._pickingTicks = self._pickingTicks + 1
                local checkTime = self._pickingStep * (self._firstPicking and 2 or 1)

                if self._pickingTicks >= checkTime then

                    self._pickingSpeed = self._pickingSpeed - 1
                    if self._pickingSpeed <= 0 then
                        self._pickingSpeed = 1
                        self._pickingStep = math.max(self._pickingStep - 1, 1)
                    end

                    self._pickingTicks = 0
                    local pickingCount = 1
                    local merges = mouseSlot:GetStack():GetMergeCount(self.originSlot:GetStack())
                    if merges > 0 then
                        pickingCount = math.min(merges, pickingCount)
                        mouseSlot:GetStack():SetStackSize(mouseSlot:GetStack().stackSize + pickingCount)
                        self.originSlot:DecrStackSize(pickingCount)
                        SoundUtils.PlaySound(Reg.SoundID("pop"))
                    end
                end
            end
        end

        local scaleNum = 1.5 + Utils.SinValue(self._ticks, 64) * 0.1
        self._iconScale.x = scaleNum
        self._iconScale.y = scaleNum

        self:updateDisplayOffset()

        self._ticks = self._ticks + 1
    end
end

function MouseItemData:render()
    assert(ClientState.current == ClientState.Gaming, "current client state must be Gaming!")
    if self.slot.hasStack then
        Sprite.beginBatch()
        local stack = self.slot:GetStack()
        local exData = SpriteExData.new()
        exData.scaleRate = self._iconScale
        exData.origin = Vector2.new(16, 16)
        local pos = self.touchingPosition + Vector2.new(self._displayOffsetX, 48)
        if self.slot.tag < 0 then
            local num = require("ui.UISlotOp").getSelectedNum(self.slot)
            if num > 0 then
                stack:Render(pos, Color.White, exData)
                stack:RenderCustomNum(num, pos, Color.Yellow, exData)
            end
        else
            stack:Render(pos, Color.White, exData)
            stack:RenderNum(pos, Color.Yellow, exData)
        end
        Sprite.endBatch()
    end
end

return MouseItemData