---@class IntegratedClient : IntegratedEnv
---@field main IntegratedClient
local IntegratedClient = {}

---
---@param listener table|function
---@return ListenerID
function IntegratedClient:addOnRenderListener(listener)
end

---
---@param listenerID ListenerID
function IntegratedClient:removeOnRenderListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function IntegratedClient:addOnWindowResizeListener(listener)
end

---
---@param listenerID ListenerID
function IntegratedClient:removeOnWindowResizeListener(listenerID)
end

return IntegratedClient