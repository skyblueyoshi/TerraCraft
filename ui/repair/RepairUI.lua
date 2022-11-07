---@class TC.RepairUI:GuiContainer
local RepairUI = class("RepairUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local GuiID = require("ui.GuiID")
local UIData = require("RepairUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.RepairContainerClient
function RepairUI:__init(container)
    RepairUI.super.__init(self, container)
    self.repairContainer = container
    self.repairContainer.dataChangedCallback = { self._OnDataChanged, self }
    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getRepairUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")

    local listenSlots = {}
    for i = 0, 49 do
        table.insert(listenSlots, self.repairContainer.tempSlots:GetSlot(i))
    end
    for i = 50, 51 do
        table.insert(listenSlots, self.repairContainer.tempSlots:GetSlot(i))
    end
    table.insert(listenSlots, PlayerUtils.GetCurrentClientPlayer().mouseInventory:GetSlot(0))
    self.recipeBookUI = require("ui.recipe_book.RecipeBookUI").new(
            Reg.RecipeConfigID("Repair"),
            self.rootLayer, false, listenSlots,
            { self._onValidRecipeClicked, self },
            "11"
    )

    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Repair)
    self:_initContent()
end

function RepairUI:_initContent()
    local maxSlots = self.container:GetSlotCount()
    for i = 1, maxSlots do
        local tag = i - 1

        if tag == 52 then
            local outputNode = self.rootLayer:getChildByTag(tag)
            local outputSlot = self.repairContainer.tempSlots:GetSlot(tag)
            UIUtil.hookSlotView(outputNode, outputSlot, true)
            outputNode:addTouchUpListener({ self._onOutputClicked, self, outputSlot })

        else
            UIUtil.hookSlot(self.rootLayer:getChildByTag(tag), self, tag)
        end
    end

    self.rootLayer:getChild("btn_recipe"):addTouchUpListener({ self._onRecipeTriggerClicked, self })
    self.ui.root:addTouchUpListener({ self.OnBgClicked, self })

end

function RepairUI:_onValidRecipeClicked(recipeID)
    self:TriggerServerEvent(UIData.EventID.RecipeBookRequest, tostring(recipeID))
end

function RepairUI:_onRecipeTriggerClicked()
    self.recipeBookUI:SetDisplayState(not self.recipeBookUI.showing)
    self.ui.manager:playClickSound()
end

---@param slot Slot
function RepairUI:_onOutputClicked(slot)
    if slot.hasStack then
        self.ui.manager:playClickSound()
        self:TriggerServerEvent(UIData.EventID.PickOutput)
    end
end

function RepairUI:_OnDataChanged()

end

function RepairUI:OnBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(Mod.current, GuiID.Repair)
    end
end

function RepairUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
    self.recipeBookUI:closeWindow()
end

---checkSlotShiftMove
---@param slotIndex int
---@param itemStack ItemStack
function RepairUI:checkSlotShiftMove(slotIndex, itemStack)
    if slotIndex < 10 then
        -- shortcut to backpack
        return self.container, 10, 40
    elseif slotIndex < 50 then
        -- backpack to shortcut
        return self.container, 0, 10
    end
end

return RepairUI