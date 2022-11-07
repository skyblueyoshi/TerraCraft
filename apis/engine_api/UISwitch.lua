---@class UISwitch:UINode
---@field onBackgroundSprite UISprite
---@field offBackgroundSprite UISprite
---@field onSliderSprite UISprite
---@field offSliderSprite UISprite
---@field selected boolean
---@field fadeTime number
---@field sliderSize Size
local UISwitch = {}

---new
---@overload fun(name:string):UISwitch
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UISwitch
function UISwitch.new(name, x, y, width, height)
end

---
---@param value UISwitch
---@return UISwitch
function UISwitch.clone(value)
end

---case
---@param uiNode UINode
---@return UISwitch
function UISwitch.cast(uiNode)
end

---setSelected
---@overload fun(selected:boolean)
---@param selected boolean
---@param withAnimation boolean
function UISwitch:setSelected(selected, withAnimation)
end

---
---@param listener table|function
---@return ListenerID
function UISwitch:addSelectChangedListener(listener)
end

---
---@param listenerID ListenerID
function UISwitch:removeSelectChangedListener(listenerID)
end

return UISwitch