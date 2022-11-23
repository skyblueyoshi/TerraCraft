---@API

---@class Inventory 描述物品格子集合。
---@field slotCount int 物品格子的总数。
local Inventory = {}

---场景一个物品格子集合对象。
---@param slotCount int 物品格子的总数。
---@return Inventory 新的物品格子集合对象。
function Inventory.new(slotCount)
end

---判断当前物品格子集合对象是否有效。
---@return boolean
function Inventory:Valid()
end

---改变格子数量，若新增了格子，则格子将默认为空格子。
---@param count int 新的格子总数。
function Inventory:SetSlotCount(count)
end

---由格子索引获取格子对象。
---@param index int 格子索引。
---@return Slot 物品格子对象。
function Inventory:GetSlot(index)
end

---往当前集合加入一组堆叠物品。
---@param itemStack ItemStack 堆叠物品。
---@return ItemStack 当放入堆叠物品后导致集合满时，返回未能放入的堆叠物品。如果能完全放入，则返回无效ItemStack。
function Inventory:AddItemStack(itemStack)
end

---为当前集合的所有物品格子进行排序。
function Inventory:SortAll()
end

---为当前集合的指定格子范围进行排序。
---@param index int 格子范围起始索引。
---@param count int 待排序的格子总数。
function Inventory:Sort(index, count)
end

---将当前集合的指定格子范围内的物品快速转移到另一个物品格子集合的指定范围。
---@overload fun(start:int,slotCount:int,inventoryTo:Inventory,inventoryToStart:int,inventoryToSlotCount:int)
---@param start int 当前集合待转移的格子范围起始索引。
---@param slotCount int 当前集合待转移的格子总数。
---@param inventoryTo Inventory 将要转移到的格子集合对象。
---@param inventoryToStart int 将要转移到的格子集合对象的格子范围起始索引。
---@param inventoryToSlotCount int 将要转移到的格子集合对象的格子总数。
---@param pushSameItemOnly boolean
function Inventory:QuickPushAllTo(start, slotCount, inventoryTo, inventoryToStart, inventoryToSlotCount, pushSameItemOnly)
end

---序列化得到lua表。
---@return table lua表。
function Inventory:Serialization()
end

---由lua表反序列化得到当前物品格子集合对象。
---@param serializedTable table lua表。
function Inventory:Deserialization(serializedTable)
end

return Inventory