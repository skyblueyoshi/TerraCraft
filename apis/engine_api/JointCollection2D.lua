---@class JointCollection2D
---@field root Joint2D
---@field position Vector2
---@field rotation number
---@field scale Vector2
---@field flip boolean
local JointCollection2D = {}

---new
---@return JointCollection2D
function JointCollection2D.new()
end

---getJoint
---@param name string
---@return Joint2D
function JointCollection2D:getJoint(name)
end

---render
---@overload fun()
---@param camera CameraComponentWrapper
function JointCollection2D:render(camera)
end

return JointCollection2D