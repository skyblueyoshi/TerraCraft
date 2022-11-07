---@class Size:SerializableType
---@field width number
---@field height number
local Size = {}

---new
---@overload fun():Size
---@param width number
---@param height number
---@return Size
function Size.new(width, height)
end

---clone
---@param value Size
---@return Size
function Size.clone(value)
end

return Size