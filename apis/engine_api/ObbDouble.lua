---@API

---@class ObbDouble:SerializableType 描述一个旋转矩形对象。
---@field centerX number 矩形中心点横坐标。
---@field centerY number 矩形中心点纵坐标。
---@field width number 矩形宽度。
---@field height number 矩形高度。
---@field angle number 矩形旋转角度。
local ObbDouble = {}

---创建一个旋转矩形对象。
---@param centerX number 矩形中心点横坐标。
---@param centerY number 矩形中心点纵坐标。
---@param width number 矩形宽度。
---@param height number 矩形高度。
---@param angle number 矩形旋转角度。
---@return ObbDouble 新的旋转矩形对象。
function ObbDouble.new(centerX, centerY, width, height, angle)
end

---判断当前旋转矩形是否与另一个旋转矩形重叠。
---@param otherObb ObbDouble
---@return boolean
function ObbDouble:isOverlapping(otherObb)
end

---判断指定点是否在当前旋转矩形区域内。
---@param vector2 Vector2
---@return boolean
function ObbDouble:isPointIn(vector2)
end

---获取矩形空间内的点在矩形空间外的实际坐标。
---@param xInSource number 矩形空间内的点X。
---@param yInSource number 矩形空间内的点Y。
---@return number,number
function ObbDouble:convertFromSourceRectSpace(xInSource, yInSource)
end

return ObbDouble