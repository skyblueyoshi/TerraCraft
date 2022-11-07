---@class TC.WitherSkeleton:TC.SwordHumanFighter
local WitherSkeleton = class("WitherSkeleton", require("SwordHumanFighter"))

function WitherSkeleton:Init()
    self.boneSizeIndex = 1
	WitherSkeleton.super.Init(self)
    self:SetHeldItemByIDName("iron_sword")
end

return WitherSkeleton