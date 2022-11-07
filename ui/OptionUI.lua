---@class TC.OptionUI:TC.UIWindow
local OptionUI = class("OptionUI", require("UIWindow"))
local Locale = require("languages.Locale")
local RawHotkeyUIHelper = require("ui.RawHotkeyUIHelper")

function OptionUI:__init()
    OptionUI.super.__init(self, require("UIDesign").getOptionUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self._hkHelper = RawHotkeyUIHelper.new(self)
    self:initContent()
end

function OptionUI:initContent()
    self.root:getChild("layer.btn_back"):addTouchUpListener({ OptionUI._onBtnBackClicked, self })
    self.root:getChild("layer.btn_setting"):addTouchUpListener({ OptionUI._onBtnSettingClicked, self })
    self.root:getChild("layer.btn_recipe"):addTouchUpListener({ OptionUI._onBtnRecipeClicked, self })
    self.root:getChild("layer.btn_advancement"):addTouchUpListener({ OptionUI._onBtnAdvancementClicked, self })
    self.root:getChild("layer.btn_save_and_exit"):addTouchUpListener({ OptionUI._onBtnSaveAndExitClicked, self })
end

function OptionUI:_onBtnBackClicked()
    self:closeWindow()
    self.manager:playClickSound()
end

function OptionUI:_onBtnSettingClicked()
    self:closeWindow()
    self.manager:playClickSound()
    require("SettingUI").new(function()
        OptionUI.new()
    end)
end

function OptionUI:_onBtnRecipeClicked()
    self:closeWindow()
    self.manager:playClickSound()
    require("ui.nei.NeiUI").new()
end

function OptionUI:_onBtnAdvancementClicked()
    self:closeWindow()
    self.manager:playClickSound()

    local player = PlayerUtils.GetCurrentClientPlayer()
    if not player then
        return
    end
    local GuiID = require("ui.GuiID")
    if player:IsGuiOpened(Mod.current, GuiID.Advancement) then
        return
    end
    player:OpenGui(Mod.current, GuiID.Advancement, player.centerXi, player.centerYi)
end

function OptionUI:_onBtnSaveAndExitClicked()
    self:closeWindow()
    self.manager:playClickSound()
    ClientStateManager.SaveAndExitGaming()
end

function OptionUI:closeWindow()
    self._hkHelper:destroy()
    OptionUI.super.closeWindow(self)
end

return OptionUI