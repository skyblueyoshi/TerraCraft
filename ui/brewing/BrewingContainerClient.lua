---@class TC.BrewingContainerClient:Container
local BrewingContainerClient = class("BrewingContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

function BrewingContainerClient:__init(player, xi, yi)
    BrewingContainerClient.super.__init(self)
    self.progress = 0
    self.remainTimes = 0
    self.bubbleProgressRate = 0.0
    self.isBrewing = false
    self.TOTAL_SLOT = 54
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)
end

function BrewingContainerClient:OnUpdate()
    if not self.isBrewing then
        self.bubbleProgressRate = 0
    else
        self.bubbleProgressRate = self.bubbleProgressRate + Time.deltaTime
        if self.bubbleProgressRate >= 1.0 then
            self.bubbleProgressRate = 0.0
        end
    end
end

function BrewingContainerClient:OnReceiveChange(id, value)
    if id == 0 then
        self.progress = value
    elseif id == 1 then
        self.remainTimes = value
    elseif id == 2 then
        self.isBrewing = value
    end
end

return BrewingContainerClient