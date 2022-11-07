---@class Mouse
---@field position Vector2
---@field normalizedPosition Vector2
---@field isLeftButtonPressed boolean
---@field isRightButtonPressed boolean
---@field isMiddleButtonPressed boolean
---@field isLeftButtonInstantDown boolean
---@field isRightButtonInstantDown boolean
---@field isMiddleButtonInstantDown boolean
---@field isLeftButtonInstantUp boolean
---@field isRightButtonInstantUp boolean
---@field isMiddleButtonInstantUp boolean
---@field isLeftButtonDoubleClick boolean
---@field isRightButtonDoubleClick boolean
---@field isMiddleButtonDoubleClick boolean
local Mouse = {}

---
---@param listener table|function
---@return ListenerID
function Mouse:addScrollListener(listener)
end

---
---@param listenerID ListenerID
function Mouse:removeScrollListener(listenerID)
end

---setCursorVisible
---@param visible boolean
function Mouse:setCursorVisible(visible)
end

return Mouse