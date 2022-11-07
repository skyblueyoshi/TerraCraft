---@class TC.BlackSkeleton:TC.SwordHumanFighter
local BlackSkeleton = class("BlackSkeleton", require("SwordHumanFighter"))

function BlackSkeleton:Init()
	BlackSkeleton.super.Init(self)
	self:SetHeldItemByIDName("golden_pickaxe")
end

function BlackSkeleton:Update()
	BlackSkeleton.super.Update(self)
	self:DoExternArmsAnimation(1, 16)
end

return BlackSkeleton