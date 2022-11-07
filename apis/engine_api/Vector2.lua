---@class Vector2:SerializableType
---@field x number
---@field y number
---@field length number
---@field lengthSquared number
---@field angle number
---@field zero Vector2
---@field one Vector2
---@field unitX Vector2
---@field unitY Vector2
local Vector2 = {}

---
---@overload fun():Vector2
---@param x number
---@param y number
---@return Vector2
function Vector2.new(x, y)
end

---clone
---@param value Vector2
---@return Vector2
function Vector2.clone(value)
end

---
---@param other Vector2
---@return number
function Vector2:getAngleTo(other)
end

---
---@param other Vector2
---@return number
function Vector2:getAngleFrom(other)
end

---
---@param value Vector2
---@return Vector2
function Vector2.normalize(value)
end

---
---@param value1 Vector2
---@param value2 Vector2
---@return Vector2
function Vector2.max(value1, value2)
end

---
---@param value1 Vector2
---@param value2 Vector2
---@return Vector2
function Vector2.min(value1, value2)
end

---
---@param value Vector2
---@return Vector2
function Vector2.floor(value)
end

---
---@param value Vector2
---@return Vector2
function Vector2.ceil(value)
end

---
---@param vallue Vector2
---@param min Vector2
---@param max Vector2
---@return Vector2
function Vector2.clamp(value, min, max)
end

---
---@param value1 Vector2
---@param value2 Vector2
---@return number
function Vector2.getDistance(value1, value2)
end

---
---@param value1 Vector2
---@param value2 Vector2
---@return number
function Vector2.getDistanceSquared(value1, value2)
end

---
---@param value1 Vector2
---@param value2 Vector2
---@return number
function Vector2.dot(value1, value2)
end

return Vector2