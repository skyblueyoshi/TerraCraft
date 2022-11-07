---@class GuiContainer
---@field container Container
local GuiContainer = {}

---__init
---@param container Container
function GuiContainer:__init(container)
end

function GuiContainer:OnUpdate()
end

function GuiContainer:OnClose()
end

---TriggerClientEvent
---@overload fun(eventId:int)
---@param eventId int
---@param eventString string
function GuiContainer:TriggerClientEvent(eventId, eventString)
end

---TriggerServerEvent
---@overload fun(eventId:int)
---@param eventId int
---@param eventString string
function GuiContainer:TriggerServerEvent(eventId, eventString)
end

return GuiContainer