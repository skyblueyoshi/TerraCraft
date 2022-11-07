---@class Slot
---@field hasStack boolean
---@field tag int
local Slot = {}

---@return boolean
function Slot:Valid()
end

---@return ItemStack
function Slot:GetStack()
end

---PushStack
---@param stack ItemStack
function Slot:PushStack(stack)
end

---DecrStackSize
---@param value int
---@return ItemStack
function Slot:DecrStackSize(value)
end

function Slot:ClearStack()
end

---SwapStack
---@param slot Slot
function Slot:SwapStack(slot)
end

---CanPush
---@param itemStack ItemStack
---@return boolean
function Slot:CanPush(itemStack)
end

---
---@param itemStack ItemStack
---@return boolean
function Slot:CanPick(itemStack)
end

---OnPush
---@param itemStack ItemStack
function Slot:OnPush(itemStack)
end

---OnPick
---@param ItemStack ItemStack
function Slot:OnPick(ItemStack)
end

---
---@param listener table|function
---@return ListenerID
function Slot:AddCanPushListener(listener)
end

---
---@param listenerID ListenerID
function Slot:RemoveCanPushListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function Slot:AddCanPickListener(listener)
end

---
---@param listenerID ListenerID
function Slot:RemoveCanPickListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function Slot:AddOnPushListener(listener)
end

---
---@param listenerID ListenerID
function Slot:RemoveOnPushListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function Slot:AddOnPickListener(listener)
end

---
---@param listenerID ListenerID
function Slot:RemoveOnPickListener(listenerID)
end

function Slot:SyncAll()
end

return Slot