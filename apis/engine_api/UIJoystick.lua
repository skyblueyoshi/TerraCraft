---@class UIJoystick:UINode
---@field frontSprite UISprite
---@field backSprite UISprite
---@field activeDistanceRate number
---@field controlRadius number
---@field controlledDistance number
---@field controlledDistanceRate number
---@field controlledAngle number
---@field controlledCenter Vector2
local UIJoystick = {}

---new
---@overload fun(name:string):UIJoystick
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIJoystick
function UIJoystick.new(name, x, y, width, height)
end

---
---@param value UIJoystick
---@return UIJoystick
function UIJoystick.clone(value)
end

---case
---@param uiNode UINode
---@return UIJoystick
function UIJoystick.cast(uiNode)
end

---setControl
---@overload fun(v:Vector2)
---@param x number
---@param y number
function UIJoystick:setControl(x, y)
end

---@return boolean,boolean,boolean,boolean
function UIJoystick:getControlledFourDirection()
end

return UIJoystick