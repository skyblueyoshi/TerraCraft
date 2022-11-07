---@class Color:SerializableType
---@field red number
---@field green number
---@field blue number
---@field alpha number
---@field Red Color
---@field Black Color
---@field Gray Color
---@field Red Color
---@field Green Color
---@field Blue Color
---@field LightBlue Color
---@field Yellow Color
---@field FrenchGray Color
---@field White Color
local Color = {}

---new
---@overload fun():Color
---@overload fun(red:number,green:number,blue:number):Color
---@param red number
---@param green number
---@param blue number
---@param alpha number
---@return Color
function Color.new(red, green, blue, alpha)
end

---clone
---@param value Color
---@return Color
function Color.clone(value)
end

return Color