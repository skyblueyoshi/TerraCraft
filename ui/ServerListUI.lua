---@class TC.ServerListUI:TC.UIWindow
local ServerListUI = class("ServerListUI", require("UIWindow"))
local UIUtil = require("UIUtil")

function ServerListUI:__init()
    ServerListUI.super.__init(self, require("UIDesign").getServerListUI())
    self.indexSelected = 0
    self.itemNodes = {}
    self:initContent()
end

function ServerListUI:initContent()
    local panelList = self.root:getChild("layer.panel_list")
    local panelItem = panelList:getChild("panel_item")
    self.itemSize = Size.new(panelItem.width / 1, panelItem.height)
    UIUtil.setTable(panelList, self, true, 1)
    self:updateSelection()
    self.root:getChild("layer.btn_back"):addTouchUpListener({
        function(self)
            local PlayerListUI = require("PlayerListUI")
            self:closeWindow()
            PlayerListUI.new()
        end, self }
    )
    self.root:getChild("layer.btn_create"):addTouchUpListener({
        function(self)
            local NewServerUI = require("NewServerUI")
            self:closeWindow()
            NewServerUI.new()
        end, self
    })
end

function ServerListUI:_getTableElementCount()
    return 5
end

function ServerListUI:_getTableElementSize()
    return self.itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function ServerListUI:_setTableElement(node, index)
    node.tag = index
    node:addTouchUpListener({ self._onElementClicked, self })
    node:getChild("btn_remove"):addTouchUpListener({
        function(self)
            local InfoPopupUI = require("InfoPopupUI")
            InfoPopupUI.new()
        end, self
    })
    table.insert(self.itemNodes, node)
end

---_onElementClicked
---@param node UINode
---@param _ Touch
function ServerListUI:_onElementClicked(node)
    local index = node.tag
    self.indexSelected = index
    self:updateSelection()
end

function ServerListUI:updateSelection()
    ---@param node UINode
    for _, node in pairs(self.itemNodes) do

        local show = false
        if node.tag == self.indexSelected then
            show = true
        end

        node:getChild("img_selected").visible = show
        node:getChild("btn_remove").visible = show
        node:getChild("btn_cfg").visible = show
    end
end

function ServerListUI:closeWindow()
    ServerListUI.super.closeWindow(self)
end

return ServerListUI