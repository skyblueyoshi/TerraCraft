---@class Animator2D
local Animator2D = {}

---setFloat
---@param parameterName string
---@param value number
function Animator2D:setFloat(parameterName, value)
end

---getFloat
---@param parameterName string
---@return number
function Animator2D:getFloat(parameterName)
end

---
---@param parameterName string
---@param value number
function Animator2D:setInteger(parameterName, value)
end

---
---@param parameterName string
---@return number
function Animator2D:getInteger(parameterName)
end

---
---@param parameterName string
---@param value boolean
function Animator2D:setBool(parameterName, value)
end

---
---@param parameterName string
---@return boolean
function Animator2D:getBool(parameterName)
end

---setTrigger
---@param parameterName string
function Animator2D:setTrigger(parameterName)
end

---createEventAtTimePoint
---@param clipName string
---@param timePoint number
---@return AnimationEvent
function Animator2D:createEventAtTimePoint(clipName, timePoint)
end

---@param clipName string
---@param timePoint number
---@return AnimationEvent
function Animator2D:getEventAtTimePoint(clipName, timePoint)
end

---@param clipName string
---@param timePoint number
function Animator2D:removeEventAtTimePoint(clipName, timePoint)
end

---setLayerTimeScale
---@param layerIndex number
---@param timeScale number
function Animator2D:setLayerTimeScale(layerIndex, timeScale)
end

---@param layerIndex number
---@return number
function Animator2D:getLayerTimeScale(layerIndex)
end

return Animator2D