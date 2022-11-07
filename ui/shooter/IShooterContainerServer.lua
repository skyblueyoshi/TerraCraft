---@class TC.IShooterContainerServer:Container
local IShooterContainerServer = class("IChestContainerServer", Container)
local ContainerHelper = require("ui.ContainerHelper")

---__init
---@param slotCount int
---@param blockEntityName string
---@param player Player
---@param xi int
---@param yi int
function IShooterContainerServer:__init(slotCount, blockEntityName, player, xi, yi)
    IShooterContainerServer.super.__init(self)
    self.playerIndex = player.entityIndex
    self.backpackInventory = player.backpackInventory
    self.xi = xi
    self.yi = yi
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    self.slotCount = slotCount
    self.blockEntityName = blockEntityName

    ---@type Inventory
    self.shooterInventory = self:GetMyEntity().inventory
    for i = 1, slotCount do
        self:AddSlotToContainer(self.shooterInventory, i - 1)
    end
end

function IShooterContainerServer:GetMyEntity()
    local blockEntity = MapUtils.GetBlockEntity(Reg.BlockEntityID(self.blockEntityName), self.xi, self.yi)
    if blockEntity == nil then
        return nil
    end
    ---@type TC.IShooterEntity
    local modEntity = blockEntity:GetModBlockEntity()
    return modEntity
end

function IShooterContainerServer:CanInteractWith(player)
    if self:GetMyEntity() == nil then
        return false
    end
    return ContainerHelper.InInteractDistance(player, self.xi, self.yi)
end

return IShooterContainerServer