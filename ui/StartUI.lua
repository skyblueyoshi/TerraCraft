---@class TC.StartUI:TC.UIWindow
local StartUI = class("StartUI", require("UIWindow"))
local Locale = require("languages.Locale")
local UISpritePool = require("ui.UISpritePool")

function StartUI:__init()
    StartUI.super.__init(self, require("UIDesign").getStartUI())

    self._logoTexture = nil
    self._subLogoTexture = nil
    self._ticks = 0
    self._logoSize = 1
    self._logoAngle = 0

    self:initContent()
end

function StartUI:initContent()

    self._logoTexture = UISpritePool.getInstance():get("tc:logo4").textureLocation
    self._subLogoTexture = UISpritePool.getInstance():get("tc:sublogo").textureLocation

    UIText.cast(self.root:getChild("lb_mod")).text = string.format(Locale.MOD_LOADER_INFO, Mod.modList.count)
    print(App.engineVersion)
    UIText.cast(self.root:getChild("lb_engine_ver")).text = string.format(Locale.ENGINE_VERSION, App.engineVersion)
    UIText.cast(self.root:getChild("lb_game_ver")).text = string.format(Locale.GAME_VER, Mod.current.gameVersion .. " " .. Mod.current.version)

    self.root:getChild("layer.btn_single"):addTouchUpListener({
        function(self)
            self:_jumpTo(require("PlayerListUI"))
        end, self
    })
    self.root:getChild("layer.btn_mul_player"):addTouchUpListener({
        function(self)
            require("tc.ui.InfoPopupUI").new("功能开发中，敬请期待！")
            --self:_jumpTo(require("ServerListUI"))
        end, self
    })
    self.root:getChild("layer.btn_community"):addTouchUpListener({
        function(self)
            require("tc.ui.InfoPopupUI").new("欢迎加入正式论坛：https://terracraft.eu.org/")
            --self:_jumpTo(require("ServerListUI"))
        end, self
    })
    self.root:getChild("layer.btn_lang"):addTouchUpListener({
        function(self)
            require("tc.ui.InfoPopupUI").new("功能开发中，敬请期待！")
            --self:_jumpTo(require("LanguageUI"))
        end, self
    })
    self.root:getChild("layer.btn_mod"):addTouchUpListener({
        function(self)
            self:_jumpTo(require("ModListUI"))
        end, self
    })
    self.root:getChild("layer.btn_setting"):addTouchUpListener({
        function(self)
            self:closeWindow()
            self.manager:playClickSound()
            require("SettingUI").new(function()
                StartUI.new()
            end)
        end, self
    })
    self.root:getChild("layer.btn_exit"):addTouchUpListener({
        function()
            ClientStateManager.QuitGame()
        end
    })

    self.root:getPreDrawLayer(0):addListener({ StartUI.renderLogo, self })
    self:initUpdateFunc({ self._onUpdate, self })
end

function StartUI:_onUpdate()
    self._logoSize = 1.05 + Utils.SinValue(self._ticks, 256) * 0.05
    self._logoAngle = Utils.CosValue(self._ticks, 512) * 0.05
    self._ticks = self._ticks + 1
end

function StartUI:renderLogo()

    -- render the main logo
    local texSize = TextureManager.getSourceRect(self._logoTexture)
    local pos = Vector2.new(GameWindow.displayResolution.width / 2, 60)
    local exLogo = SpriteExData.new()
    exLogo.angle = self._logoAngle
    exLogo.origin = Vector2.new(texSize.width / 2, texSize.height / 2)
    exLogo.scaleRate = Vector2.new(self._logoSize, self._logoSize)
    Sprite.draw(self._logoTexture, Vector2.new(GameWindow.displayResolution.width / 2, 60),
            texSize, Color.White, exLogo, 0)

    -- render the sub logo
    local texSubLogoSize = TextureManager.getSourceRect(self._subLogoTexture)
    local exSubLogo = SpriteExData.new()
    exSubLogo.origin = Vector2.new(texSubLogoSize.width / 2, texSubLogoSize.height / 2)
    exSubLogo.scaleRate = Vector2.new(1.3, 1.3)
    Sprite.draw(self._subLogoTexture, Vector2.new(GameWindow.displayResolution.width / 2, 100),
            texSubLogoSize, Color.White, exSubLogo, 0)

end

function StartUI:_jumpTo(WindowClass)
    self.manager:playClickSound()
    self:closeWindow()
    WindowClass.new()
end

function StartUI:closeWindow()
    StartUI.super.closeWindow(self)
end

return StartUI