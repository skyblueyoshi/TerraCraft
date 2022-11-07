---@class UIImage:UINode
---@field sprite UISprite
local UIImage = {}

---new
---@overload fun(name:string):UIImage
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIImage
function UIImage.new(name, x, y, width, height)
end

---
---@param value UIImage
---@return UIImage
function UIImage.clone(value)
end

---case
---@param uiNode UINode
---@return UIImage
function UIImage.cast(uiNode)
end

return UIImage