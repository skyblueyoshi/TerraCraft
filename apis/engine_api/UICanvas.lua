---@class UICanvas:UINode
local UICanvas = {}

---new
---@overload fun(name:string):UICanvas
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UICanvas
function UICanvas.new(name, x, y, width, height)
end

---
---@param value UICanvas
---@return UICanvas
function UICanvas.clone(value)
end

---case
---@param uiNode UINode
---@return UICanvas
function UICanvas.cast(uiNode)
end

function UICanvas:update()
end

function UICanvas:render()
end

---screenPointToCanvasPoint
---@param screenPosition Vector2
---@return Vector2
function UICanvas:screenPointToCanvasPoint(screenPosition)
end

---canvasPointToScreenPoint
---@param canvasPosition Vector2
---@return Vector2
function UICanvas:canvasPointToScreenPoint(canvasPosition)
end

return UICanvas