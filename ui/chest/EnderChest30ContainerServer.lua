---@class TC.EnderChest30ContainerServer:TC.IChestContainerServer
local EnderChest30ContainerServer = class("EnderChest30ContainerServer", require("IChestContainerServer"))

---__init
---@param player Player
---@param xi int
---@param yi int
function EnderChest30ContainerServer:__init(player, xi, yi)
    EnderChest30ContainerServer.super.__init(self, 30, "", player, xi, yi, player.enderInventory)
end

return EnderChest30ContainerServer