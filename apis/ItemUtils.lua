---@class ItemUtils
---@field maxRootGroupCount int
local ItemUtils = {}

---CreateDrop
---@overload fun(itemStack:ItemStack, centerX:double, centerY:double)
---@overload fun(itemStack:ItemStack, centerX:double, centerY:double, speedX:double, speedY:double)
---@param itemStack ItemStack
---@param centerX double
---@param centerY double
---@param speedX double
---@param speedY double
---@param coldTime int
function ItemUtils.CreateDrop(itemStack, centerX, centerY, speedX, speedY, coldTime)
end

---GetOreDictionaryItemIDs
---@param oreDictionaryID int
---@return int[]
function ItemUtils.GetOreDictionaryItemIDs(oreDictionaryID)
end

---GetGroupItemIDs
---@param itemGroupID int
---@return int[]
function ItemUtils.GetGroupItemIDs(itemGroupID)
end

---GetGroupIDsFromRootID
---@param rootGroupID int
---@return int[]
function ItemUtils.GetGroupIDsFromRootID(rootGroupID)
end

---GetRootGroupIconItemID
---@param rootGroupID int
---@return int
function ItemUtils.GetRootGroupIconItemID(rootGroupID)
end

return ItemUtils