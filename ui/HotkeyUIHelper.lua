---@class TC.HotkeyUIHelper
local HotkeyUIHelper = class("HotkeyUIHelper")
local InputControl = require("client.InputControl")

function HotkeyUIHelper:__init(mod, guiID, data)
    self._mod = mod
    self._guiID = guiID

    self._closeHotkey = Input.keyboard:getHotKeys(Keys.Escape):addListener({ HotkeyUIHelper._closeMe, self })
    self._bpCloseKey = InputControl.getInstance().keyMap.Backpack
    self._closeHotkeyBp = Input.keyboard:getHotKeys(self._bpCloseKey):addListener({ HotkeyUIHelper._closeMe, self })
end

function HotkeyUIHelper:destroy()
    if self._closeHotkey then
        Input.keyboard:getHotKeys(Keys.Escape):removeListener(self._closeHotkey)
        self._closeHotkey = nil
    end
    if self._closeHotkeyBp then
        Input.keyboard:getHotKeys(self._bpCloseKey):removeListener(self._closeHotkeyBp)
        self._closeHotkeyBp = nil
    end
end

function HotkeyUIHelper:_closeMe()
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player:CloseGui(self._mod, self._guiID)
    end
end

return HotkeyUIHelper