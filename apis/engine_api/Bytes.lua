---@class Bytes
---@field empty boolean
---@field count number
---@field capacity number
local Bytes = {}

---
---@overload fun():Bytes
---@param capacity number
---@return Bytes
function Bytes.new(capacity)
end

---clone
---@param value Bytes
---@return Bytes
function Bytes.clone(value)
end

---
---@param value number
---@return number
function Bytes:add(value)
end

---
---@param index number
---@param value number
function Bytes:insert(index, value)
end

function Bytes:clear()
end

function Bytes:freeMemory()
end

---
---@overload fun(count:number)
---@param count number
---@param fill number
function Bytes:setCount(count, fill)
end

---
---@param capacity number
function Bytes:setCapacity(capacity)
end

---
---@param bytes Bytes
function Bytes:swap(bytes)
end

---
---@overload fun(bytes:Bytes)
---@param bytes Bytes
---@param offset number
---@param count number
function Bytes:addBytes(bytes, offset, count)
end

---
---@param startOverwriteOffset number
---@param sourceBytes Bytes
---@param sourceOffset number
---@param sourceCount number
function Bytes:overwrite(startOverwriteOffset, sourceBytes, sourceOffset, sourceCount)
end

return Bytes