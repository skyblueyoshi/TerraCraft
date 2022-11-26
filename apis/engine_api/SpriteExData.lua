---@API

---@class SpriteExData 描述精灵绘制拓展信息。
---@field scaleRateX number 精灵绘制时横向放大比例。
---@field scaleRateY number 精灵绘制时纵向放大比例。
---@field originX number 精灵绘制原点横坐标。
---@field originY number 精灵绘制原点纵坐标。
---@field scaleRate Vector2 精灵绘制时放大比例。
---@field origin Vector2 精灵绘制原点坐标。
---@field angle number 精灵绘制的旋转角度。
---@field flipHorizontal boolean 精灵绘制时是否水平翻转。
---@field flipVertical boolean 精灵绘制时是否竖直翻转。
local SpriteExData = {}

---创建一个精灵绘制拓展信息对象。
---@return SpriteExData 新的精灵绘制拓展信息对象。
function SpriteExData.new()
end

return SpriteExData