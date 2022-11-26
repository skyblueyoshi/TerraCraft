---@API

---@class Vector3:SerializableType 描述一个3维向量。
---@field x number
---@field y number
---@field z number
---@field length number 向量长度。
---@field lengthSquared number 向量长度的平方。
---@field zero Vector3 返回零向量。
---@field one Vector3 返回全1向量。
---@field unitX Vector3 返回X轴单位向量。
---@field unitY Vector3 返回Y轴单位向量。
---@field unitZ Vector3 返回Z轴单位向量。
---@field up Vector3
---@field down Vector3
---@field left Vector3
---@field right Vector3
---@field forward Vector3
---@field back Vector3
local Vector3 = {}

---@overload fun():Vector3
---@overload fun(value:Vector2,z:number):Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3.new(x, y, z)
end

---@param value Vector3
---@return Vector3
function Vector3.clone(value)
end

---向量单位化。
---@param value Vector3
---@return Vector3
function Vector3.normalize(value)
end

---获取两个向量的最大值向量。
---@param value1 Vector3
---@param value2 Vector3
---@return Vector3
function Vector3.max(value1, value2)
end

---获取两个向量的最小值向量。
---@param value1 Vector3
---@param value2 Vector3
---@return Vector3
function Vector3.min(value1, value2)
end

---将每个维度向下取整。
---@param value Vector3
---@return Vector3
function Vector3.floor(value)
end

---将每个维度向上取整。
---@param value Vector3
---@return Vector3
function Vector3.ceil(value)
end

---限制向量到给定范围。
---@param value Vector3
---@param min Vector3
---@param max Vector3
---@return Vector3
function Vector3.clamp(value, min, max)
end

---
---@param value1 Vector3
---@param value2 Vector3
---@return number
function Vector3.getDistance(value1, value2)
end

---获取向量之间的距离。
---@param value1 Vector3
---@param value2 Vector3
---@return number
function Vector3.getDistanceSquared(value1, value2)
end

---将两个向量点乘，即每个维度乘积之和。
---@param value1 Vector3
---@param value2 Vector3
---@return number
function Vector3.dot(value1, value2)
end

---返回两个向量的叉积。
---@param value1 Vector3
---@param value2 Vector3
---@return Vector3
function Vector3.cross(value1, value2)
end

return Vector3