---@class ImageInfo
---@field width number
---@field height number
---@field channelCount number
---@field byteData Bytes
local ImageInfo = {}

---
---@param width number
---@param height number
---@param channelCount number
---@return ImageInfo
function ImageInfo.new(width, height, channelCount)
end

---clone
---@param value ImageInfo
---@return ImageInfo
function ImageInfo.clone(value)
end

return ImageInfo