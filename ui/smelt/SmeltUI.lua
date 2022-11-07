---@class TC.SmeltUI:GuiContainer
local SmeltUI = class("SmeltUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local GuiID = require("ui.GuiID")
local UIData = require("SmeltUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.SmeltContainerClient
function SmeltUI:__init(container)
    SmeltUI.super.__init(self, container)
    self.smeltContainer = container
    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getSmeltUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")

    local listenSlots = {}
    for i = 0, 49 do
        table.insert(listenSlots, self.smeltContainer.tempSlots:GetSlot(i))
    end
    table.insert(listenSlots, self.smeltContainer.tempSlots:GetSlot(50))
    table.insert(listenSlots, PlayerUtils.GetCurrentClientPlayer().mouseInventory:GetSlot(0))
    self.recipeBookUI = require("ui.recipe_book.RecipeBookUI").new(
            Reg.RecipeConfigID("Smelt"),
            self.rootLayer, false, listenSlots,
            { self._onValidRecipeClicked, self },
            "1"
    )

    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Smelt)
    self:_initContent()
end

function SmeltUI:_initContent()
    local maxSlots = self.container:GetSlotCount()
    for i = 1, maxSlots do
        local tag = i - 1
        if tag == 52 then
            local outputNode = self.rootLayer:getChildByTag(tag)
            local outputSlot = self.smeltContainer.tempSlots:GetSlot(tag)
            UIUtil.hookSlotView(outputNode, outputSlot, true)
            outputNode:addTouchUpListener({ self._onOutputClicked, self, outputSlot })

        else
            UIUtil.hookSlot(self.rootLayer:getChildByTag(tag), self, tag)
        end
    end
    self.rootLayer:getChild("img_cook"):getPostDrawLayer(0):addListener({ SmeltUI.OnRenderCookProgress, self })
    self.rootLayer:getChild("img_burn"):getPostDrawLayer(0):addListener({ SmeltUI.OnRenderBurnProgress, self })

    self.rootLayer:getChild("btn_recipe"):addTouchUpListener({ self._onRecipeTriggerClicked, self })
    self.ui.root:addTouchUpListener({ self.OnBgClicked, self })
end

---@param slot Slot
function SmeltUI:_onOutputClicked(slot)
    if slot.hasStack then
        self.ui.manager:playClickSound()
        self:TriggerServerEvent(UIData.EventID.PickOutput)
    end
end

function SmeltUI:_onValidRecipeClicked(recipeID)
    self:TriggerServerEvent(UIData.EventID.RecipeBookRequest, tostring(recipeID))
end

function SmeltUI:_onRecipeTriggerClicked()
    self.recipeBookUI:SetDisplayState(not self.recipeBookUI.showing)
    self.ui.manager:playClickSound()
end

---OnRenderCookProgress
---@param node UINode
---@param canvasPos Vector2
function SmeltUI:OnRenderCookProgress(node, canvasPos)
    UIUtil.renderProgress("tc:process_01",
            node.positionInCanvas + canvasPos,
            self.smeltContainer.cookProgress,
            16,
            1, 0)
end

---
---@param node UINode
---@param canvasPos Vector2
function SmeltUI:OnRenderBurnProgress(node, canvasPos)
    UIUtil.renderProgress("tc:burn_01",
            node.positionInCanvas + canvasPos,
            self.smeltContainer.burnProgress,
            16,
            0, -1)
end

function SmeltUI:OnBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(Mod.current, GuiID.Smelt)
    end
end

function SmeltUI:OnUpdate()

end

function SmeltUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
    self.recipeBookUI:closeWindow()
end

---checkSlotShiftMove
---@param slotIndex int
---@param itemStack ItemStack
function SmeltUI:checkSlotShiftMove(slotIndex, itemStack)
    if slotIndex < 10 then
        -- shortcut to backpack
        return self.container, 10, 40
    elseif slotIndex < 50 then
        -- backpack to shortcut
        return self.container, 0, 10
    end
end

return SmeltUI