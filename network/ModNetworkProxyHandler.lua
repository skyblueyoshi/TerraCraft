---@class TC.ModNetworkProxyHandler
local ModNetworkProxyHandler = class("ModNetworkProxyHandler")

---__init
---@param mod Mod
function ModNetworkProxyHandler:__init(mod)
    self.mod = mod
    self.isServer = NetMode.current == NetMode.Server
    if self.isServer then
        self.mod:RegisterServerBoundReaderCallback({
            ModNetworkProxyHandler.HandleProxyServerBound, self
        })
    else
        self.mod:RegisterClientBoundReaderCallback({
            ModNetworkProxyHandler.HandleProxyClientBound, self
        })
    end
    self.rpcHandlerFuncSB = {}
    self.rpcHandlerFuncCB = {}
end

function ModNetworkProxyHandler:RegisterRPCHandlerServerBoundMappings(mappings)
    for k, v in ipairs(mappings) do
        self:RegisterRPCHandlerServerBound(k, v)
    end
end

function ModNetworkProxyHandler:RegisterRPCHandlerClientBoundMappings(mappings)
    for k, v in ipairs(mappings) do
        self:RegisterRPCHandlerClientBound(k, v)
    end
end

function ModNetworkProxyHandler:RegisterRPCHandlerServerBound(rpcID, rpcFunc)
    self.rpcHandlerFuncSB[rpcID] = rpcFunc
end

function ModNetworkProxyHandler:RegisterRPCHandlerClientBound(rpcID, rpcFunc)
    self.rpcHandlerFuncCB[rpcID] = rpcFunc
end

---RPCWriteVar
---@param buffer ByteStream
local function RPCReadVar(buffer)
    local flag = buffer:readIntVarLen()
    local v
    if flag == 1 then
        local isDouble = buffer:readBoolean()
        if isDouble then
            v = buffer:readDouble()
        else
            v = buffer:readIntVarLen()
        end
    elseif flag == 2 then
        v = buffer:readBoolean()
    elseif flag == 3 then
        v = buffer:readString()
    elseif flag == 4 then
        v = {}
        local tableCount = buffer:readIntVarLen()
        for i = 1, tableCount do
            local tk, tv
            local isKeyNum = buffer:readBoolean()
            if isKeyNum then
                tk = buffer:readIntVarLen()
            else
                tk = buffer:readString()
            end
            tv = RPCReadVar(buffer)
            v[tk] = tv
        end
    elseif flag == 5 then
        v = nil
    else
        assert(false, "RPC failed")
    end
    return v
end

---RPCRead
---@param buffer ByteStream
function ModNetworkProxyHandler:_RPCRead(buffer, player, sb)
    local values = {}

    local rpcID = buffer:readIntVarLen()
    local argCount = buffer:readIntVarLen()
    while argCount > 0 do
        local v = RPCReadVar(buffer)
        table.insert(values, v)
        argCount = argCount - 1
    end

    local rpcFunc
    if sb then
        rpcFunc = self.rpcHandlerFuncSB[rpcID]
        if rpcFunc ~= nil then
            rpcFunc(self, player, unpack(values))
        end
    else
        rpcFunc = self.rpcHandlerFuncCB[rpcID]
        if rpcFunc ~= nil then
            rpcFunc(self, unpack(values))
        end
    end
end

function ModNetworkProxyHandler:HandleProxyServerBound(player)
    assert(self.isServer)
    local serverBoundPacket = self.mod.serverBoundPacket
    local buffer = serverBoundPacket.readerBuffer
    self:_RPCRead(buffer, player, true)
end

function ModNetworkProxyHandler:HandleProxyClientBound()
    assert(not self.isServer)
    local clientBoundPacket = self.mod.clientBoundPacket
    local buffer = clientBoundPacket.readerBuffer
    self:_RPCRead(buffer, nil, false)
end

return ModNetworkProxyHandler