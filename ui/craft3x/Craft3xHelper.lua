local Craft3xHelper = class("Craft3xHelper")
local ContainerHelper = require("ui.ContainerHelper")

---InitSlot
---@param containerServer Container
---@param craftSlots Inventory
---@param slotIndexInCraft int
function Craft3xHelper.InitSlot(containerServer, craftSlots, slotIndexInCraft)
    local slot = craftSlots:GetSlot(slotIndexInCraft)

    if slotIndexInCraft <= 8 then
        slot:AddOnPickListener({ Craft3xHelper.FlushDataFromInputs, containerServer, craftSlots })
        slot:AddOnPushListener({ Craft3xHelper.FlushDataFromInputs, containerServer, craftSlots })
    else
        --slot:AddOnPickListener({ Craft3xHelper.FlushDataFromOutput, containerServer, craftSlots })
    end

    containerServer:AddSlotToContainer(craftSlots, slotIndexInCraft, true)
end

---@param containerServer Container
---@param craftSlots Inventory
function Craft3xHelper.FlushDataFromInputs(containerServer, craftSlots)
    local recipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Craft3x"), craftSlots, 0, 9)

    if containerServer._lastCraftRecipeID == nil or containerServer._lastCraftRecipeID ~= recipeID then
        containerServer._lastCraftRecipeID = recipeID
        local outputSlot = craftSlots:GetSlot(9)
        outputSlot:ClearStack()
        if recipeID > 0 then
            local recipe = RecipeUtils.GetRecipe(recipeID)
            local resultStack = recipe.outputs[1]:GetStack()
            outputSlot:PushStack(resultStack:Clone())
        end
    end
end

---@param playerIndex int
---@param containerServer Container
---@param craftSlots Inventory
---@param isToMouse boolean
function Craft3xHelper.TryPickOutput(playerIndex, containerServer, craftSlots, isToMouse)
    if PlayerUtils.IsAlive(playerIndex) then
        local player = PlayerUtils.Get(playerIndex)
        local inventory = player.backpackInventory
        local outputSlot = craftSlots:GetSlot(9)
        if outputSlot.hasStack then
            local ok = false
            if isToMouse then
                local mouseSlot = player.mouseInventory:GetSlot(0)
                if not mouseSlot.hasStack then
                    mouseSlot:PushStack(outputSlot:GetStack())
                    outputSlot:ClearStack()
                    ok = true
                end
            end
            if not ok then
                local outStack = inventory:AddItemStack(outputSlot:GetStack())
                if outStack:Valid() then
                    player:DropItem(outStack)
                end
                outputSlot:ClearStack()
            end
        end
        Craft3xHelper.FlushDataFromOutput(containerServer, craftSlots)
    end
end

---@param containerServer Container
---@param craftSlots Inventory
function Craft3xHelper.FlushDataFromOutput(containerServer, craftSlots)
    if containerServer._lastCraftRecipeID == nil or containerServer._lastCraftRecipeID == 0 then
        return
    end

    -- We consider that every input element only has one item!
    -- So just decrease every input slot by one directly.
    local recipe = RecipeUtils.GetRecipe(containerServer._lastCraftRecipeID)
    for i = 0, 8 do
        local inputSlot = craftSlots:GetSlot(i)
        if inputSlot.hasStack then
            inputSlot:DecrStackSize(1)
        end
    end
    containerServer._lastCraftRecipeID = nil
    Craft3xHelper.FlushDataFromInputs(containerServer, craftSlots)

    -- return back
    local returnItemSlot = recipe.outputs[2]
    if returnItemSlot.hasStack then
        local stack = returnItemSlot:GetStack():Clone()
        if containerServer.playerIndex ~= nil then
            local player = PlayerUtils.Get(containerServer.playerIndex)
            if player then
                local remain = player.backpackInventory:AddItemStack(stack)
                if remain:Valid() then
                    player:DropItem(remain)
                end
            end
        end
    end
end

function Craft3xHelper.Close(craftSlots, playerIndex, xi, yi)
    ContainerHelper.CloseSendBackItems(playerIndex,
            xi, yi, craftSlots,
            { 0, 1, 2, 3, 4, 5, 6, 7, 8 })

    -- directly remove the result item
    craftSlots:GetSlot(9):ClearStack()
end

return Craft3xHelper