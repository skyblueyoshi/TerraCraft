---@class AnimationEvent
local AnimationEvent = {}

---
---@param listener table|function
---@return ListenerID
function AnimationEvent:addListener(listener)
end

---
---@param listenerID ListenerID
function AnimationEvent:removeListener(listenerID)
end

return AnimationEvent