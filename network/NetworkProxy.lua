---@class TC.NetworkProxy
local NetworkProxy = class("NetworkProxy")

---RPCWriteVar
---@param buffer ByteStream
---@param v any
local function RPCWriteVar(buffer, v)
    local typeName = type(v)
    if typeName == "number" then
        buffer:writeIntVarLen(1)
        if math.floor(v) == v then
            buffer:writeBoolean(false)
            buffer:writeIntVarLen(v)
        else
            buffer:writeBoolean(true)
            buffer:writeDouble(v)
        end
    elseif typeName == "boolean" then
        buffer:writeIntVarLen(2)
        buffer:writeBoolean(v)
    elseif typeName == "string" then
        buffer:writeIntVarLen(3)
        buffer:writeString(v)
    elseif typeName == "table" then
        buffer:writeIntVarLen(4)
        local tableCount = 0
        for _ in pairs(v) do
            tableCount = tableCount + 1
        end
        buffer:writeIntVarLen(tableCount)
        for tk, kv in pairs(v) do
            local tkTypeName = type(tk)
            if tkTypeName == "string" then
                buffer:writeBoolean(false)
                buffer:writeString(tk)
            else
                buffer:writeBoolean(true)
                buffer:writeIntVarLen(tk)
            end
            RPCWriteVar(buffer, kv)
        end
    elseif typeName == "nil" then
        buffer:writeIntVarLen(5)
    else
        assert(false, "RPC failed")
    end
end

---RPCWrite
---@param buffer ByteStream
---@param rpcID int
function NetworkProxy._RPCWrite(buffer, rpcID, ...)
    local argCount = select('#', ...)
    buffer:writeIntVarLen(rpcID)
    buffer:writeIntVarLen(argCount)
    for _, v in ipairs { ... } do
        RPCWriteVar(buffer, v)
    end
end

---RPCSendServerBound
---@param mod Mod
---@param rpcID int
function NetworkProxy.RPCSendServerBound(mod, rpcID, ...)
    if NetMode.current ~= NetMode.Client then
        return
    end
    local serverBoundPacket = mod.serverBoundPacket
    local buffer = serverBoundPacket.writerBuffer
    NetworkProxy._RPCWrite(buffer, rpcID, ...)
    serverBoundPacket:Send()
end

---RPCSendClientBound
---@param mod Mod
---@param rpcID int
---@param player Player
function NetworkProxy.RPCSendClientBound(mod, rpcID, player, ...)
    if NetMode.current ~= NetMode.Server then
        return
    end
    local clientBoundPacket = mod.clientBoundPacket
    local buffer = clientBoundPacket.writerBuffer
    NetworkProxy._RPCWrite(buffer, rpcID, ...)
    clientBoundPacket:Send(player)
end

return NetworkProxy