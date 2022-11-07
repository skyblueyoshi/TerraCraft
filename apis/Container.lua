---@class Container
local Container = {}

---AddSlotToContainer
---@overload function(inventory:Inventory,slotIndex:int):int
---@param inventory Inventory
---@param slotIndex int
---@param ownedByGui boolean
---@return int
function Container:AddSlotToContainer(inventory, slotIndex, ownedByGui)
end

---GetSlot
---@param index int
---@return Slot
function Container:GetSlot(index)
end

---@return int
function Container:GetSlotCount()
end

---CanInteractWith
---@param player Player
---@return boolean
function Container:CanInteractWith(player)
end

function Container:OnUpdate()
end

function Container:OnClose()
end

function Container:DetectAndSendChangeInteger(id, value)
end

function Container:DetectAndSendChangeDouble(id, value)
end

function Container:DetectAndSendChangeString(id, value)
end

function Container:DetectAndSendChangeBoolean(id, value)
end

function Container:OnDetectChange()
end

function Container:OnReceiveChange(id, value)
end

---OnEvent
---@param eventId int
---@param eventString string
function Container:OnEvent(eventId, eventString)
end

---EnsureSlotEmpty
---@param container Container
---@param slotIndex int
function Container:CommandEnsureSlotEmpty(container, slotIndex)
end

---EnsureSlotHasItem
---@param container Container
---@param slotIndex int
---@param itemStack ItemStack
function Container:CommandEnsureSlotHasItem(container, slotIndex, itemStack)
end

---SwapSlot
---@param containerA Container
---@param slotIndexA int
---@param containerB Container
---@param slotIndexB int
function Container:CommandSwapSlot(containerA, slotIndexA, containerB, slotIndexB)
end

---SlotMoveTo
---@param containerFrom Container
---@param slotIndexFrom int
---@param containerTo Container
---@param slotIndexTo int
---@param moveStackSize int
function Container:CommandSlotMoveTo(containerFrom, slotIndexFrom, containerTo, slotIndexTo, moveStackSize)
end

---@return int
function Container:GetID()
end

return Container