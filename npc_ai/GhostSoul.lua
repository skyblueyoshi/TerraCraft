---@class TC.GhostSoul:ModNpc
local GhostSoul = class("GhostSoul", ModNpc)

function GhostSoul:Update()
	self.npc:Fly()
end

function GhostSoul:OnDraw()
    local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	end
end

return GhostSoul