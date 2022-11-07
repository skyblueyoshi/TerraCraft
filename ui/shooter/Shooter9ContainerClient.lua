---@class TC.Shooter9ContainerClient:TC.IShooterContainerClient
local Shooter9ContainerClient = class("Shooter9ContainerClient", require("IShooterContainerClient"))

function Shooter9ContainerClient:__init(player, xi, yi)
    Shooter9ContainerClient.super.__init(self, 9, player, xi, yi)
end

return Shooter9ContainerClient