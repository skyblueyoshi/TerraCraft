---@class TC.Shooter9ContainerServer:TC.IShooterContainerServer
local Shooter9ContainerServer = class("Shooter9ContainerServer", require("IShooterContainerServer"))

---__init
---@param player Player
---@param xi int
---@param yi int
function Shooter9ContainerServer:__init(player, xi, yi)
    Shooter9ContainerServer.super.__init(self, 9, "Shooter9Entity", player, xi, yi)
end

return Shooter9ContainerServer