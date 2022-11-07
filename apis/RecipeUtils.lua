---@class RecipeUtils
local RecipeUtils = {}

---GetRecipe
---@param recipeID int
---@return Recipe
function RecipeUtils.GetRecipe(recipeID)
end

---GetConfig
---@param recipeConfigID int
---@return RecipeConfig
function RecipeUtils.GetConfig(recipeConfigID)
end

---SearchRecipe
---@overload fun(configID:int,inventory:Inventory):int
---@param configID int
---@param inventory Inventory
---@param offset int
---@param length int
---@return int
function RecipeUtils.SearchRecipe(configID, inventory, offset, length)
end

---HasRecipe
---@param configID int
---@param inputItemStack ItemStack
---@param inputIndex int
---@return int
function RecipeUtils.HasRecipe(configID, inputItemStack, inputIndex)
end

---SearchRecipeHasInputItem
---@param configID int
---@param inputItemStack ItemStack
---@return int[]
function RecipeUtils.SearchRecipeHasInputItem(configID, inputItemStack)
end

---SearchRecipeHasOutputItem
---@param configID int
---@param outputItemStack ItemStack
---@param outputIndex int
---@return int[]
function RecipeUtils.SearchRecipeHasOutputItem(configID, outputItemStack, outputIndex)
end

return RecipeUtils