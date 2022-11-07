---@class Joint2D
---@field transform Transform2D
---@field size Size
---@field angle number
---@field visible boolean
local Joint2D = {}

---new
---@param name string
---@param originalPos Vector2
---@param size Size
---@return Joint2D
function Joint2D.new(name, originalPos, size)
end

---addChild
---@overload fun(pos:Vector2,skeletonNode:Joint2D)
---@param pos Vector2
---@param skeletonNode Joint2D
---@param overlapping boolean
function Joint2D:addChild(pos, skeletonNode, overlapping)
end

---getChild
---@param name string
---@return Joint2D
function Joint2D:getChild(name)
end

---@return ObbDouble
function Joint2D:getWorldObb()
end

---setTexture
---@param textureName string
---@param textureLocation TextureLocation
---@param positionOffset Vector2
---@param sourceRect Rect
function Joint2D:setTexture(textureName, textureLocation, positionOffset, sourceRect)
end

return Joint2D