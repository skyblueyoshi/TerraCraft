---@class TC.DeathUI:TC.UIWindow
local DeathUI = class("DeathUI", require("UIWindow"))
local Locale = require("languages.Locale")

function DeathUI:__init()
    DeathUI.super.__init(self, require("UIDesign").getDeathUI())
    self:initUpdateFunc({ self._onUpdate, self }, 60)

    self._lbCountDown = UIText.cast(self.root:getChild("panel.lb_title_2"))
    self._cd = 11
    self:_onUpdate()
end

function DeathUI:_onUpdate()
    if ClientState.current ~= ClientState.Gaming then
        self:closeWindow() -- tried fix stick DeathUI by suddenly close UIWindow
    end
    if self._cd > 1 then
        self._cd = self._cd - 1
    end
    self._lbCountDown.text = string.format(Locale.RESPAWNING, self._cd)
end

function DeathUI:closeWindow()
    DeathUI.super.closeWindow(self)
end

return DeathUI