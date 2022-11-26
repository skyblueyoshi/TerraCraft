---@API

---@class Color:SerializableType 描述一个颜色。
---@field red number 红色通道分量。取值为[0, 255]。
---@field green number 绿色通道分量。取值为[0, 255]。
---@field blue number 蓝色通道分量。取值为[0, 255]。
---@field alpha number 透明度通道分量。取值为[0, 255]。
---@field Red Color 返回红色对象。
---@field Black Color 返回黑色对象。
---@field Gray Color 返回灰色对象。
---@field Green Color 返回绿色对象。
---@field Blue Color 返回蓝色对象。
---@field LightBlue Color 返回淡蓝色对象。
---@field Yellow Color 返回黄色对象。
---@field FrenchGray Color 返回淡灰色对象。
---@field White Color 返回白色对象。
local Color = {}

---创建一个颜色对象。
---@overload fun():Color
---@overload fun(red:number,green:number,blue:number):Color
---@param red number 红色通道分量。取值为[0, 255]。
---@param green number 绿色通道分量。取值为[0, 255]。
---@param blue number 蓝色通道分量。取值为[0, 255]。
---@param alpha number 透明度通道分量。取值为[0, 255]。
---@return Color 新的颜色对象。
function Color.new(red, green, blue, alpha)
end

---@param value Color
---@return Color
function Color.clone(value)
end

return Color