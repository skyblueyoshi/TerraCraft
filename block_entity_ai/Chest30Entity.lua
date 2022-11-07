---@class TC.Chest30Entity:TC.IChestEntity
local Chest30Entity = class("Chest30Entity", require("IChestEntity"))

function Chest30Entity:Init()
    Chest30Entity.super.Init(self, 30)
end

function Chest30Entity:OnClicked(parameterClick)
    self:InnerOnClicked(parameterClick, require("ui.GuiID").Chest30)
end

return Chest30Entity