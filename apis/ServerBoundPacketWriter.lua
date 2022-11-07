---@class ServerBoundPacket
---@field writerBuffer ByteStream
---@field readerBuffer ByteStream
local ServerBoundPacket = {}

function ServerBoundPacket:Send()
end

---@return ByteStream
function ServerBoundPacket:GetWriterBuffer()
end

---@return ByteStream
function ServerBoundPacket:GetReaderBuffer()
end

return ServerBoundPacket