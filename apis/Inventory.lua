---@class Inventory
---@field slotCount int
local Inventory = {}

---new
---@param slotCount int
---@return Inventory
function Inventory.new(slotCount)
end

---@return boolean
function Inventory:Valid()
end

---SetSlotCount
---@param count int
function Inventory:SetSlotCount(count)
end

---GetSlot
---@param index int
---@return Slot
function Inventory:GetSlot(index)
end

---AddItemStack
---@param itemStack ItemStack
---@return ItemStack
function Inventory:AddItemStack(itemStack)
end

function Inventory:SortAll()
end

---Sort
---@param index int
---@param count int
function Inventory:Sort(index, count)
end

---QuickPushAllTo
---@overload fun(start:int,slotCount:int,inventoryTo:Inventory,inventoryToStart:int,inventoryToSlotCount:int)
---@param start int
---@param slotCount int
---@param inventoryTo Inventory
---@param inventoryToStart int
---@param inventoryToSlotCount int
---@param pushSameItemOnly boolean
function Inventory:QuickPushAllTo(start, slotCount, inventoryTo, inventoryToStart, inventoryToSlotCount, pushSameItemOnly)
end

---@return table
function Inventory:Serialization()
end

---Deserialization
---@param serializedTable table
function Inventory:Deserialization(serializedTable)
end

return Inventory