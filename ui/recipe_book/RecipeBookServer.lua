---@class TC.RecipeBookServer
local RecipeBookServer = class("RecipeBookServer")

---@param player Player
---@param inputInventory Inventory
---@param inputInventorySlotStartIndex int
---@param inputInventorySlotSize int
function RecipeBookServer:__init(recipeConfigID, player, inputInventory, inputInventorySlotStartIndex, inputInventorySlotSize)
    self._recipeConfigID = recipeConfigID
    self._playerIndex = player.entityIndex
    self._inputInventory = inputInventory
    self._inputInventorySlotStartIndex = inputInventorySlotStartIndex
    self._inputInventorySlotSize = inputInventorySlotSize
end

function RecipeBookServer:FlushValidRecipe(recipeID)
    if recipeID == nil then
        return
    end
    local player = PlayerUtils.Get(self._playerIndex)
    if player == nil then
        return
    end
    print("Valid:", recipeID)
    if recipeID <= 0 or recipeID > Reg.MaxRecipeID() then
        return
    end
    -- all input slots are empty, move directly
    if self:_IsInputSlotsAllEmpty() then
        self:_InitSendRecipeInputItems(player, recipeID)
    else
        -- has input slots
        local lastRecipeID = RecipeUtils.SearchRecipe(self._recipeConfigID,
                self._inputInventory, self._inputInventorySlotStartIndex, self._inputInventorySlotSize)
        if lastRecipeID ~= recipeID then
            self:_SendBackAllInputItems(player)
            self:_InitSendRecipeInputItems(player, recipeID)
        else
            self:_SendSameInputItems(player)
        end
    end

end

function RecipeBookServer:_SendSameInputItems(player)
    local layouts = self:_GetBackpackLayouts(player)
    if not self:_CanPeekSameInputs(layouts) then
        return
    end
    for i = 1, self._inputInventorySlotSize do
        self:_TryPeekAndAdd(i, player)
    end
end

function RecipeBookServer:_CanPeekSameInputs(layouts)
    local cache = {}
    for i = self._inputInventorySlotStartIndex, self._inputInventorySlotStartIndex + self._inputInventorySlotSize - 1 do
        local slot = self._inputInventory:GetSlot(i)
        if slot.hasStack then
            local stack = slot:GetStack()
            local item = stack:GetItem()
            local size = stack.stackSize
            if size >= item.maxStackSize then
                return false
            end
            local id = item.id
            if cache[id] == nil then
                cache[id] = 1
            else
                cache[id] = cache[id] + 1
            end
        end
    end
    for id, size in pairs(cache) do
        if layouts[id] == nil then
            return false
        end
        local sizeOwned = layouts[id][1]
        if sizeOwned < size then
            return false
        end
    end
    return true
end

---@param player Player
---@param recipeID int
function RecipeBookServer:_InitSendRecipeInputItems(player, recipeID)
    local recipe = RecipeUtils.GetRecipe(recipeID)
    ---@param ie RecipeInputSlot
    for i, ie in each(recipe.inputs) do
        if i <= self._inputInventorySlotSize then
            if ie.type == RecipeInputSlotType.Item then
                self:_TryPeekAndPushStack(i, player,{ ie.id }, ie.stackSize)
            end
        end
    end
    ---@param ie RecipeInputSlot
    for i, ie in each(recipe.inputs) do
        if i <= self._inputInventorySlotSize then
            if ie.type == RecipeInputSlotType.OreDictionary then
                local ids = ItemUtils.GetOreDictionaryItemIDs(ie.id)
                local peekItemIDs = {}
                for _, id in each(ids) do
                    table.insert(peekItemIDs, id)
                end
                self:_TryPeekAndPushStack(i, player, peekItemIDs, ie.stackSize)
            end
        end
    end
end

---_SendBackAllInputItems
---@param player Player
function RecipeBookServer:_SendBackAllInputItems(player)
    local inventory = player.backpackInventory

    for i = self._inputInventorySlotStartIndex, self._inputInventorySlotStartIndex + self._inputInventorySlotSize - 1 do
        local slot = self._inputInventory:GetSlot(i)
        if slot.hasStack then
            local stack = slot:GetStack()
            slot:ClearStack()
            local remain = inventory:AddItemStack(stack)
            if remain:Valid() then
                player:DropItem(remain)
            end
        end
    end
end

function RecipeBookServer:_TryPeekAndPushStack(i, player, peekItemIDs, stackSize)
    local layouts = self:_GetBackpackLayouts(player)
    --print(layouts)
    local stack = self:_PeekStackFromBackpackLayouts(layouts, peekItemIDs, stackSize)
    if stack ~= nil then
        local slot = self._inputInventory:GetSlot(self._inputInventorySlotStartIndex + i - 1)
        slot:PushStack(stack)
    end
end

function RecipeBookServer:_TryPeekAndAdd(i, player)
    local layouts = self:_GetBackpackLayouts(player)
    local slot = self._inputInventory:GetSlot(self._inputInventorySlotStartIndex + i - 1)
    if slot.hasStack then
        local originalStack = slot:GetStack()
        local stack = self:_PeekStackFromBackpackLayouts(layouts, { originalStack:GetItem().id }, 1)
        if stack ~= nil then
            originalStack:SetStackSize(originalStack.stackSize + 1)
        end
    end
end

-- key: item id, value: { total size, list of {slot, count}}
---@param player Player
function RecipeBookServer:_GetBackpackLayouts(player)
    local res = {}
    local inventory = player.backpackInventory
    for i = 0, 49 do
        local slot = inventory:GetSlot(i)
        if slot.hasStack then
            local stack = slot:GetStack()
            local itemID = stack:GetItem().id
            local info = { slot, stack.stackSize }
            if res[itemID] == nil then
                res[itemID] = { stack.stackSize, { info } }
            else
                local data = res[itemID]
                data[1] = data[1] + stack.stackSize
                table.insert(data[2], info)
            end
        end
    end
    return res
end

function RecipeBookServer:_PeekStackFromBackpackLayouts(layouts, peekItemIDs, peekCount)
    assert(#peekItemIDs > 0 and peekCount > 0)
    for i, itemID in ipairs(peekItemIDs) do
        local data = layouts[itemID]
        if data ~= nil then
            if data[1] >= peekCount then
                data[1] = data[1] - peekCount
                local slots = data[2]
                local remainPeekCount = peekCount
                local resStack
                for j = #slots, 1, -1 do
                    local info = slots[j]
                    local slot = info[1] ---@type Slot
                    local slotSize = info[2]
                    if resStack == nil then
                        resStack = slot:GetStack():Clone(peekCount)
                    end
                    if slotSize > remainPeekCount then
                        slot:DecrStackSize(remainPeekCount)
                        remainPeekCount = 0
                    else
                        slot:ClearStack()
                        remainPeekCount = remainPeekCount - slotSize
                    end
                    if remainPeekCount == 0 then
                        return resStack
                    end
                end
            end
        end
    end
    return nil
end

function RecipeBookServer:_IsInputSlotsAllEmpty()
    for i = self._inputInventorySlotStartIndex, self._inputInventorySlotStartIndex + self._inputInventorySlotSize - 1 do
        local slot = self._inputInventory:GetSlot(i)
        if slot.hasStack then
            return false
        end
    end
    return true
end

return RecipeBookServer