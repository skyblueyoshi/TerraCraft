---@class TC.IChestUI:GuiContainer
local IChestUI = class("IChestUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local UIData = require("ChestUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.IChestContainerClient
function IChestUI:__init(rootNode, container, guiID)
    IChestUI.super.__init(self, container)

    self.ui = require("ui.UIWindow").new(rootNode, require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")
    self.guiID = guiID

    self._hkHelper = HotkeyUIHelper.new(Mod.current, self.guiID)
    self:_innerInitContent()
end

function IChestUI:_innerInitContent()
    local maxSlots = self.container:GetSlotCount()
    for i = 1, maxSlots do
        UIUtil.hookSlot(self.rootLayer:getChildByTag(i - 1), self, i - 1)
    end
    local btnSort = self.rootLayer:getChild("btn_sort")
    local btnQuickPick = self.rootLayer:getChild("btn_quick_pick")
    local btnQuickPush = self.rootLayer:getChild("btn_quick_push")
    local btnQuickStack = self.rootLayer:getChild("btn_quick_stack")
    if btnSort:valid() then
        btnSort:addTouchUpListener({ IChestUI.OnSortBtnClicked, self })
    end
    if btnQuickPick:valid() then
        btnQuickPick:addTouchUpListener({ IChestUI.OnQuickPickBtnClicked, self })
    end
    if btnQuickPush:valid() then
        btnQuickPush:addTouchUpListener({ IChestUI.OnQuickPushBtnClicked, self })
    end
    if btnQuickStack:valid() then
        btnQuickStack:addTouchUpListener({ IChestUI.OnQuickStackBtnClicked, self })
    end
    self.ui.root:addTouchUpListener({ IChestUI.OnBgClicked, self })
end

function IChestUI:OnSortBtnClicked()
    self.ui.manager:playClickSound()
    self:TriggerServerEvent(UIData.EventID.SortChest)
end

function IChestUI:OnQuickPushBtnClicked()
    self.ui.manager:playClickSound()
    self:TriggerServerEvent(UIData.EventID.QuickPush)
end

function IChestUI:OnQuickPickBtnClicked()
    self.ui.manager:playClickSound()
    self:TriggerServerEvent(UIData.EventID.QuickPick)
end

function IChestUI:OnQuickStackBtnClicked()
    self.ui.manager:playClickSound()
    self:TriggerServerEvent(UIData.EventID.QuickStack)
end

function IChestUI:OnBgClicked()
    if require("ui.UISlotOp").onCheckPCDropOutItem() then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(Mod.current, self.guiID)
    end
end

function IChestUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
end

---checkSlotShiftMove
---@param slotIndex int
---@param itemStack ItemStack
function IChestUI:checkSlotShiftMove(slotIndex, itemStack)
    if slotIndex < 50 then
        -- shortcut/backpack to chest
        return self.container, 50, self.container:GetSlotCount() - 50
    else
        -- chest to shortcut/backpack
        return self.container, 0, 50
    end
end

return IChestUI