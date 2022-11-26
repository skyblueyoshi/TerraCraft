---@API

---@class Vector2:SerializableType 描述一个2维向量。
---@field x number
---@field y number
---@field length number 向量长度。
---@field lengthSquared number 向量长度的平方。
---@field angle number 向量到原点的角度。
---@field zero Vector2 返回零向量。
---@field one Vector2 返回全1向量。
---@field unitX Vector2 返回X轴单位向量。
---@field unitY Vector2 返回Y轴单位向量。
local Vector2 = {}

---@overload fun():Vector2
---@param x number
---@param y number
---@return Vector2
function Vector2.new(x, y)
end

---@param value Vector2
---@return Vector2
function Vector2.clone(value)
end

---获取向量到另一个向量的角度。
---@param other Vector2
---@return number
function Vector2:getAngleTo(other)
end

---获取另一个向量到当前向量的角度。
---@param other Vector2
---@return number
function Vector2:getAngleFrom(other)
end

---向量单位化。
---@param value Vector2
---@return Vector2
function Vector2.normalize(value)
end

---获取两个向量的最大值向量。
---@param value1 Vector2
---@param value2 Vector2
---@return Vector2
function Vector2.max(value1, value2)
end

---获取两个向量的最小值向量。
---@param value1 Vector2
---@param value2 Vector2
---@return Vector2
function Vector2.min(value1, value2)
end

---将每个维度向下取整。
---@param value Vector2
---@return Vector2
function Vector2.floor(value)
end

---将每个维度向上取整。
---@param value Vector2
---@return Vector2
function Vector2.ceil(value)
end

---限制向量到给定范围。
---@param value Vector2
---@param min Vector2
---@param max Vector2
---@return Vector2
function Vector2.clamp(value, min, max)
end

---获取向量之间的距离。
---@param value1 Vector2
---@param value2 Vector2
---@return number
function Vector2.getDistance(value1, value2)
end

---获取向量之间的距离平方。
---@param value1 Vector2
---@param value2 Vector2
---@return number
function Vector2.getDistanceSquared(value1, value2)
end

---将两个向量点乘，即每个维度乘积之和。
---@param value1 Vector2
---@param value2 Vector2
---@return number
function Vector2.dot(value1, value2)
end

return Vector2