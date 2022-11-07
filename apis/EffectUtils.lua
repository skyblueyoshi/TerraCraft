---@class EffectUtils
local EffectUtils = {}

---
---
---@overload fun(id:int,centerX:double,centerY:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double,scale:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double,scale:double,alpha:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double,scale:double,alpha:double,color:Color):Effect
---@param id int
---@param centerX double
---@param centerY double
---@param speedX double
---@param speedY double
---@param rotateSpeed double
---@param scale double
---@param alpha double
---@param color Color
---@return Effect
function EffectUtils.Create(id, centerX, centerY, speedX, speedY, rotateSpeed, scale, alpha, color)
end

---@overload fun(id:int,centerX:double,centerY:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double,scale:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double,scale:double,alpha:double):Effect
---@overload fun(id:int,centerX:double,centerY:double,speedX:double,speedY:double,rotateSpeed:double,scale:double,alpha:double,color:Color):Effect
---@param id int
---@param centerX double
---@param centerY double
---@param speedX double
---@param speedY double
---@param rotateSpeed double
---@param scale double
---@param alpha double
---@param color Color
---@return Effect
function EffectUtils.SendFromServer(id, centerX, centerY, speedX, speedY, rotateSpeed, scale, alpha, color)
end

return EffectUtils