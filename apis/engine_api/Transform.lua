---@class Transform
---@field position Vector3
---@field rotation Quaternion
---@field scale Vector3
---@field origin Vector3
---@field eulerAngles Vector3
---@field matrix Matrix
local Transform = {}

---new
---@overload fun():Transform
---@overload fun(position:Vector3):Transform
---@overload fun(position:Vector3,rotation:Quaternion):Transform
---@param position Vector3
---@param rotation Quaternion
---@param scale Vector3
---@return Transform
function Transform.new(position, rotation, scale)
end

return Transform