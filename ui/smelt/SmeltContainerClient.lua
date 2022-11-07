---@class TC.SmeltContainerClient:Container
local SmeltContainerClient = class("SmeltContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

function SmeltContainerClient:__init(player, xi, yi)
    SmeltContainerClient.super.__init(self)
    self.cookProgress = 0
    self.burnProgress = 0
    self.TOTAL_SLOT = 54
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)
end

function SmeltContainerClient:OnEvent(eventId, eventString)

end

function SmeltContainerClient:OnUpdate()

end

function SmeltContainerClient:OnClose()

end

function SmeltContainerClient:OnReceiveChange(id, value)
    if id == 0 then
        self.cookProgress = value
    elseif id == 1 then
        self.burnProgress = value
    end
end

function SmeltContainerClient:CanInteractWith(player)
    return true
end

return SmeltContainerClient