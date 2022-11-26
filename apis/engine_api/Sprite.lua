---@API

---@class Sprite 精灵渲染类。
local Sprite = {}

---开始一批精灵渲染。
function Sprite.beginBatch()
end

---结束一批精灵渲染。
function Sprite.endBatch()
end

---将当前缓存的所有精灵，立即绘制到帧缓存上。
function Sprite.flush()
end

---绘制一个精灵。
---@overload fun(textureLocation:TextureLocation,pos:Vector2,sourceOffset:Rect,color:Color)
---@overload fun(textureLocation:TextureLocation,pos:Vector2,sourceOffset:Rect,color:Color,depth:number)
---@param textureLocation TextureLocation 待绘制的纹理。
---@param pos Vector2 绘制在帧缓存上的坐标。
---@param sourceRect Rect 绘制纹理的剪裁区域。
---@param color Color 绘制精灵的颜色。
---@param exData SpriteExData 精灵绘制拓展信息。
---@param depth number 绘制到帧缓存上的深度。
function Sprite.draw(textureLocation, pos, sourceRect, color, exData, depth)
end

return Sprite