---@type ModNpc
local Eagle = class("Eagle", ModNpc)

function Eagle:Update()
	self.npc:Fly()
end

function Eagle:OnDraw()
    local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	end
end

return Eagle