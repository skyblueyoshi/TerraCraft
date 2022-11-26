---@API

---@class RectFloat:SerializableType 描述一个矩形区域，坐标精度为float，尺寸精度为int。
---@field x number 矩形左上角横坐标。
---@field y number 矩形左上角纵坐标。
---@field width number 矩形宽度。
---@field height number 矩形高度。
---@field rightX number 矩形右边缘横坐标。
---@field bottomY number 矩形下边缘纵坐标。
---@field centerX number 矩形中心横坐标。
---@field centerY number 矩形中心纵坐标。
local RectFloat = {}

---创建一个矩形区域对象。
---@param x number
---@param y number
---@param width number
---@param height number
---@return RectFloat 新的矩形区域对象。
function RectFloat.new(x, y, width, height)
end

return RectFloat