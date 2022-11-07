---@class TC.BackpackContainerClient:Container
local BackpackContainerClient = class("BackpackContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

---@param player Player
function BackpackContainerClient:__init(player)
    BackpackContainerClient.super.__init(self)
    self.TOTAL_SLOT = 70
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)
end

function BackpackContainerClient:OnEvent(eventId, eventString)

end

function BackpackContainerClient:OnUpdate()

end

function BackpackContainerClient:OnClose()

end

function BackpackContainerClient:CanInteractWith(player)
    return true
end

return BackpackContainerClient