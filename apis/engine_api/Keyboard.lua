---@class Keyboard
local Keyboard = {}

---isKeyPressed
---@param key Keys_Value
---@return boolean
function Keyboard:isKeyPressed(key)
end

---isKeyReleased
---@param key Keys_Value
---@return boolean
function Keyboard:isKeyReleased(key)
end

---getHotKeys
---@overload fun(key1:Keys_Value):HotKeyCombination
---@overload fun(key1:Keys_Value,key2:Keys_Value):HotKeyCombination
---@overload fun(key1:Keys_Value,key2:Keys_Value,key3:Keys_Value):HotKeyCombination
---@param key1 Keys_Value
---@param key2 Keys_Value
---@param key3 Keys_Value
---@return HotKeyCombination
function Keyboard:getHotKeys(key1, key2, key3)
end

---
---@param key Keys_Value
---@return KeyTrigger
function Keyboard:getPressDownTrigger(key)
end

---
---@param key Keys_Value
---@return KeyTrigger
function Keyboard:getPressUpTrigger(key)
end

return Keyboard