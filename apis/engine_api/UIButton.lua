---@class UIButton:UINode
---@field targetSprite UISprite
---@field highlightedSprite UISprite
---@field pressedSprite UISprite
---@field selectedSprite UISprite
---@field disabledSprite UISprite
---@field selected boolean
local UIButton = {}

---new
---@overload fun(name:string):UIButton
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIButton
function UIButton.new(name, x, y, width, height)
end

---
---@param value UIButton
---@return UIButton
function UIButton.clone(value)
end

---case
---@param uiNode UINode
---@return UIButton
function UIButton.cast(uiNode)
end

return UIButton