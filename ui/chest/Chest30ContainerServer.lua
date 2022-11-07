---@class TC.Chest30ContainerServer:TC.IChestContainerServer
local Chest30ContainerServer = class("Chest30ContainerServer", require("IChestContainerServer"))

---__init
---@param player Player
---@param xi int
---@param yi int
function Chest30ContainerServer:__init(player, xi, yi)
    Chest30ContainerServer.super.__init(self, 30, "Chest30Entity", player, xi, yi)
end

return Chest30ContainerServer