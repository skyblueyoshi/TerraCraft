---@class TC.BrewingEntity:ModBlockEntity
local BrewingEntity = class("BrewingEntity", ModBlockEntity)

function BrewingEntity:Init()
    self.inventory = Inventory.new(4)
    self.potionSlot = self.inventory:GetSlot(0)
    self.sourceSlot = self.inventory:GetSlot(1)
    self.outputSlot = self.inventory:GetSlot(2)
    self.fuelSlot = self.inventory:GetSlot(3)

    self.processedTime = 0
    self.totalProcessTime = 0
    self.currentRecipeID = 0
    self.remainProcessTimes = 0

    self.blockEntity.dataWatcher:AddInventory(self.inventory)
end

function BrewingEntity:OnKilled(parameterDestroy)
    local cx, cy = MapUtils.GetFrontCenterXY(self.blockEntity.xi, self.blockEntity.yi)
    ---@param slot Slot
    local function _TryDropItemAndClearSlot(slot)
        if slot.hasStack then
            ItemUtils.CreateDrop(slot:GetStack(), cx, cy,
                    Utils.RandSym(3), Utils.RandDoubleArea(-4, 1))
            slot:ClearStack()
        end
    end
    _TryDropItemAndClearSlot(self.sourceSlot)
    _TryDropItemAndClearSlot(self.potionSlot)
    _TryDropItemAndClearSlot(self.outputSlot)
    _TryDropItemAndClearSlot(self.fuelSlot)
end

function BrewingEntity:Update()
    if self.currentRecipeID > 0 then
        self.processedTime = self.processedTime + 1
    end
    local nextLoop = false
    local lastRecipeID = self.currentRecipeID
    if self.currentRecipeID > 0 and self.processedTime >= self.totalProcessTime then
        -- brewing finish
        local recipe = RecipeUtils.GetRecipe(self.currentRecipeID)
        local recipeSourceStackSize = recipe.inputs[1].stackSize
        local recipePotionStackSize = recipe.inputs[2].stackSize
        local recipeOutputStack = recipe.outputs[1]:GetStack()
        local outputItem = recipeOutputStack:GetItem()
        if not self.outputSlot.hasStack then
            self.outputSlot:PushStack(recipeOutputStack:Clone())
        else
            local outputStack = self.outputSlot:GetStack()
            assert(outputStack:IsItemStackEqual(recipeOutputStack, true), "Current output item is not same as the recipe item!")
            outputStack:SetStackSize(outputStack.stackSize + recipeOutputStack.stackSize)
        end
        assert(self.sourceSlot.hasStack, "Current source item is not exist!")
        assert(self.potionSlot.hasStack, "Current potion item is not exist!")
        self.sourceSlot:DecrStackSize(recipeSourceStackSize)
        self.potionSlot:DecrStackSize(recipePotionStackSize)
        self.remainProcessTimes = self.remainProcessTimes - 1

        local inputOk = self.sourceSlot.hasStack and self.sourceSlot:GetStack().stackSize >= recipeSourceStackSize
        inputOk = inputOk and self.potionSlot.hasStack and self.potionSlot:GetStack().stackSize >= recipePotionStackSize
        if inputOk then
            if self.outputSlot:GetStack().stackSize + recipeOutputStack.stackSize <= outputItem.maxStackSize then
                -- output can add for the next loop
                nextLoop = true
            end
        end
        self.currentRecipeID = 0
        self.processedTime = 0
        self.totalProcessTime = 0
    end

    if self.remainProcessTimes <= 0 then
        if self.fuelSlot.hasStack then
            if self.fuelSlot:GetStack():GetItem().id == Reg.ItemID("tc:blaze_powder") then
                self.fuelSlot:DecrStackSize(1)
                self.remainProcessTimes = 20
                if nextLoop then
                    self.currentRecipeID = lastRecipeID
                    if self.currentRecipeID > 0 then
                        self.totalProcessTime = RecipeUtils.GetRecipe(self.currentRecipeID).exData.time
                    end
                end
            end
        end
    elseif nextLoop then
        self.currentRecipeID = lastRecipeID
        if self.currentRecipeID > 0 then
            self.totalProcessTime = RecipeUtils.GetRecipe(self.currentRecipeID).exData.time
        end
    end
    if self.currentRecipeID > 0 then
        self.blockEntity:SetAnimation(1)
    else
        self.blockEntity:SetAnimation(0)
    end
