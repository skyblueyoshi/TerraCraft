---@class GraphicsDevice
---@field vendorName string
---@field rendererName string
---@field drawCalls number
---@field primitiveCount number
local GraphicsDevice = {}

---
---@overload fun(a:Vector2,b:Vector2,color:Color)
---@param a Vector2
---@param b Vector2
---@param color Color
---@param depth number
function GraphicsDevice.drawLine2D(a, b, color, depth)
end

---
---@overload fun(point:Vector2,color:Color)
---@param point Vector2
---@param color Color
---@param depth number
function GraphicsDevice.drawPoint2D(point, color, depth)
end

---
---@overload fun(rect:RectFloat,color:Color)
---@param rect RectFloat
---@param color Color
---@param depth number
function GraphicsDevice.drawRect2D(rect, color, depth)
end

---
---@overload fun(rect:RectFloat,color:Color)
---@param rect RectFloat
---@param color Color
---@param depth number
function GraphicsDevice.drawRectHollow2D(rect, color, depth)
end

return GraphicsDevice