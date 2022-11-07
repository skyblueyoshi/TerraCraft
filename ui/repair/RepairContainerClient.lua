---@class TC.RepairContainerClient:Container
local RepairContainerClient = class("RepairContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

function RepairContainerClient:__init(player, xi, yi)
    RepairContainerClient.super.__init(self)

    self.TOTAL_SLOT = 50 + 3
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)

    self.dataChangedCallback = nil
    self.needExpLevel = 0
end

function RepairContainerClient:OnReceiveChange(id, value)
    if id == 0 then
        self.needExpLevel = value
    end
end

return RepairContainerClient