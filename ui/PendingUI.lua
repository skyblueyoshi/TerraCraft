---@class TC.PendingUI:TC.UIWindow
local PendingUI = class("PendingUI", require("UIWindow"))
local Locale = require("languages.Locale")
local UISpritePool = require("ui.UISpritePool")

local ANIMATION_SCALE = 2

function PendingUI:__init()
    PendingUI.super.__init(self, require("UIDesign").getPendingUI())
    self._closeBtn = UIButton.cast(self.root:getChild("layer.btn_back"))
    self._aniPanel = UIPanel.cast(self.root:getChild("layer.panel_animation"))
    self._lbTip = UIText.cast(self.root:getChild("layer.lb_tip"))

    self._aniTexture = nil
    self._ticks = 0
    self._aniFrameIndex = 0

    self:initContent()
end

function PendingUI:initContent()

    self._aniTexture = UISpritePool.getInstance():get("tc:pending_animation").textureLocation

    self._closeBtn:addTouchUpListener({
        function(self)
            ClientStateManager.SaveAndExitGaming()
            self:_jumpTo(require("StartUI"))
        end, self
    })
    self._closeBtn.visible = false

    self._lbTip.text = ""
    if ClientState.current == ClientState.Joining or ClientState.current == ClientState.LoadingWorld then
        local tod = require("TipsOfTheDay").new()
        self._lbTip.text = tod:getRandomText()
    elseif ClientState.current == ClientState.SavingWorld then
        self._lbTip.text = Locale.PENDING_SAVING
    elseif ClientState.current == ClientState.LosingConnection then
        self._lbTip.text = Locale.PENDING_NO_CONNECTION
        self._closeBtn.visible = true
    end

    self._aniPanel:getPostDrawLayer(0):addListener({ PendingUI._renderAnimation, self })
    self:initUpdateFunc({ self._onUpdate, self })

end

function PendingUI:_onUpdate()
    self._ticks = self._ticks + 1
    self._aniFrameIndex = math.floor(self._ticks / 8) % 4
end

function PendingUI:_renderAnimation(node, canvasPos)
    local pos = node.positionInCanvas + canvasPos + Vector2.new(node.width * 0.5, node.height * 0.5)
    local rectCut = Rect.new(32 * self._aniFrameIndex, 0, 32, 32)
    local exData = SpriteExData.new()
    exData.originX = 16
    exData.originY = 16

    exData.scaleRateX = ANIMATION_SCALE
    exData.scaleRateY = ANIMATION_SCALE
    Sprite.draw(self._aniTexture, pos, rectCut, Color.White, exData, 1.0)
end

function PendingUI:_jumpTo(WindowClass)
    self:closeWindow()
    self.manager:playClickSound()
    WindowClass.new()
end

function PendingUI:closeWindow()
    PendingUI.super.closeWindow(self)
end

return PendingUI