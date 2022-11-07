---@class IntegratedEnv
---@field fps number
---@field gameSpeed number
---@field isMaxFPS boolean
---@field registry Registry
local IntegratedEnv = {}

---
---@param listener table|function
---@return ListenerID
function IntegratedEnv:addOnStartListener(listener)
end

---
---@param listenerID ListenerID
function IntegratedEnv:removeOnStartListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function IntegratedEnv:addOnUpdateListener(listener)
end

---
---@param listenerID ListenerID
function IntegratedEnv:removeOnUpdateListener(listenerID)
end

---
---@overload fun():ScheduleID
---@param intervalTicks number
---@return ScheduleID
function IntegratedEnv:createSchedule(intervalTicks)
end

---getSchedule
---@param scheduleID ScheduleID
---@return Schedule
function IntegratedEnv:getSchedule(scheduleID)
end

---
---@param scheduleID ScheduleID
function IntegratedEnv:removeSchedule(scheduleID)
end

return IntegratedEnv