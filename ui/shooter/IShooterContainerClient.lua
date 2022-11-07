---@class TC.IShooterContainerClient:Container
local IShooterContainerClient = class("IShooterContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

function IShooterContainerClient:__init(slotCount, player, xi, yi)
    IShooterContainerClient.super.__init(self)
    self.TOTAL_SLOT = slotCount + 50
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)
end

return IShooterContainerClient