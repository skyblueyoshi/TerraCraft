---@class TC.LanguageUI:TC.UIWindow
local LanguageUI = class("LanguageUI", require("UIWindow"))
local UIUtil = require("UIUtil")

function LanguageUI:__init()
    LanguageUI.super.__init(self, require("UIDesign").getLanguageUI())
    self.indexSelected = 1
    self.itemNodes = {}
    self:initContent()
end

function LanguageUI:initContent()
    local panel_list = self.root:getChild("layer.panel_list")
    local panel_item = panel_list:getChild("panel_item")
    self.itemSize = Size.new(panel_item.width / 1, panel_item.height)
    UIUtil.setTable(panel_list, self, true, 1)
    self:updateSelection()
    self.root:getChild("layer.btn_ok"):addTouchUpListener({
        function(self)
            local StartUI = require("StartUI")
            self:closeWindow()
            StartUI.new()
        end, self }
    )
end

function LanguageUI:_getTableElementCount()
    return 5
end

function LanguageUI:_getTableElementSize()
    return self.itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function LanguageUI:_setTableElement(node, index)
    node.tag = index
    local lb_text = UIText.cast(node:getChild("lb_locale"))
    lb_text.text = lb_text.text .. tostring(index)
    node:addTouchUpListener({ self._onElementClicked, self })
    if index == 1 then
        lb_text.text = "简体中文"
    end
    table.insert(self.itemNodes, node)
end

---_onElementClicked
---@param node UINode
function LanguageUI:_onElementClicked(node)
    local index = node.tag
    self.indexSelected = index
    self:updateSelection()
end

function LanguageUI:updateSelection()
    ---@param node UINode
    for _, node in pairs(self.itemNodes) do
        if node.tag == self.indexSelected then
            node:getChild("img_selected").visible = true
        else
            node:getChild("img_selected").visible = false
        end
    end
end

function LanguageUI:closeWindow()
    LanguageUI.super.closeWindow(self)
end

return LanguageUI