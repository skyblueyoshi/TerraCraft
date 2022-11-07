---@type ModNpc
local Butterfly = class("Butterfly", ModNpc)

function Butterfly:Update()
	self.npc:Fly()
end

function Butterfly:OnDraw()
	local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	end
	npc.spriteEx.scaleRateX = 0.55 + Utils.SinValue(npc.frameTickTime, 16) * 0.45
	npc.spriteOffsetX = -(npc.spriteEx.scaleRateX - 1) * npc.spriteDefaultWidth / 2
end

return Butterfly