end

function BrewingEntity:FlushRecipeData()
    if self.sourceSlot.hasStack and self.potionSlot.hasStack then
        local recipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Brew"), self.inventory, 0, 2)

        if recipeID == 0 then
            self.currentRecipeID = 0
            self.processedTime = 0
            self.totalProcessTime = 0
        elseif recipeID > 0 and recipeID ~= self.currentRecipeID then
            if self.outputSlot.hasStack then
                local recipeOutputStack = RecipeUtils.GetRecipe(recipeID).outputs[1]:GetStack()
                local outputStack = self.outputSlot:GetStack()
                if outputStack:IsItemStackEqual(recipeOutputStack, true) then
                    if outputStack.stackSize + recipeOutputStack.stackSize >
                            recipeOutputStack:GetItem().maxStackSize then
                        recipeID = 0
                    end
                else
                    recipeID = 0
                end
            end
            self.currentRecipeID = recipeID
            self.processedTime = 0
            if recipeID == 0 then
                self.totalProcessTime = 0
            else
                local recipe = RecipeUtils.GetRecipe(recipeID)
                self.totalProcessTime = recipe.exData.time
            end
        end
    else
        self.currentRecipeID = 0
        self.processedTime = 0
        self.totalProcessTime = 0
    end
    if self.remainProcessTimes <= 0 and self.currentRecipeID > 0 and self.fuelSlot.hasStack and
            self.fuelSlot:GetStack():GetItem().id == Reg.ItemID("tc:blaze_powder") then
        self.fuelSlot:DecrStackSize(1)
        self.remainProcessTimes = 20
    end
    if self.remainProcessTimes <= 0 and self.currentRecipeID > 0 then
        self.currentRecipeID = 0
        self.processedTime = 0
        self.totalProcessTime = 0
    end
end

function BrewingEntity:OnClicked(parameterClick)
    local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        local GuiID = require("ui.GuiID")
        player:OpenGui(Mod.current, GuiID.Brewing, self.blockEntity.xi, self.blockEntity.yi)
    end
end

function BrewingEntity:Save()
    local res = {
        processedTime = self.processedTime,
        remainProcessTimes = self.remainProcessTimes,
    }
    if self.sourceSlot.hasStack then
        res.sourceSlot = self.sourceSlot:GetStack():Serialization()
    end
    if self.potionSlot.hasStack then
        res.potionSlot = self.potionSlot:GetStack():Serialization()
    end
    if self.outputSlot.hasStack then
        res.outputSlot = self.outputSlot:GetStack():Serialization()
    end
    if self.fuelSlot.hasStack then
        res.fuelSlot = self.fuelSlot:GetStack():Serialization()
    end

    return res
end

function BrewingEntity:Load(tagTable)
    self.processedTime = tagTable.processedTime
    self.remainProcessTimes = tagTable.remainProcessTimes
    if tagTable.sourceSlot ~= nil then
        self.sourceSlot:PushStack(ItemStack.Deserialization(tagTable.sourceSlot))
    end
    if tagTable.potionSlot ~= nil then
        self.potionSlot:PushStack(ItemStack.Deserialization(tagTable.potionSlot))
    end
    if tagTable.outputSlot ~= nil then
        self.outputSlot:PushStack(ItemStack.Deserialization(tagTable.outputSlot))
    end
    if tagTable.fuelSlot ~= nil then
        self.fuelSlot:PushStack(ItemStack.Deserialization(tagTable.fuelSlot))
    end
    self.currentRecipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Brew"), self.inventory, 0, 2)
end

return BrewingEntity