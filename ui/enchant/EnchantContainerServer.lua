---@class TC.EnchantContainerServer:Container
local EnchantContainerServer = class("EnchantContainerServer", Container)
local ContainerHelper = require("ui.ContainerHelper")
local UIData = require("EnchantUIData")
local Algorithm = require("util.Algorithm")

local ENCHANT_SLOTS = 2
local ENCHANT_BTN_COUNT = 3
local MAX_ENCHANT_LEVEL = 30


---__init
---@param player Player
---@param xi int
---@param yi int
function EnchantContainerServer:__init(player, xi, yi)
    EnchantContainerServer.super.__init(self)
    self.playerIndex = player.entityIndex
    self.inventory = player.backpackInventory
    self.xi = xi
    self.yi = yi
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    self._tempSlots = Inventory.new(ENCHANT_SLOTS)
    self._toolSlot = self._tempSlots:GetSlot(0)
    self._lapisSlot = self._tempSlots:GetSlot(1)

    self._btnData = {}

    for i = 0, ENCHANT_SLOTS - 1 do
        local slot = self._tempSlots:GetSlot(i)
        self:AddSlotToContainer(self._tempSlots, i)
        slot:AddOnPickListener({ EnchantContainerServer.OnChanged, self })
        slot:AddOnPushListener({ EnchantContainerServer.OnChanged, self })
    end
end

function EnchantContainerServer:OnChanged()
    self:_OnFlushData()
end

function EnchantContainerServer:_OnFlushData()
    local canEnchant = false
    local isBookEnchanting = false

    if self._toolSlot.hasStack then
        local stack = self._toolSlot:GetStack()
        if stack:GetItem().id == Reg.ItemID("book") then
            if stack.stackSize == 1 then
                canEnchant = true
                isBookEnchanting = true
            end
        elseif not stack:HasEnchantment() then
            canEnchant = true
        end
    end

    self._btnData = {}
    if canEnchant then
        local stack = self._toolSlot:GetStack()
        local maxCheckLevel = self:_CheckMaxLevel()

        -- generate level for every button
        local expLevels = {}
        for i = 1, ENCHANT_BTN_COUNT do
            local expLevel = math.ceil(maxCheckLevel * i / ENCHANT_BTN_COUNT - 2 + math.random(0, 4))
            expLevels[i] = math.max(1, math.min(MAX_ENCHANT_LEVEL, expLevel))
        end

        for i = 1, ENCHANT_BTN_COUNT do
            local expLevel = expLevels[i]

            -- calculate how many enchantments can attach in current item
            local maxAttachCount = math.max(1, math.ceil(expLevel / 30 * 4))
            maxAttachCount = math.random(1, maxAttachCount)

            -- get all available enchantments
            local pendingEnchantmentIDs = {}
            for enchantmentID = 1, Reg.MaxEnchantmentID() do
                local data = EnchantmentUtils.GetData(enchantmentID)
                -- reach the enchantment level limit
                if not data.noCreating and expLevel >= data.minCreatingLevel then
                    -- current item can use this enchantment
                    if isBookEnchanting or data:IsToolTypeValid(stack:GetItem().toolType) then
                        table.insert(pendingEnchantmentIDs, enchantmentID)
                    end
                end
            end

            -- random shuffle the available enchantment list
            Algorithm.Shuffle(pendingEnchantmentIDs)

            local resultIDs = {}
            local resultEnchantments = {}
            local times = 0
            for _, enchantmentID in ipairs(pendingEnchantmentIDs) do
                local ok = false
                if #resultIDs == 0 then
                    ok = true
                else
                    -- skip if this enchantment conflict with exist enchantments
                    ok = true
                    for _, existID in ipairs(resultIDs) do
                        if EnchantmentUtils.IsConflict(enchantmentID, existID) then
                            ok = false
                            break
                        end
                    end
                end
                if ok then
                    local data = EnchantmentUtils.GetData(enchantmentID)
                    local t = math.max(1, math.floor(data.allowMaxLevel * expLevel / 30))
                    local level = math.random(1, t)
                    times = times + 1
                    if times > maxAttachCount then
                        break
                    end
                    local enchantment = Enchantment.new(enchantmentID, level)

                    table.insert(resultIDs, enchantmentID)
                    table.insert(resultEnchantments, enchantment)
                end
            end

            local cost = self:_GetCostExpLevel(expLevel)
            table.insert(self._btnData, {
                expLevel = expLevel,
                enchantments = resultEnchantments,
                costExpLevel = cost,
                enabled = self:_IsBtnEnable(expLevel, cost)
            })
        end
    end

    if #self._btnData ~= ENCHANT_BTN_COUNT then
        canEnchant = false
    else
        for _, data in ipairs(self._btnData) do
            if #data.enchantments == 0 then
                canEnchant = false
                break
            end
        end
    end

    if not canEnchant then
        -- remove all data
        self._btnData = {}
    end

    self:_SendData()
