---@class UISlider:UINode
---@field barSprite UISprite
---@field activeBarSprite UISprite
---@field sliderSprite UISprite
---@field sliderSize Size
---@field maxValue number
---@field minValue number
---@field value number
---@field valueStep number
---@field rate number
---@field sliderDirection SliderDirection_Value
local UISlider = {}

---new
---@overload fun(name:string):UISlider
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UISlider
function UISlider.new(name, x, y, width, height)
end

---
---@param value UISlider
---@return UISlider
function UISlider.clone(value)
end

---case
---@param uiNode UINode
---@return UISlider
function UISlider.cast(uiNode)
end

---
---@param listener table|function
---@return ListenerID
function UISlider:addValueChangedListener(listener)
end

---
---@param listenerID ListenerID
function UISlider:removeValueChangedListener(listenerID)
end

return UISlider