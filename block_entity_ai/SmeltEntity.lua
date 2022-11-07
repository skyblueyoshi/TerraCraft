---@class TC.SmeltEntity:ModBlockEntity
local SmeltEntity = class("SmeltEntity", ModBlockEntity)

function SmeltEntity:Init()
    self.inventory = Inventory.new(4)
    self.inputSlot = self.inventory:GetSlot(0)
    self.fuelSlot = self.inventory:GetSlot(1)
    self.outputSlot = self.inventory:GetSlot(2)
    self.fuelBackSlot = self.inventory:GetSlot(3)
    self.burnTime = 0       -- current burning remain time
    self.burnTotalTime = 0
    self.cookedTime = 0
    self.totalCookTime = 0
    self.currentRecipeID = 0

    self.blockEntity.dataWatcher:AddInventory(self.inventory)
end

function SmeltEntity:OnPlaced()

end

function SmeltEntity:OnKilled(parameterDestroy)
    local cx, cy = MapUtils.GetFrontCenterXY(self.blockEntity.xi, self.blockEntity.yi)

    ---@param slot Slot
    local function _TryDropItemAndClearSlot(slot)
        if slot.hasStack then
            ItemUtils.CreateDrop(slot:GetStack(), cx, cy,
                    Utils.RandSym(3), Utils.RandDoubleArea(-4, 1))
            slot:ClearStack()
        end
    end
    _TryDropItemAndClearSlot(self.inputSlot)
    _TryDropItemAndClearSlot(self.outputSlot)
    _TryDropItemAndClearSlot(self.fuelSlot)
    _TryDropItemAndClearSlot(self.fuelBackSlot)
end

function SmeltEntity:Update()
    if self.currentRecipeID > 0 then
        self.cookedTime = self.cookedTime + 1
    end
    if self.burnTime > 0 then
        self.burnTime = self.burnTime - 1
    end
    local lastRecipeID = self.currentRecipeID
    local nextCookLoop = false
    if self.currentRecipeID > 0 and self.cookedTime >= self.totalCookTime then
        -- current cooking is finished

        local recipe = RecipeUtils.GetRecipe(self.currentRecipeID)
        -- add the output
        local recipeInputStackSize = recipe.inputs[1].stackSize
        local recipeOutputStack = recipe.outputs[1]:GetStack()
        local outputItem = recipeOutputStack:GetItem()
        if not self.outputSlot.hasStack then
            self.outputSlot:PushStack(recipeOutputStack:Clone())
        else
            local outputStack = self.outputSlot:GetStack()
            assert(outputStack:IsItemStackEqual(recipeOutputStack, true), "Current output item is not same as the recipe item!")
            outputStack:SetStackSize(outputStack.stackSize + recipeOutputStack.stackSize)
        end

        -- remove the input
        assert(self.inputSlot.hasStack, "Current input item is not exist!")
        self.inputSlot:DecrStackSize(recipeInputStackSize)

        -- check the next loop
        if self.inputSlot.hasStack and self.inputSlot:GetStack().stackSize >= recipeInputStackSize then
            -- input item is exist and enough for the next loop
            if self.outputSlot:GetStack().stackSize + recipeOutputStack.stackSize <= outputItem.maxStackSize then
                -- output can add for the next loop
                nextCookLoop = true
            end
        end
        self.cookedTime = 0
        self.totalCookTime = 0
        self.currentRecipeID = 0
    end

    if self.burnTime <= 0 then
        -- current fuel is burning over
        self.burnTotalTime = 0
        if self.currentRecipeID > 0 or nextCookLoop then
            local hasFuel = false
            if self.fuelSlot.hasStack then
                local fuelItem = self.fuelSlot:GetStack():GetItem()
                if fuelItem.fuelTime > 0 then
                    local canNextFuelLoop = true
                    local canReturnItem = false
                    if fuelItem.fuelReturnItemID > 0 then
                        if self.fuelBackSlot.hasStack then
                            local fuelStack = self.fuelBackSlot:GetStack()
                            if fuelStack:GetItem().id == fuelItem.fuelReturnItemID then
                                if fuelStack.stackSize < fuelStack:GetItem().maxStackSize then
                                    canReturnItem = true
                                end
                            end
                        else
                            canReturnItem = true
                        end
                        canNextFuelLoop = canReturnItem
                    end
                    if canNextFuelLoop then
                        hasFuel = true
                        self.burnTotalTime = fuelItem.fuelTime
                        self.burnTime = self.burnTotalTime
                        self.fuelSlot:DecrStackSize(1)
                        if canReturnItem then
                            if self.fuelBackSlot.hasStack then
                                local fuelStack = self.fuelBackSlot:GetStack()
                                fuelStack:SetStackSize(fuelStack.stackSize + 1)
                            else
                                self.fuelBackSlot:PushStack(
                                        ItemStack.new(ItemRegistry.GetItemByID(fuelItem.fuelReturnItemID)))
                            end
                        end
                        if nextCookLoop then
                            self.currentRecipeID = lastRecipeID
                            if self.currentRecipeID > 0 then
                                self.totalCookTime = RecipeUtils.GetRecipe(self.currentRecipeID).exData.time
                            end
                        end
                    end
                end
            end
            if not hasFuel then
                self.currentRecipeID = 0
                self.cookedTime = 0
                self.totalCookTime = 0
            end
        end
    else
        if nextCookLoop then
            self.currentRecipeID = lastRecipeID
            if self.currentRecipeID > 0 then
                self.totalCookTime = RecipeUtils.GetRecipe(self.currentRecipeID).exData.time
            end
        end
    end

    if self.burnTime == 0 then
        -- normal animation
        self.blockEntity:SetAnimation(0)
    else
        -- burning animation
        self.blockEntity:SetAnimation(1)
    end
