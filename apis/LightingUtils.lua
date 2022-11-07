---@class LightingUtils
local LightingUtils = {}

---Add
---@overload fun(xi:int,yi:int,alpha:int)
---@overload fun(xi:int,yi:int,alpha:int,red:int)
---@overload fun(xi:int,yi:int,alpha:int,red:int,green:int)
---@overload fun(xi:int,yi:int,alpha:int,red:int,green:int,blue:int)
---@param xi int
---@param yi int
---@param alpha int
---@param red int
---@param green int
---@param blue int
function LightingUtils.Add(xi, yi, alpha, red, green, blue)
end

---AddDelay
---@overload fun(xi:int,yi:int,delayTime:int,alpha:int)
---@overload fun(xi:int,yi:int,delayTime:int,alpha:int,red:int)
---@overload fun(xi:int,yi:int,delayTime:int,alpha:int,red:int,green:int)
---@overload fun(xi:int,yi:int,delayTime:int,alpha:int,red:int,green:int,blue:int)
---@param xi int
---@param yi int
---@param delayTime int
---@param alpha int
---@param red int
---@param green int
---@param blue int
function LightingUtils.AddDelay(xi, yi, delayTime, alpha, red, green, blue)
end

return LightingUtils