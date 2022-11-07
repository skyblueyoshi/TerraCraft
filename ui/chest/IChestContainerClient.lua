---@class TC.IChestContainerClient:Container
local IChestContainerClient = class("IChestContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

function IChestContainerClient:__init(slotCount, player, xi, yi)
    IChestContainerClient.super.__init(self)
    self.TOTAL_SLOT = slotCount + 50
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)
end

return IChestContainerClient