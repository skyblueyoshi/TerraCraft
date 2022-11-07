---@class ClientBoundPacket
---@field writerBuffer ByteStream
---@field readerBuffer ByteStream
local ClientBoundPacket = {}

---Send
---@param player Player
function ClientBoundPacket:Send(player)
end

---@return ByteStream
function ClientBoundPacket:GetWriterBuffer()
end

---@return ByteStream
function ClientBoundPacket:GetReaderBuffer()
end

return ClientBoundPacket