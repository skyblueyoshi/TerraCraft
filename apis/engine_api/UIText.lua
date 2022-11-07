---@class UIText:UINode
---@field horizontalAlignment TextAlignment_Value
---@field verticalAlignment TextAlignment_Value
---@field verticalOverflow TextHorizontalOverflow_Value
---@field horizontalOverflow TextVerticalOverflow_Value
---@field text string
---@field fontName string
---@field fontSize number
---@field color Color
---@field autoAdaptSize boolean
---@field displayTextSize Size
---@field preferredSize Size
---@field preferredWidth number
---@field preferredHeight number
---@field isRichText boolean
---@field outlineSize number
---@field outlineColor Color
local UIText = {}

---new
---@overload fun(name:string):UIText
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIText
function UIText.new(name, x, y, width, height)
end

---
---@param value UIText
---@return UIText
function UIText.clone(value)
end

---case
---@param uiNode UINode
---@return UIText
function UIText.cast(uiNode)
end

---
---@param listener table|function
---@return ListenerID
function UIText:addTextChangedListener(listener)
end

---
---@param listenerID ListenerID
function UIText:removeTextChangedListener(listenerID)
end

return UIText