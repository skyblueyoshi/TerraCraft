---@API

---@class Quaternion:Vector4 描述一个四元数。
---@field identity Quaternion 返回归一化四元数。
---@field eulerAngles Vector3 返回或设置欧拉旋转轴。
---@field matrix Matrix 返回或设置其矩阵形式。
local Quaternion = {}

---返回两个四元数之间的角度。
---@param lhs Quaternion
---@param rhs Quaternion
---@return number
function Quaternion.angle(lhs, rhs)
end

---由欧拉角创建一个四元数。
---@param yaw number
---@param pitch number
---@param roll number
---@return Quaternion
function Quaternion.euler(yaw, pitch, roll)
end

---由欧拉角创建一个四元数。
---@param eulerAngles Vector3
---@return Quaternion
function Quaternion.euler(eulerAngles)
end

---创建一个绕着指定轴旋转指定角度的旋转四元数。
---@param angle number
---@param axis Vector3
---@return Quaternion
function Quaternion.angleAxis(angle, axis)
end

---获得旋转轴和旋转角度。
---@return number,Vector3
function Quaternion:toAngleAxis()
end

---在四元数a和b之间进行球形插值。
---@param a Quaternion
---@param b Quaternion
---@param t number 插值因子[0, 1]。
---@return Quaternion
function Quaternion.slerp(a, b, t)
end

---在四元数a和b之间进行插值。
---@param a Quaternion
---@param b Quaternion
---@param t number 插值因子[0, 1]。
---@return Quaternion
function Quaternion.lerp(a, b, t)
end

---创建一个从角度fromDirection到角度toDirection的旋转四元数。
---@param fromDirection Vector3
---@param toDirection Vector3
---@return Quaternion
function Quaternion.rotationFromTo(fromDirection, toDirection)
end

return Quaternion