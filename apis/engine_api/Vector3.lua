---@class Vector3:SerializableType
---@field x number
---@field y number
---@field z number
---@field length number
---@field lengthSquared number
---@field zero Vector3
---@field one Vector3
---@field unitX Vector3
---@field unitY Vector3
---@field unitZ Vector3
---@field up Vector3
---@field down Vector3
---@field left Vector3
---@field right Vector3
---@field forward Vector3
---@field back Vector3
local Vector3 = {}

---
---@overload fun():Vector3
---@overload fun(value:Vector2,z:number):Vector3
---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3.new(x, y, z)
end

---clone
---@param value Vector3
---@return Vector3
function Vector3.clone(value)
end

---
---@param value Vector3
---@return Vector3
function Vector3.normalize(value)
end

---
---@param value1 Vector3
---@param value2 Vector3
---@return Vector3
function Vector3.max(value1, value2)
end

---
---@param value1 Vector3
---@param value2 Vector3
---@return Vector3
function Vector3.min(value1, value2)
end

---
---@param value Vector3
---@return Vector3
function Vector3.floor(value)
end

---
---@param value Vector3
---@return Vector3
function Vector3.ceil(value)
end

---
---@param vallue Vector3
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

---
---@param value1 Vector3
---@param value2 Vector3
---@return number
function Vector3.getDistanceSquared(value1, value2)
end

---
---@param value1 Vector3
---@param value2 Vector3
---@return number
function Vector3.dot(value1, value2)
end

---
---@param value1 Vector3
---@param value2 Vector3
---@return Vector3
function Vector3.cross(value1, value2)
end

return Vector3