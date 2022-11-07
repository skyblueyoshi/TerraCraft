---@class Portal.ClientBoundResponse
local ClientBoundResponse = class("ClientBoundResponse")

local s_instance
---@return Portal.ClientBoundResponse
function ClientBoundResponse.getInstance()
    if s_instance == nil then
        s_instance = ClientBoundResponse.new()
    end
    return s_instance
end

function ClientBoundResponse:__init()
    self.modResponseCallbacks = {}
end

---addResponseCallback
---@param mod Mod
---@param rpcID int
---@param func function
---@param caller any
function ClientBoundResponse:addResponseCallback(mod, rpcID, func, caller)
    local found = false
    if self.modResponseCallbacks[mod.modId] == nil then
        self.modResponseCallbacks[mod.modId] = {}
    end

    if self.modResponseCallbacks[mod.modId][rpcID] == nil then
        self.modResponseCallbacks[mod.modId][rpcID] = {}
    end

    for _, cb in ipairs(self.modResponseCallbacks[mod.modId][rpcID]) do
        if cb[1] == func and cb[2] == caller then
            found = true
            break
        end
    end
    if found then
        return
    end
    table.insert(self.modResponseCallbacks[mod.modId][rpcID], { func, caller })
end

function ClientBoundResponse:removeResponse(caller)
    for _, responseCallbacks in pairs(self.modResponseCallbacks) do
        for _, cbs in pairs(responseCallbacks) do
            for i = #cbs, 1, -1 do
                if cbs[i][2] == caller then
                    table.remove(cbs, i)
                end
            end
        end
    end
end

function ClientBoundResponse:doResponse(mod, rpcID, ...)
    local responseCallbacks = self.modResponseCallbacks[mod.modId]
    if responseCallbacks == nil then
        return
    end
    local cbs = responseCallbacks[rpcID]
    if cbs == nil then
        return
    end
    for _, cb in ipairs(cbs) do
        cb[1](cb[2], ...)
    end
end

return ClientBoundResponse