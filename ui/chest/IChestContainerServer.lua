---@class TC.IChestContainerServer:Container
local IChestContainerServer = class("IChestContainerServer", Container)
local ContainerHelper = require("ui.ContainerHelper")
local UIData = require("ChestUIData")

---__init
---@param slotCount int
---@param blockEntityName string
---@param player Player
---@param xi int
---@param yi int
---@param hookInventory Inventory
function IChestContainerServer:__init(slotCount, blockEntityName, player, xi, yi, hookInventory)
    IChestContainerServer.super.__init(self)
    self.playerIndex = player.entityIndex
    self.backpackInventory = player.backpackInventory
    self.xi = xi
    self.yi = yi
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    self.slotCount = slotCount
    self.hasBlockEntity = not (blockEntityName == nil or blockEntityName == "")
    self.blockEntityName = blockEntityName

    ---@type Inventory
    self.chestInventory = nil
    if self.hasBlockEntity then
        local chestEntity = self:GetMyEntity()
        self.chestInventory = chestEntity.inventory
    else
        self.chestInventory = hookInventory
    end
    for i = 1, slotCount do
        self:AddSlotToContainer(self.chestInventory, i - 1)
    end
    local frontID = MapUtils.GetFrontID(xi, yi)
    if frontID > 0 then
        local data = BlockUtils.GetData(frontID)
        if data:HasAnimation() then
            MapUtils.PlayAnimation(self.xi, self.yi,
                    0, 4, 4, true)
            MapUtils.SetAnimationIndex(self.xi, self.yi, 1)
        end
        if data.functionSoundId then
            SoundUtils.PlaySound(data.functionSoundId, xi, yi)
        end
        if data.functionSoundGroupId then
            SoundUtils.PlaySoundGroup(data.functionSoundGroupId, xi, yi)
        end
    end
end

function IChestContainerServer:OnClose()
    if not self.hasBlockEntity or (self.hasBlockEntity and self:IsMyEntityExist()) then
        local frontID = MapUtils.GetFrontID(self.xi, self.yi)
        if frontID > 0 then
            local data = BlockUtils.GetData(frontID)
            if data:HasAnimation() then
                MapUtils.PlayAnimation(self.xi, self.yi,
                        0, 4, 4, false)
                MapUtils.SetAnimationIndex(self.xi, self.yi, 0)
            end
            if data.functionSoundId2 then
                SoundUtils.PlaySound(data.functionSoundId2, self.xi, self.yi)
            end
            if data.functionSoundGroupId2 then
                SoundUtils.PlaySoundGroup(data.functionSoundGroupId2, self.xi, self.yi)
            end
        end
    end
end

function IChestContainerServer:IsMyEntityExist()
    local blockEntity = MapUtils.GetBlockEntity(Reg.BlockEntityID(self.blockEntityName), self.xi, self.yi)
    return blockEntity ~= nil
end

function IChestContainerServer:GetMyEntity()
    local blockEntity = MapUtils.GetBlockEntity(Reg.BlockEntityID(self.blockEntityName), self.xi, self.yi)
    if blockEntity == nil then
        return nil
    end
    ---@type TC.IChestEntity
    local modEntity = blockEntity:GetModBlockEntity()
    return modEntity
end

function IChestContainerServer:CanInteractWith(player)
    if (self.hasBlockEntity and not self:IsMyEntityExist()) then
        return false
    end
    return ContainerHelper.InInteractDistance(player, self.xi, self.yi)
end

function IChestContainerServer:OnEvent(eventId, eventString)
    if eventId == UIData.EventID.SortChest then
        self.chestInventory:SortAll()
    elseif eventId == UIData.EventID.QuickPick then
        self.chestInventory:QuickPushAllTo(
                0, self.chestInventory.slotCount,
                self.backpackInventory, 0, self.backpackInventory.slotCount
        )
    elseif eventId == UIData.EventID.QuickPush then
        self.backpackInventory:QuickPushAllTo(
                10, 40,
                self.chestInventory, 0, self.chestInventory.slotCount
        )
    elseif eventId == UIData.EventID.QuickStack then
        self.backpackInventory:QuickPushAllTo(
                0, self.backpackInventory.slotCount,
                self.chestInventory, 0, self.chestInventory.slotCount,
                true
        )
    end
end

return IChestContainerServer