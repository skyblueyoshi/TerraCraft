local RawHotkeyUIHelper = class("HotkeyUIHelper")

function RawHotkeyUIHelper:__init(uiWindow)
    self._uiWindow = uiWindow
    self._closeHotkey = Input.keyboard:getHotKeys(Keys.Escape):addListener({ RawHotkeyUIHelper._closeMe, self })
end

function RawHotkeyUIHelper:destroy()
    if self._closeHotkey then
        Input.keyboard:getHotKeys(Keys.Escape):removeListener(self._closeHotkey)
        self._closeHotkey = nil
    end
end

function RawHotkeyUIHelper:_closeMe()
    self._uiWindow:closeWindow()
end

return RawHotkeyUIHelper