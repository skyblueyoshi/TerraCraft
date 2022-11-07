---@class Sprite
local Sprite = {}

function Sprite.beginBatch()
end

function Sprite.endBatch()
end

function Sprite.flush()
end

---draw
---@overload fun(textureLocation:TextureLocation,pos:Vector2,sourceOffset:Rect,color:Color)
---@overload fun(textureLocation:TextureLocation,pos:Vector2,sourceOffset:Rect,color:Color,depth:number)
---@param textureLocation TextureLocation
---@param pos Vector2
---@param sourceRect Rect
---@param color Color
---@param exData SpriteExData
---@param depth number
function Sprite.draw(textureLocation, pos, sourceRect, color, exData, depth)
end

return Sprite