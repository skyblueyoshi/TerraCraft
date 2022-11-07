---@class TC.AngrySkeleton:TC.SwordHumanFighter
local AngrySkeleton = class("AngrySkeleton", require("SwordHumanFighter"))

function AngrySkeleton:Init()
	AngrySkeleton.super.Init(self)
    self:SetHeldItemByIDName("lead_sword")
end

function AngrySkeleton:Update()
    AngrySkeleton.super.Update(self)
end

return AngrySkeleton