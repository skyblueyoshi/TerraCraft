---@class TC.InfoPopupUI:TC.UIWindow
local InfoPopupUI = class("InfoPopupUI", require("UIWindow"))

function InfoPopupUI:__init(content, okCallback, cancelCallback, largeWindow)
    InfoPopupUI.super.__init(self, require("UIDesign").getInfoPopupUI())
    self._okCallback = okCallback
    self._cancelCallback = cancelCallback
    self._content = content
    self._largeWindow = largeWindow
    self:initContent()
end

function InfoPopupUI:setInfo(info)
    UIText.cast(self.root:getChild("layer.panel_info.lb_info")).text = info
end

function InfoPopupUI:initContent()
    local layer = self.root:getChild("layer")
    if self._largeWindow then
        layer.size = Size.new(1000, 500)
        layer:applyMargin()
    end
    layer:getChild("btn_back"):addTouchUpListener({ self._onBackClicked, self })
    layer:getChild("btn_ok"):addTouchUpListener({ self._onOkClicked, self })
    self:setInfo(self._content)
end

function InfoPopupUI:_onBackClicked()
    self.manager:playClickSound()
    self:closeWindow()
    if self._cancelCallback then
        self._cancelCallback()
    end
end

function InfoPopupUI:_onOkClicked()
    if self._okCallback then
        self._okCallback()
    end
    self:_onBackClicked()
end

function InfoPopupUI:closeWindow()
    InfoPopupUI.super.closeWindow(self)
end

return InfoPopupUI