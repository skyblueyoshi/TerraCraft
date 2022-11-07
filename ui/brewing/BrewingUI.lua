---@class TC.BrewingUI:GuiContainer
local BrewingUI = class("BrewingUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local GuiID = require("ui.GuiID")
local UIData = require("BrewingUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.BrewingContainerClient
function BrewingUI:__init(container)
    BrewingUI.super.__init(self, container)
    self.brewingContainer = container
    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getBrewingUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")

    local listenSlots = {}
    for i = 0, 49 do
        table.insert(listenSlots, self.brewingContainer.tempSlots:GetSlot(i))
    end
    for i = 50, 51 do
        table.insert(listenSlots, self.brewingContainer.tempSlots:GetSlot(i))
    end
    table.insert(listenSlots, PlayerUtils.GetCurrentClientPlayer().mouseInventory:GetSlot(0))
    self.recipeBookUI = require("ui.recipe_book.RecipeBookUI").new(
            Reg.RecipeConfigID("Brew"),
            self.rootLayer, false, listenSlots,
            { self._onValidRecipeClicked, self },
            "11"
    )

    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Brewing)
    self:_initContent()
end

function BrewingUI:_initContent()
    local maxSlots = self.container:GetSlotCount()
    for i = 1, maxSlots do
        local tag = i - 1
        if tag == 52 then
            local outputNode = self.rootLayer:getChildByTag(tag)
            local outputSlot = self.brewingContainer.tempSlots:GetSlot(tag)
            UIUtil.hookSlotView(outputNode, outputSlot, true)
            outputNode:addTouchUpListener({ self._onOutputClicked, self, outputSlot })

        else
            UIUtil.hookSlot(self.rootLayer:getChildByTag(tag), self, tag)
        end
    end
    self.rootLayer:getChild("img_process"):getPostDrawLayer(0):addListener({ BrewingUI.OnRenderProcessProgress, self })
    self.rootLayer:getChild("img_bubble"):getPostDrawLayer(0):addListener({ BrewingUI.OnRenderBubbleProgress, self })
    self.rootLayer:getChild("img_fuel"):getPostDrawLayer(0):addListener({ BrewingUI.OnRenderFuelProgress, self })

    self.rootLayer:getChild("btn_recipe"):addTouchUpListener({ self._onRecipeTriggerClicked, self })
    self.ui.root:addTouchUpListener({ self.OnBgClicked, self })
end

---
---@param node UINode
---@param canvasPos Vector2
function BrewingUI:OnRenderProcessProgress(node, canvasPos)
    UIUtil.renderProgress("tc:brewing_process_01",
            node.positionInCanvas + canvasPos,
            self.brewingContainer.progress,
            16, 0, 1)
end

---
---@param node UINode
---@param canvasPos Vector2
function BrewingUI:OnRenderBubbleProgress(node, canvasPos)
    UIUtil.renderProgress("tc:brewing_bubble_01",
            node.positionInCanvas + canvasPos,
            math.floor(self.brewingContainer.bubbleProgressRate * 32.0),
            32, 0, -1)
end

---
---@param node UINode
---@param canvasPos Vector2
function BrewingUI:OnRenderFuelProgress(node, canvasPos)
    UIUtil.renderProgress("tc:brewing_fuel_01",
            node.positionInCanvas + canvasPos,
            self.brewingContainer.remainTimes,
            20, 0, -1)
end

---@param slot Slot
function BrewingUI:_onOutputClicked(slot)
    if slot.hasStack then
        self.ui.manager:playClickSound()
        self:TriggerServerEvent(UIData.EventID.PickOutput)
    end
end

function BrewingUI:_onValidRecipeClicked(recipeID)
    self:TriggerServerEvent(UIData.EventID.RecipeBookRequest, tostring(recipeID))
end

function BrewingUI:_onRecipeTriggerClicked()
    self.recipeBookUI:SetDisplayState(not self.recipeBookUI.showing)
    self.ui.manager:playClickSound()
end

function BrewingUI:OnBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(Mod.current, GuiID.Brewing)
    end
end

function BrewingUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
    self.recipeBookUI:closeWindow()
end

return BrewingUI