---@class TC.Shooter9Entity:TC.IShooterEntity
local Shooter9Entity = class("Shooter9Entity", require("IShooterEntity"))

function Shooter9Entity:Init()
    Shooter9Entity.super.Init(self, 9)
end

function Shooter9Entity:OnClicked(parameterClick)
    self:InnerOnClicked(parameterClick, require("ui.GuiID").Shooter9)
end

return Shooter9Entity