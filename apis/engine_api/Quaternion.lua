---@class Quaternion:Vector4
---@field identity Quaternion
---@field eulerAngles Vector3
---@field matrix Matrix
local Quaternion = {}

---angle
---@param lhs Quaternion
---@param rhs Quaternion
---@return number
function Quaternion.angle(lhs, rhs)
end

---euler
---@param yaw number
---@param pitch number
---@param roll number
---@return Quaternion
function Quaternion.euler(yaw, pitch, roll)
end

---euler
---@param eulerAngles Vector3
---@return Quaternion
function Quaternion.euler(eulerAngles)
end

---AngleAxis
---@param angle number
---@param axis Vector3
---@return Quaternion
function Quaternion.angleAxis(angle, axis)
end

---toAngleAxis
---@return number, Vector3
function Quaternion:toAngleAxis()
end

---slerp
---@param a Quaternion
---@param b Quaternion
---@param t number
---@return Quaternion
function Quaternion.slerp(a, b, t)
end

---lerp
---@param a Quaternion
---@param b Quaternion
---@param t number
---@return Quaternion
function Quaternion.lerp(a, b, t)
end

---rotationFromTo
---@param fromDirection Vector3
---@param toDirection Vector3
---@return Quaternion
function Quaternion.rotationFromTo(fromDirection, toDirection)
end

return Quaternion