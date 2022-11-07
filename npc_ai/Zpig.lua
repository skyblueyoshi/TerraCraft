---@class TC.ZPig:TC.SwordHumanFighter
local ZPig = class("ZPig", require("SwordHumanFighter"))

function ZPig:Init()
	ZPig.super.Init(self)
	self:SetHeldItemByIDName("golden_sword")
	self.alwaysTrySwing = false
end

function ZPig:Update()
	ZPig.super.Update(self)

	local npc = self.npc
	npc:TryMakeSound()
	self.alwaysTrySwing = false
	if npc.angry then
		npc.maxSpeed = npc.maxSpeed * 1.5
		npc:Walk()
		self.alwaysTrySwing = true
	else
		npc:RandomWalk()
	end
end

return ZPig