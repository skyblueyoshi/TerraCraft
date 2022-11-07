---@class ItemStack
---@field stackSize int
---@field durable double
---@field enchantmentCount int
local ItemStack = {}

---new
---@overload fun(item:Item):ItemStack
---@param item Item
---@param stackSize int
---@return ItemStack
function ItemStack.new(item, stackSize)
end

---@return boolean
function ItemStack:Valid()
end

---AddEnchantment
---@param enchantmentId int
---@param enchantmentLevel int
---@return boolean
function ItemStack:AddEnchantment(enchantmentId, enchantmentLevel)
end

---Clone
---@overload fun():ItemStack
---@param stackSize int
---@return ItemStack
function ItemStack:Clone(stackSize)
end

---SetStackSize
---@param value int
function ItemStack:SetStackSize(value)
end

---AddDurable
---@param value double
function ItemStack:AddDurable(value)
end

---@param value double
function ItemStack:SetDurable(value)
end

---LoseDurable
---@param value double
---@return boolean
function ItemStack:LoseDurable(value)
end

---GetEnchantmentLevel
---@param enchantmentId int
---@return int
function ItemStack:GetEnchantmentLevel(enchantmentId)
end

---HasEnchantment
---@overload fun():boolean
---@param enchantmentId int
---@return boolean
function ItemStack:HasEnchantment(enchantmentId)
end

---GetEnchantmentByIndex
---@param index int
---@return Enchantment
function ItemStack:GetEnchantmentByIndex(index)
end

---RemoveEnchantmentByIndex
---@param index int
function ItemStack:RemoveEnchantmentByIndex(index)
end

---RemoveEnchantment
---@param enchantmentID int
function ItemStack:RemoveEnchantment(enchantmentID)
end

function ItemStack:ClearEnchantments()
end

---IsItemEqual
---@param itemStack ItemStack
---@return boolean
function ItemStack:IsItemEqual(itemStack)
end

---IsItemStackEqual
---@overload fun(itemStack:ItemStack):boolean
---@param itemStack ItemStack
---@param ignoreStackSize boolean
---@return boolean
function ItemStack:IsItemStackEqual(itemStack, ignoreStackSize)
end

---GetMergeCount
---@param itemStack ItemStack
---@return int
function ItemStack:GetMergeCount(itemStack)
end

---SplitStack
---@param count int
---@return ItemStack
function ItemStack:SplitStack(count)
end

---@return Item
function ItemStack:GetItem()
end

---Render
---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ItemStack:Render(position, color, spriteExData)
end

---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ItemStack:RenderNum(position, color, spriteExData)
end

---@param num int
---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ItemStack:RenderCustomNum(num, position, color, spriteExData)
end

---RunHeldEvent
---@param player Player
function ItemStack:RunOnHeldEvent(player)
end

---@param player Player
function ItemStack:RunOnHeldRenderEvent(player)
end

---RunOnHeldByNpcEvent
---@param npc Npc
function ItemStack:RunOnHeldByNpcEvent(npc)
end

---RunCanUse
---@param player Player
---@return boolean
function ItemStack:CanUse(player)
end

---RunUseEvent
---@param player Player
function ItemStack:RunOnUsedEvent(player)
end

---RunOnUsedByNpcEvent
---@param npc Npc
function ItemStack:RunOnUsedByNpcEvent(npc)
end

---@param player Player
---@return boolean
function ItemStack:RunOnDurableEmptyEvent(player)
end

---@return table
function ItemStack:Serialization()
end

---Deserialization
---@param serializedTable table
---@return ItemStack
function ItemStack.Deserialization(serializedTable)
end

---@return ModItem
function ItemStack:GetModItem()
end

return ItemStack