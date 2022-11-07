---@class TC.Shooter9UI:TC.IShooterUI
local Shooter9UI = class("Shooter9UI", require("IShooterUI"))

---@param container TC.Shooter9ContainerClient
function Shooter9UI:__init(container)
    Shooter9UI.super.__init(self, require("ui.UIDesign").getShooter9UI(), container)
end

return Shooter9UI