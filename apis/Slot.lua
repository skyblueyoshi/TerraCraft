---@class Slot 描述一个物品格子，物品格子可能为空格子，也可能包含一个ItemStack。
---@field hasStack boolean 当前格子是否包含物品堆栈。
---@field tag int 格子附加值。
local Slot = {}

---判断格子是否有效。
---@return boolean 格子是否有效。
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
