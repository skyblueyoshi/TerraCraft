---@class TC.Chest30ContainerClient:TC.IChestContainerClient
local Chest30ContainerClient = class("Chest30ContainerClient", require("IChestContainerClient"))

function Chest30ContainerClient:__init(player, xi, yi)
    Chest30ContainerClient.super.__init(self, 30, player, xi, yi)
end

return Chest30ContainerClient