---@class TC.Craft3xContainerClient:Container
local Craft3xContainerClient = class("Craft3xContainerClient", Container)
local ContainerHelper = require("ui.ContainerHelper")

---@param player Player
function Craft3xContainerClient:__init(player)
    Craft3xContainerClient.super.__init(self)
    self.TOTAL_SLOT = 60 -- 50 + 9 + 1
    self.tempSlots = Inventory.new(self.TOTAL_SLOT)
    ContainerHelper.ContainerClientInitSlots(self, self.tempSlots)

end

function Craft3xContainerClient:OnEvent(eventId, eventString)

end

function Craft3xContainerClient:CanInteractWith(player)
    return true
end

return Craft3xContainerClient