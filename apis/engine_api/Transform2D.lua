---@class Transform2D
---@field position Vector2
---@field rotation number
---@field scale Vector2
---@field origin Vector2
---@field matrix Matrix
---@field worldMatrix Matrix
local Transform2D = {}

---new
---@overload fun():Transform2D
---@overload fun(position:Vector2):Transform2D
---@overload fun(position:Vector2,rotation:number):Transform2D
---@param position Vector2
---@param rotation number
---@param scale Vector2
---@return Transform2D
function Transform2D.new(position, rotation, scale)
end

return Transform2D