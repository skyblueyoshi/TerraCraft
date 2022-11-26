---@API

---@class RecipeUtils 配方组件。
local RecipeUtils = {}

---通过配方的ID获取配方。
---@param recipeID int 配方ID （请通过搜索配方的方法 RecipeUtils.SearchRecipe() 动态获取）。
---@return Recipe 配方。
function RecipeUtils.GetRecipe(recipeID)
end

---获取某一合成实体的配方配置。
---@param recipeConfigID int 配方配置ID （请通过Reg.RecipeConfigID()动态获取）。
---@return RecipeConfig 配方配置。
function RecipeUtils.GetConfig(recipeConfigID)
end

---搜索配方。
---[Example]
-----获取酿造台的某一配方，使用酿造台中的两个合成的格子作为输入物品
---local recipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Brew"), self.inventory, 0, 2)
---@overload fun(configID:int,inventory:Inventory):int
---@param configID int 配方配置ID （请通过Reg.RecipeConfigID()动态获取）。
---@param inventory Inventory 物品格子的集合（一般为合成中使用的物品的格子的集合）。
---@param offset int 偏移值（从物品格子的哪里开始）。
---@param length int 长度（调用物品格子的数目）。
---@return int 配方ID
function RecipeUtils.SearchRecipe(configID, inventory, offset, length)
end

---检查某一物品是否有对应的配方
---@param configID int 配方配置ID （请通过Reg.RecipeConfigID()动态获取）。
---@param inputItemStack ItemStack 合成输入的堆叠物品。
---@param inputIndex int 合成输入的Index。
---@return int 配方ID。
function RecipeUtils.HasRecipe(configID, inputItemStack, inputIndex)
end

---检查某一配方配置里所有的配方中是否有对应的输入物品
---@param configID int 配方配置ID （请通过Reg.RecipeConfigID()动态获取）。
---@param inputItemStack ItemStack 搜索对应的堆叠物品。
---@return int[] 搜索到的配方ID的数组。
function RecipeUtils.SearchRecipeHasInputItem(configID, inputItemStack)
end

---检查某一配方配置里所有的配方中是否有对应的输出物品
---@param configID int 配方配置ID （请通过Reg.RecipeConfigID()动态获取）。
---@param outputItemStack ItemStack 搜索对应的堆叠物品。
---@param outputIndex int 合成输出的Index。
---@return int[] 搜索到的配方ID的数组。
function RecipeUtils.SearchRecipeHasOutputItem(configID, outputItemStack, outputIndex)
end

return RecipeUtils