end

function EnchantContainerServer:_SendData()
    local tableData = {}

    for i = 1, ENCHANT_BTN_COUNT do
        local data = self._btnData[i]

        local needExp = 0
        local cost = 0
        local firstEnchantmentID = 0
        local firstEnchantmentLevel = 0

        if data ~= nil then
            needExp = data.expLevel * (data.enabled and 1 or -1)
            cost = data.costExpLevel
            local enchantment = data.enchantments[1]
            if enchantment then
                firstEnchantmentID = enchantment.id
                firstEnchantmentLevel = enchantment.level
            end
        end

        table.insert(tableData, {
            needExp = needExp,
            cost = cost,
            firstEnchantmentID = firstEnchantmentID,
            firstEnchantmentLevel = firstEnchantmentLevel,
        })
    end

    local jsonString = JsonUtil.toJson(tableData)
    self:DetectAndSendChangeString(0, jsonString)
end

function EnchantContainerServer:_CheckMaxLevel()
    local sourceXi = self.xi
    local sourceYi = self.yi

    local BLOCK_BOOK_ID = Reg.BlockID("tc:book")
    local BOOKCASE_SUB_GROUP_ID = Reg.BlockSubGroupID("BOOKCASE")

    -- Get books and bookcases around the enchantment table to
    -- gain how many level can reach.
    local maxCheckLevel = 0
    for xi = sourceXi - 5, sourceXi + 5 do
        for yi = sourceYi - 6, sourceYi do
            local blockID = MapUtils.GetFrontID(xi, yi)
            if blockID > 0 then
                local cxi, cyi = MapUtils.GetBodyPos(xi, yi)
                if xi == cxi and yi == cyi then
                    if blockID == BLOCK_BOOK_ID then
                        maxCheckLevel = maxCheckLevel + 2
                    else
                        local data = BlockUtils.GetData(blockID)
                        if data.subGroup == BOOKCASE_SUB_GROUP_ID then
                            maxCheckLevel = maxCheckLevel + 8
                        end
                    end
                end
            end
        end
    end
    maxCheckLevel = math.max(1, math.min(MAX_ENCHANT_LEVEL, maxCheckLevel))
    return maxCheckLevel
end

function EnchantContainerServer:OnEvent(eventId, eventString)
    if eventId == UIData.EventID.ClickBtn then
        local index = tonumber(eventString)
        if index == nil then
            return
        end
        if not (index >= 1 and index <= 3) then
            return
        end
        self:_OnClickBtn(index)
    end
end

function EnchantContainerServer:_OnClickBtn(index)
    if not (index >= 1 and index <= ENCHANT_BTN_COUNT) then
        return
    end
    if #self._btnData ~= ENCHANT_BTN_COUNT then
        return
    end
    if not self._toolSlot.hasStack then
        return
    end

    local data = self._btnData[index]
    if not data.enabled then
        return
    end

    local stack = self._toolSlot:GetStack()
    if stack:GetItem().id == Reg.ItemID("book") then
        if stack.stackSize ~= 1 then
            return
        end
        self._toolSlot:ClearStack()
        self._toolSlot:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("enchanted_book")))
    end
    local costExpLevel = data.costExpLevel
    local enchantments = data.enchantments
    stack = self._toolSlot:GetStack()
    for _, enchantment in ipairs(enchantments) do
        stack:AddEnchantment(enchantment.id, enchantment.level)
    end
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("enchant"), self.xi, self.yi)

    -- reduce exp
    local player = PlayerUtils.Get(self.playerIndex)
    if player then
        player:RemoveExpLevel(costExpLevel)
    end

    -- reduce lapis
    if self._lapisSlot.hasStack then
        self._lapisSlot:DecrStackSize(costExpLevel)
    end

    self:OnChanged()
end

function EnchantContainerServer:_GetCostExpLevel(targetExpLevel)
    return math.max(1, math.ceil(targetExpLevel / 10.0))
end

function EnchantContainerServer:_IsBtnEnable(targetExpLevel, costExpLevel)
    local player = PlayerUtils.Get(self.playerIndex)
    if not player then
        return false
    end
    -- check player experience level
    if player.expLevel < targetExpLevel or player.expLevel < costExpLevel then
        return false
    end
    -- check lapis count
    if not self._lapisSlot.hasStack then
        return false
    end
    local stack = self._lapisSlot:GetStack()
    if stack:GetItem().id ~= Reg.ItemID("lapis_lazuli") then
        return false
    end
    if stack.stackSize < costExpLevel then
        return false
    end
    return true
end

function EnchantContainerServer:CanInteractWith(player)
    local ok = ContainerHelper.InInteractDistance(player, self.xi, self.yi)
    return ok
end

function EnchantContainerServer:OnClose()
    ContainerHelper.CloseSendBackItems(self.playerIndex,
            self.xi, self.yi, self._tempSlots,
            { 0, 1 })
end

return EnchantContainerServer