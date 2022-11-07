local ContainerHelper = class("ContainerHelper")

---ContainerServerAddBackpack
---@param player Player
---@param container Container
function ContainerHelper.ContainerServerAddBackpack(player, container)
    for i = 1, 50 do
        -- 0-49 inventory
        container:AddSlotToContainer(player.backpackInventory, i - 1)
    end
end

---InInteractDistance
---@param player Player
---@param xi int
---@param yi int
function ContainerHelper.InInteractDistance(player, xi, yi)
    return player:GetDistance(xi * 16 + 8, yi * 16 + 8) < 200
end

---ContainerClientInitSlots
---@param container Container
---@param tempSlots Inventory
function ContainerHelper.ContainerClientInitSlots(container, tempSlots)
    local maxSlots = tempSlots.slotCount
    for i = 1, maxSlots do
        container:AddSlotToContainer(tempSlots, i - 1, true)
    end
end

---CloseSendBackItems
---@param playerIndex int
---@param xi int
---@param yi int
---@param tempSlots Inventory
---@param slotIndices int[]
function ContainerHelper.CloseSendBackItems(playerIndex, xi, yi, tempSlots, slotIndices)
    if PlayerUtils.IsAlive(playerIndex) then
        local player = PlayerUtils.Get(playerIndex)
        local inventory = player.backpackInventory

        for _, i in ipairs(slotIndices) do
            local slot = tempSlots:GetSlot(i)
            if slot.hasStack then
                -- the input item is exist, send back to player's inventory
                local outStack = inventory:AddItemStack(slot:GetStack())
                if outStack:Valid() then
                    player:DropItem(outStack)
                end
                slot:ClearStack()
            end
        end
    else
        -- the player is offline or unavailable, drop directly
        for _, i in ipairs(slotIndices) do
            local slot = tempSlots:GetSlot(i)
            if slot.hasStack then
                ItemUtils.CreateDrop(slot:GetStack(), xi * 16 + 8, yi * 16 + 8)
                slot:ClearStack()
            end
        end
    end
end

return ContainerHelper