---@class JointBody2D
---@field joints JointCollection2D
---@field animator Animator2D
local JointBody2D = {}

---new
---@param jointCollection2D JointCollection2D
---@return JointBody2D
function JointBody2D.new(jointCollection2D)
end

---@return JointBody2D
function JointBody2D:clone()
end

---update
---@overload fun()
---@param withAnimation boolean
function JointBody2D:update(withAnimation)
end

---setAnimator
---@param clipCollection2D ClipCollection2D
---@param animatorData2D Animator2D
function JointBody2D:setAnimator(clipCollection2D, animatorData2D)
end

---solveIK
---@overload fun(nodeEndName:string,nodeStartName:string,targetPos:Vector2):boolean
---@param nodeStartName string
---@param nodeEndName string
---@param nodeEnd Joint2D
---@param nodeStart Joint2D
---@param targetPos Vector2
---@return boolean
function JointBody2D:solveIK(nodeEnd, nodeStart, targetPos)
end

return JointBody2D