end

function SmeltEntity:FlushRecipeData()
    if self.inputSlot.hasStack then
        local lastRecipeID = self.currentRecipeID
        local recipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Smelt"), self.inventory, 0, 1)
        if recipeID > 0 and recipeID ~= lastRecipeID then
            -- recipe data changed
            if self.outputSlot.hasStack then
                local recipe = RecipeUtils.GetRecipe(recipeID)
                local recipeOutputStack = recipe.outputs[1]:GetStack()
                local outputStack = self.outputSlot:GetStack()
                if not outputStack:IsItemStackEqual(recipeOutputStack, true) then
                    -- recipe is invalid because the recipe output is not same
                    recipeID = 0
                else
                    local outputItem = outputStack:GetItem()
                    if outputStack.stackSize + recipeOutputStack.stackSize > outputItem.maxStackSize then
                        -- recipe is invalid because cannot add full recipe output items into output slot
                        recipeID = 0
                    end
                end
            end
        end
        if recipeID > 0 then
            if self.burnTime == 0 then
                if not self.fuelSlot.hasStack or self.fuelSlot:GetStack():GetItem().fuelTime == 0 then
                    -- fuel is invalid, so recipe is also invalid
                    recipeID = 0
                end
            end
        end
        if lastRecipeID ~= recipeID then
            -- recipe is changed, reset the cooking data
            self.currentRecipeID = recipeID
            self.cookedTime = 0
            self.totalCookTime = 0
            if self.currentRecipeID > 0 then
                self.totalCookTime = RecipeUtils.GetRecipe(self.currentRecipeID).exData.time
            end
        end
    else
        -- no input item exist, clear cooking data
        self.currentRecipeID = 0
        self.cookedTime = 0
        self.totalCookTime = 0
    end
end

function SmeltEntity:OnClicked(parameterClick)
    local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        local GuiID = require("ui.GuiID")
        player:OpenGui(Mod.current, GuiID.Smelt, self.blockEntity.xi, self.blockEntity.yi)
    end
end

function SmeltEntity:Save()
    local res = {
        burnTime = self.burnTime,
        burnTotalTime = self.burnTotalTime,
        cookedTime = self.cookedTime,
    }
    if self.inputSlot.hasStack then
        res.inputSlot = self.inputSlot:GetStack():Serialization()
    end
    if self.fuelSlot.hasStack then
        res.fuelSlot = self.fuelSlot:GetStack():Serialization()
    end
    if self.outputSlot.hasStack then
        res.outputSlot = self.outputSlot:GetStack():Serialization()
    end
    if self.fuelBackSlot.hasStack then
        res.fuelBackSlot = self.fuelBackSlot:GetStack():Serialization()
    end

    return res
end

function SmeltEntity:Load(tagTable)
    if tagTable.burnTime ~= nil then
        self.burnTime = tagTable.burnTime
    end
    if tagTable.burnTotalTime ~= nil then
        self.burnTotalTime = tagTable.burnTotalTime
    end
    if tagTable.cookedTime ~= nil then
        self.cookedTime = tagTable.cookedTime
    end
    if tagTable.inputSlot ~= nil then
        self.inputSlot:PushStack(ItemStack.Deserialization(tagTable.inputSlot))
    end
    if tagTable.fuelSlot ~= nil then
        self.fuelSlot:PushStack(ItemStack.Deserialization(tagTable.fuelSlot))
    end
    if tagTable.outputSlot ~= nil then
        self.outputSlot:PushStack(ItemStack.Deserialization(tagTable.outputSlot))
    end
    if tagTable.fuelBackSlot ~= nil then
        self.fuelBackSlot:PushStack(ItemStack.Deserialization(tagTable.fuelBackSlot))
    end
    self.currentRecipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Smelt"), self.inventory, 0, 1)
end

return SmeltEntity