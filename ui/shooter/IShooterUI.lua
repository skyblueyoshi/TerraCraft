---@class TC.IShooterUI:GuiContainer
local IShooterUI = class("IShooterUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local GuiID = require("ui.GuiID")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")

---@param container TC.IChestContainerClient
function IShooterUI:__init(rootNode, container)
    IShooterUI.super.__init(self, container)

    self.ui = require("ui.UIWindow").new(rootNode, require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.rootLayer = self.ui.root:getChild("layer")

    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Shooter9)
    self:_innerInitContent()
end

function IShooterUI:_innerInitContent()
    local maxSlots = self.container:GetSlotCount()
    for i = 1, maxSlots do
        UIUtil.hookSlot(self.rootLayer:getChildByTag(i - 1), self, i - 1)
    end
end

function IShooterUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
end

return IShooterUI