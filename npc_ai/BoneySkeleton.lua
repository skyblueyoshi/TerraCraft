---@class TC.BoneySkeleton:TC.SwordHumanFighter
local BoneySkeleton = class("BoneySkeleton", require("SwordHumanFighter"))

function BoneySkeleton:Init()
	BoneySkeleton.super.Init(self)
	self:SetHeldItemByIDName("iron_axe")
end

function BoneySkeleton:Update()
	BoneySkeleton.super.Update(self)
	self:DoExternArmsAnimation(1, 32)
end

return BoneySkeleton