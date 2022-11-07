---@class Vector4:SerializableType
---@field x number
---@field y number
---@field z number
---@field w number
---@field length number
---@field lengthSquared number
---@field zero Vector4
---@field one Vector4
---@field unitX Vector4
---@field unitY Vector4
---@field unitZ Vector4
---@field unitW Vector4
local Vector4 = {}

---
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

---clone
---@param value Vector4
---@return Vector4
function Vector4.clone(value)
end

---
---@param value Vector4
---@return Vector4
function Vector4.normalize(value)
end

---
---@param value1 Vector4
---@param value2 Vector4
---@return Vector4
function Vector4.max(value1, value2)
end

---
---@param value1 Vector4
---@param value2 Vector4
---@return Vector4
function Vector4.min(value1, value2)
end

---
---@param value Vector4
---@return Vector4
function Vector4.floor(value)
end

---
---@param value Vector4
---@return Vector4
function Vector4.ceil(value)
end

---
---@param vallue Vector4
---@param min Vector4
---@param max Vector4
---@return Vector4
function Vector4.clamp(value, min, max)
end

---
---@param value1 Vector4
---@param value2 Vector4
---@return number
function Vector4.getDistance(value1, value2)
end

---
---@param value1 Vector4
---@param value2 Vector4
---@return number
function Vector4.getDistanceSquared(value1, value2)
end

---
---@param value1 Vector4
---@param value2 Vector4
---@return number
function Vector4.dot(value1, value2)
end

return Vector4