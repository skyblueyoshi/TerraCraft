---@class ByteStream
---@field empty boolean
---@field count number
---@field capacity number
---@field readableCount number
local ByteStream = {}

---
---@overload fun():ByteStream
---@param capacity number
---@return ByteStream
function ByteStream.new(capacity)
end

---clone
---@param value ByteStream
---@return ByteStream
function ByteStream.clone(value)
end

function ByteStream:clear()
end

function ByteStream:freeMemory()
end

---@param value number
function ByteStream:writeInt(value)
end

---@return number
function ByteStream:readInt()
end

---@param value number
function ByteStream:writeIntVarLen(value)
end

---@return number
function ByteStream:readIntVarLen()
end

---@param value number
function ByteStream:writeFloat(value)
end

---@return number
function ByteStream:readFloat()
end

---@param value number
function ByteStream:writeDouble(value)
end

---@return number
function ByteStream:readDouble()
end

---@param value boolean
function ByteStream:writeBoolean(value)
end

---@return boolean
function ByteStream:readBoolean()
end

---@param value string
function ByteStream:writeString(value)
end

---@return string
function ByteStream:readString()
end

return ByteStream