---@class TC.FlyEye:ModNpc
local FlyEye = class("FlyEye", ModNpc)

function FlyEye:Update()
	self.npc:Fly()
end

function FlyEye:OnDraw()
    local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	end
end

return FlyEye