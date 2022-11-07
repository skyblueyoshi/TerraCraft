---@class TC.Craft3xUI:GuiContainer
local Craft3xUI = class("Craft3xUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local GuiID = require("ui.GuiID")
local UIData = require("Craft3xUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.Craft3xContainerClient
function Craft3xUI:__init(container)
    Craft3xUI.super.__init(self, container)
    self.craftContainer = container
    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getCraft3xUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")

    local listenSlots = {}
    for i = 0, 49 do
        table.insert(listenSlots, self.craftContainer.tempSlots:GetSlot(i))
    end
    for i = 50, 58 do
        table.insert(listenSlots, self.craftContainer.tempSlots:GetSlot(i))
    end
    table.insert(listenSlots, PlayerUtils.GetCurrentClientPlayer().mouseInventory:GetSlot(0))
    self.recipeBookUI = require("ui.recipe_book.RecipeBookUI").new(
            Reg.RecipeConfigID("Craft3x"),
            self.rootLayer, false, listenSlots,
            { self._onValidRecipeClicked, self },
            "111" .. "111" .. "111"
    )

    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Craft3x)
    self:_initContent()
end

function Craft3xUI:_initContent()
    for i = 0, 58 do
        UIUtil.hookSlot(self.rootLayer:getChildByTag(i), self, i)
    end
    local outputNode = self.rootLayer:getChildByTag(59)
    local outputSlot = self.craftContainer.tempSlots:GetSlot(59)
    UIUtil.hookSlotView(outputNode, outputSlot, true)
    outputNode:addTouchUpListener({ self._onOutputClicked, self, outputSlot })

    self.rootLayer:getChild("btn_recipe"):addTouchUpListener({ Craft3xUI._onRecipeTriggerClicked, self })
    self.ui.root:addTouchUpListener({ Craft3xUI.OnBgClicked, self })
end

---_onOutputClicked
---@param slot Slot
function Craft3xUI:_onOutputClicked(slot)
    if slot.hasStack then
        self.ui.manager:playClickSound()
        if require("settings.SettingsData").isMobileOperation then
            self:TriggerServerEvent(UIData.EventID.PickOutput)
        else
            if Input.keyboard:isKeyPressed(Keys.LeftShift) then
                self:TriggerServerEvent(UIData.EventID.PickOutput)
            else
                self:TriggerServerEvent(UIData.EventID.PickOutput, "1")
            end
        end
    end
end

function Craft3xUI:_onValidRecipeClicked(recipeID)
    self:TriggerServerEvent(UIData.EventID.RecipeBookRequest, tostring(recipeID))
end

function Craft3xUI:_onRecipeTriggerClicked()
    self.recipeBookUI:SetDisplayState(not self.recipeBookUI.showing)
    self.ui.manager:playClickSound()
end

function Craft3xUI:OnBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(Mod.current, GuiID.Craft3x)
    end
end

function Craft3xUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
    self.recipeBookUI:closeWindow()
end

---checkSlotShiftMove
---@param slotIndex int
---@param itemStack ItemStack
function Craft3xUI:checkSlotShiftMove(slotIndex, itemStack)
    if slotIndex < 10 then
        -- shortcut to backpack
        return self.container, 10, 40
    elseif slotIndex < 50 then
        -- backpack to shortcut
        return self.container, 0, 10
    end
end

return Craft3xUI