---@class TC.UndeadMiner:TC.SwordHumanFighter
local UndeadMiner = class("UndeadMiner", require("SwordHumanFighter"))

function UndeadMiner:Init()
	UndeadMiner.super.Init(self)
	self:SetHeldItemByIDName("iron_pickaxe")
end

function UndeadMiner:Update()
	UndeadMiner.super.Update(self)
	LightingUtils.Add(self.npc.centerXi, self.npc.centerYi, 24)
	self:DoExternArmsAnimation()
end

return UndeadMiner