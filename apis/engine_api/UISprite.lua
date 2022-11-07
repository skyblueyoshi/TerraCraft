---@class UISprite:SerializableType
---@field textureName string
---@field textureLocation TextureLocation
---@field slices9 UISlices9
---@field color Color
---@field style UISpriteStyle_Value
---@field positionOffset Vector2
local UISprite = {}

---new
---@overload fun():UISprite
---@param textureName string
---@return UISprite
function UISprite.new(textureName)
end

---clone
---@param value UISprite
---@return UISprite
function UISprite.clone(value)
end

return UISprite