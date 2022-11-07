---@class TC.NewServerUI:TC.UIWindow
local NewServerUI = class("NewServerUI", require("UIWindow"))

function NewServerUI:__init()
    NewServerUI.super.__init(self, require("UIDesign").getNewServerUI())
    self:initContent()
end

function NewServerUI:initContent()
    self.root:getChild("layer.btn_back"):addTouchUpListener({
        function(self)
            local ServerListUI = require("ServerListUI")
            self:closeWindow()
            ServerListUI.new()
        end, self }
    )
end

function NewServerUI:closeWindow()
    NewServerUI.super.closeWindow(self)
end

return NewServerUI