---@API

---@class Vector4:SerializableType 描述一个4维向量。
---@field x number
---@field y number
---@field z number
---@field w number
---@field length number 向量长度。
---@field lengthSquared number 向量长度的平方。
---@field zero Vector4 返回零向量。
---@field one Vector4 返回全1向量。
---@field unitX Vector4 返回X轴单位向量。
---@field unitY Vector4 返回Y轴单位向量。
---@field unitZ Vector4 返回Z轴单位向量。
---@field unitW Vector4 返回W轴单位向量。
local Vector4 = {}

---@overload fun():Vector4
---@overload fun(value:Vector2,z:number,w:number):Vector4
---@overload fun(value:Vector3,w:number):Vector4
---@param x number
---@param y number
---@param z number
---@param w number
---@return Vector4
function Vector4.new(x, y, z, w)
end

---@param value Vector4
---@return Vector4
function Vector4.clone(value)
end

---向量单位化。
---@param value Vector4
---@return Vector4
function Vector4.normalize(value)
end

---获取两个向量的最大值向量。
---@param value1 Vector4
---@param value2 Vector4
---@return Vector4
function Vector4.max(value1, value2)
end

---获取两个向量的最小值向量。
---@param value1 Vector4
---@param value2 Vector4
---@return Vector4
function Vector4.min(value1, value2)
end

---将每个维度向下取整。
---@param value Vector4
---@return Vector4
function Vector4.floor(value)
end

---将每个维度向上取整。
---@param value Vector4
---@return Vector4
function Vector4.ceil(value)
end

---限制向量到给定范围。
---@param value Vector4
---@param min Vector4
---@param max Vector4
---@return Vector4
function Vector4.clamp(value, min, max)
end

---获取向量之间的距离。
---@param value1 Vector4
---@param value2 Vector4
---@return number
function Vector4.getDistance(value1, value2)
end

---获取向量之间的距离平方。
---@param value1 Vector4
---@param value2 Vector4
---@return number
function Vector4.getDistanceSquared(value1, value2)
end

---将两个向量点乘，即每个维度乘积之和。
---@param value1 Vector4
---@param value2 Vector4
---@return number
function Vector4.dot(value1, value2)
end

return Vector4