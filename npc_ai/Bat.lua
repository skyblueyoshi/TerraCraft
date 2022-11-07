---@type ModNpc
local Bat = class("Bat", ModNpc)

function Bat:Update()
	self.npc:Fly()
end

function Bat:OnDraw()
    local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	end
end

return Bat