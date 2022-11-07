---@class UIPanel:UINode
---@field sprite UISprite
local UIPanel = {}

---new
---@overload fun(name:string):UIPanel
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIPanel
function UIPanel.new(name, x, y, width, height)
end

---
---@param value UIPanel
---@return UIPanel
function UIPanel.clone(value)
end

---case
---@param uiNode UINode
---@return UIPanel
function UIPanel.cast(uiNode)
end

return UIPanel