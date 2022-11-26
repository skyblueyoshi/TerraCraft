---@API

---@class Size:SerializableType 描述一个尺寸。
---@field width number 宽度。
---@field height number 高度。
local Size = {}

---创建一个尺寸对象。
---@overload fun():Size
---@param width number 宽度。
---@param height number 宽度。
---@return Size 新的尺寸对象。
function Size.new(width, height)
end

---克隆一个尺寸对象。
---@param value Size 原尺寸对象。
---@return Size 新的尺寸对象。
function Size.clone(value)
end

return Size