---@API

---@class ItemStack 描述一组堆叠物品。
---@field stackSize int Read-only 当前堆叠数量。
---@field durable double 当前物品耐久。
---@field enchantmentCount int 当前堆叠物品挂接的附魔数量。
local ItemStack = {}

---创建一个堆叠物品对象。
---
---[Example]
-----创建堆叠234个由钻石的堆叠物品对象。
---local itemStackDiamond = ItemStack.new(ItemRegistry.GetItemByID("diamond"), 234)
-----创建一个铁剑堆叠物品对象。
---local itemStackSword = ItemStack.new(ItemRegistry.GetItemByID("iron_sword"))
---
---@overload fun(item:Item):ItemStack
---@param item Item 物品。
---@param stackSize int 堆叠数量。
---@return ItemStack 新的堆叠物品对象。
function ItemStack.new(item, stackSize)
end

---判断当前堆叠物品数据是否有效。
function ItemStack:Valid()
end

---为当前堆叠物品新增一项附魔。
---@param enchantmentId int 附魔ID。
---@param enchantmentLevel int 附魔等级。
---@return boolean 新增附魔是否有变化，当且仅当之前已经存在附魔且新增附魔等级小于之前等级则无变化。
function ItemStack:AddEnchantment(enchantmentId, enchantmentLevel)
end

---克隆返回一个新的堆叠物品对象。
---@overload fun():ItemStack
---@param stackSize int 新的堆栈数量。
---@return ItemStack 新的堆叠物品对象。
function ItemStack:Clone(stackSize)
end

---设置堆栈数量。
function ItemStack:SetStackSize(value)
end

---增加耐久值。
function ItemStack:AddDurable(value)
end

---直接设置耐久值。
function ItemStack:SetDurable(value)
end

---减少耐久值。
---@return boolean 减少后耐久是否为0。
function ItemStack:LoseDurable(value)
end

---获取当前堆栈物品指定附魔的等级。
---@param enchantmentId int 附魔ID。
---@return int 附魔等级。
function ItemStack:GetEnchantmentLevel(enchantmentId)
end

---判断当前堆叠物品是否拥有了指定附魔。
---@overload fun():boolean
---@param enchantmentId int 附魔ID。
---@return boolean
function ItemStack:HasEnchantment(enchantmentId)
end

---由附魔索引得到附魔对象。
---@param index int 附魔索引。
---@return Enchantment 附魔对象。
function ItemStack:GetEnchantmentByIndex(index)
end

---由附魔索引删除附魔对象。
---@param index int 附魔索引。
function ItemStack:RemoveEnchantmentByIndex(index)
end

---由附魔ID删除一个附魔对象。
---@param enchantmentID int 附魔ID。
function ItemStack:RemoveEnchantment(enchantmentID)
end

---清空所有附魔。
function ItemStack:ClearEnchantments()
end

---判断当前堆叠物品的物品数据是否与另一个堆叠物品的物品数据相同。
---@param itemStack ItemStack 另一个堆叠物品。
---@return boolean
function ItemStack:IsItemEqual(itemStack)
end

---判断当前堆叠物品是否与另一个堆叠物品相同。
---@overload fun(itemStack:ItemStack):boolean
---@param itemStack ItemStack 另一个堆叠物品。
---@param ignoreStackSize boolean 是否忽略堆叠物品数量判断。
---@return boolean
function ItemStack:IsItemStackEqual(itemStack, ignoreStackSize)
end

---返回当前堆叠物品与另一个堆叠物品可合并的数量。
---@param itemStack ItemStack 另一个堆叠物品。
---@return int
function ItemStack:GetMergeCount(itemStack)
end

---拆分当前堆叠物品，返回新的拆出来的堆叠物品对象。
---@param count int 拆出来的堆叠数量。
---@return ItemStack 新的拆出来的堆叠物品对象。
function ItemStack:SplitStack(count)
end

---获得当前堆叠物品的物品数据。
---@return Item
function ItemStack:GetItem()
end

---绘制当前堆叠物品。
---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ItemStack:Render(position, color, spriteExData)
end

---绘制当前堆叠物品的堆叠数量。
---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ItemStack:RenderNum(position, color, spriteExData)
end

---自定义绘制当前堆叠物品的堆叠数量。
---@param num int
---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ItemStack:RenderCustomNum(num, position, color, spriteExData)
end

---执行堆叠物品挂接ModItem的`OnHeld`函数。
---@param player Player 玩家
function ItemStack:RunOnHeldEvent(player)
end

---执行堆叠物品挂接ModItem的`OnHeldRender`函数。
---@param player Player 玩家
function ItemStack:RunOnHeldRenderEvent(player)
end

---执行堆叠物品挂接ModItem的`OnHeld`函数。
---@param npc Npc
function ItemStack:RunOnHeldByNpcEvent(npc)
end

---返回当前堆叠物品是否能被玩家使用。
---@param player Player 玩家
---@return boolean
function ItemStack:CanUse(player)
end

---执行堆叠物品挂接ModItem的`OnUsed`函数。
---@param player Player 玩家
function ItemStack:RunOnUsedEvent(player)
end

---执行堆叠物品挂接ModItem的`OnUsedByNpc`函数。
---@param npc Npc
function ItemStack:RunOnUsedByNpcEvent(npc)
end

---执行堆叠物品挂接ModItem的`OnDurableEmpty`函数。
---@param player Player 玩家
---@return boolean
function ItemStack:RunOnDurableEmptyEvent(player)
end

---序列化得到lua表。
---@return table lua表。
function ItemStack:Serialization()
end

---由lua表反序列化创建一个堆叠物品对象。
---@param serializedTable table lua表。
---@return ItemStack 新的堆叠物品对象。
function ItemStack.Deserialization(serializedTable)
end

---返回当前堆叠物品挂接的ModItem对象。
---@return ModItem 挂接的ModItem对象，如果无挂接，返回nil。
function ItemStack:GetModItem()
end

return ItemStack