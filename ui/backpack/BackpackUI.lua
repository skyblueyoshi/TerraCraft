---@class TC.BackpackUI:GuiContainer
local BackpackUI = class("BackpackUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local BackpackUIData = require("BackpackUIData")
local InputControl = require("client.InputControl")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

local s_isRecipeBookReminded = false

---@param container TC.BackpackContainerClient
function BackpackUI:__init(container)
    BackpackUI.super.__init(self, container)

    self.currentContainer = container
    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getBackpackUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self._rootLayer = self.ui.root:getChild("layer")
    self._recipeBookIcon = UIImage.cast(self._rootLayer:getChild("btn_recipe.img"))
    self._reminderTicks = 0

    self._panelStatus = self._rootLayer:getChild("panel_status")
    self._playerBone = nil

    local listenSlots = {}
    for i = 0, 49 do
        table.insert(listenSlots, self.currentContainer.tempSlots:GetSlot(i))
    end
    for i = 56, 59 do
        table.insert(listenSlots, self.currentContainer.tempSlots:GetSlot(i))
    end
    table.insert(listenSlots, PlayerUtils.GetCurrentClientPlayer().mouseInventory:GetSlot(0))
    self.recipeBookUI = require("ui.recipe_book.RecipeBookUI").new(
            Reg.RecipeConfigID("Craft3x"),
            self._rootLayer, false, listenSlots,
            { self._onValidRecipeClicked, self },
            "110" .. "110" .. "000"
    )
    local GuiID = require("ui.GuiID")
    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Backpack)

    self:_initContent()
end

function BackpackUI:_initContent()

    -- bone module
    local player = PlayerUtils.GetCurrentClientPlayer()
    local gPlayer = require("player.GPlayer").GetInstance(player)
    self._playerBone = gPlayer.bone
    self._panelStatus:getPostDrawLayer(0):addListener({ self._onRenderBone, self })

    self.ui.root:addTouchUpListener({ BackpackUI._onBgClicked, self })

    local maxSlots = self.container:GetSlotCount()
    local craftOutputTag = 65
    for i = 1, maxSlots do
        local tag = i - 1
        if tag ~= craftOutputTag then
            UIUtil.hookSlot(self._rootLayer:getChildByTag(tag), self, tag)
        end
    end

    local outputNode = self._rootLayer:getChildByTag(craftOutputTag)
    local outputSlot = self.currentContainer.tempSlots:GetSlot(craftOutputTag)
    UIUtil.hookSlotView(outputNode, outputSlot, true)
    outputNode:addTouchUpListener({ BackpackUI._onOutputClicked, self, outputSlot })

    self._rootLayer:getChild("btn_recipe"):addTouchUpListener({ BackpackUI._onRecipeTriggerClicked, self })
    self._rootLayer:getChild("btn_sort"):addTouchUpListener({ BackpackUI._onSortClicked, self })
    self.ui:initUpdateFunc({ BackpackUI._onUpdate, self })
end

function BackpackUI:_onUpdate()
    if not s_isRecipeBookReminded then
        self._reminderTicks = self._reminderTicks + 1
        self._recipeBookIcon.sprite.style = UISpriteStyle.Filled

        local rate = 1.10 + Utils.SinValue(self._reminderTicks, 64) * 0.10

        self._recipeBookIcon.width = 32 * rate
        self._recipeBookIcon.height = 32 * rate
        self._recipeBookIcon:applyMargin()
    end

end

function BackpackUI:_onRenderBone()
    local screenPos = self.ui.manager:getScreenPosition(self._panelStatus)
    self._playerBone.joints.position = screenPos + Vector2.new(44, 120)
    self._playerBone.joints.scale = Vector2.new(1.5, 1.5)
    --self._playerBone:update()
    self._playerBone.joints:render()
end

---_onOutputClicked
---@param slot Slot
function BackpackUI:_onOutputClicked(slot)
    if slot.hasStack then
        self.ui.manager:playClickSound()
        self:TriggerServerEvent(BackpackUIData.EventID.PickOutput)
    end
end

function BackpackUI:_onValidRecipeClicked(recipeID)
    self:TriggerServerEvent(BackpackUIData.EventID.RecipeBookRequest, tostring(recipeID))
end

function BackpackUI:_onRecipeTriggerClicked()
    self.recipeBookUI:SetDisplayState(not self.recipeBookUI.showing)

    if not s_isRecipeBookReminded then
        s_isRecipeBookReminded = true
        self._recipeBookIcon.sprite.style = UISpriteStyle.Filled
        self._recipeBookIcon.width = 32
        self._recipeBookIcon.height = 32
        self._recipeBookIcon:applyMargin()
    end

    self.ui.manager:playClickSound()
end

function BackpackUI:_onSortClicked()
    self.ui.manager:playClickSound()
    self:TriggerServerEvent(BackpackUIData.EventID.SortBackpack)
end

function BackpackUI:OnUpdate()

end

function BackpackUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
    self.recipeBookUI:closeWindow()
end

function BackpackUI:_onBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    self:_closeMe()
end

function BackpackUI:_closeMe()
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        local GuiID = require("ui.GuiID")
        player:CloseGui(Mod.current, GuiID.Backpack)
    end
end

---checkSlotShiftMove
---@param slotIndex int
---@param itemStack ItemStack
function BackpackUI:checkSlotShiftMove(slotIndex, itemStack)
    if slotIndex < 50 then
        -- shortcut/backpack to equipment
        local item = itemStack:GetItem()
        if item.toolType == "HELMET" then
            if not self.container:GetSlot(50).hasStack then
                return self.container, 50, 1
            end
        elseif item.toolType == "CHESTPLATE" then
            if not self.container:GetSlot(51).hasStack then
                return self.container, 51, 1
            end
        elseif item.toolType == "LEGGINGS" then
            if not self.container:GetSlot(52).hasStack then
                return self.container, 52, 1
            end
        end
    end
    if slotIndex < 10 then
        -- shortcut to backpack
        return self.container, 10, 40
    elseif slotIndex < 50 then
        -- backpack to shortcut
        return self.container, 0, 10
    else
        -- equipment/craft2x to backpack/shortcut
        return self.container, 0, 50
    end
end

return BackpackUI