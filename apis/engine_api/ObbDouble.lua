---@class ObbDouble:SerializableType
---@field centerX number
---@field centerY number
---@field width number
---@field height number
---@field angle number
local ObbDouble = {}

---new
---@param centerX number
---@param centerY number
---@param width number
---@param height number
---@param angle number
---@return ObbDouble
function ObbDouble.new(centerX, centerY, width, height, angle)
end

---isOverlapping
---@param otherObb ObbDouble
function ObbDouble:isOverlapping(otherObb)
end

---isPointIn
---@param vector2 Vector2
---@return boolean
function ObbDouble:isPointIn(vector2)
end

---convertFromSourceRectSpace
---@param xInSource number
---@param yInSource number
---@return number,number
function ObbDouble:convertFromSourceRectSpace(xInSource, yInSource)
end

return ObbDouble