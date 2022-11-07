---@class TC.IChestEntity:ModBlockEntity
local IChestEntity = class("IChestEntity", ModBlockEntity)

function IChestEntity:Init(slotCount)
    slotCount = slotCount or 1
    ---@type Inventory
    self.inventory = Inventory.new(slotCount)
    self.inventorySize = slotCount
    self.blockEntity.dataWatcher:AddInventory(self.inventory)
end

function IChestEntity:OnKilled(parameterDestroy)
    local cx, cy = MapUtils.GetFrontCenterXY(self.blockEntity.xi, self.blockEntity.yi)

    local cnt = self.inventory.slotCount
    for i = 1, cnt do
        local slot = self.inventory:GetSlot(i - 1)
        if slot.hasStack then
            ItemUtils.CreateDrop(slot:GetStack(), cx, cy,
                    Utils.RandSym(3), Utils.RandDoubleArea(-4, 1))
            slot:ClearStack()
        end
    end
end

function IChestEntity:InnerOnClicked(parameterClick, guiID)
    local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        player:OpenGui(Mod.current, guiID, self.blockEntity.xi, self.blockEntity.yi)
    end
end

function IChestEntity:Save()
    local res = { inventory = self.inventory:Serialization() }
    return res
end

function IChestEntity:Load(tagTable)
    self.inventory:Deserialization(tagTable.inventory)
end

return IChestEntity