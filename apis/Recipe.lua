
---@class RecipeInputSlotType_Value

---@class RecipeInputSlotType
---@field Empty RecipeInputSlotType_Value
---@field Item RecipeInputSlotType_Value
---@field OreDictionary RecipeInputSlotType_Value
local RecipeInputSlotType = {}

---@class RecipeInputSlot
---@field type RecipeInputSlotType_Value
---@field id int
---@field stackSize int
---@field itemStack ItemStack
---@field isImportant boolean
local RecipeInputSlot = {}

---@class Recipe
---@field configID int
---@field inputs RecipeInputSlot[]
---@field outputs Slot[]
---@field exData table
local Recipe = {}

---GetGroupSearchAction
---@param groupIndex int
---@return int
function Recipe:GetGroupSearchAction(groupIndex)
end

---IsValidByMask
---@param mask string
---@return boolean
function Recipe:IsValidByMask(mask)
end

return Recipe