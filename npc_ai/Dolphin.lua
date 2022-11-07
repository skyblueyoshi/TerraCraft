---@type ModNpc
local Dolphin = class("Dolphin", ModNpc)

function Dolphin:Update()
    local npc = self.npc
	npc:TryMakeSound()
	npc:Swim()
	-- always want to swim up
	if npc.inLiquid then
		npc.maxSpeed = npc.maxSpeed * 2
	end
	if npc.inLiquid and Utils.RandTry(128) then
		npc.speedY = npc.speedY - 0.1
	end
	-- jump out of the liquid
	if not npc.inLiquid and npc.oldInLiquid and npc.speedY < 0 then
		if (npc.direction and npc.speedX > 0) or (not npc.direction and npc.speedX < 0) then
			npc.speedY = -npc.jumpForce
		end
		npc:MakeSound()
	end
end

function Dolphin:OnDraw()
    local npc = self.npc
	local angle = Utils.GetAngle(math.abs(npc.speedX), npc.speedY) * 0.5
	if (npc.direction and npc.speedX > 0) or (not npc.direction and npc.speedX < 0) then
		angle = -angle
	end
	npc.spriteEx.angle = angle
end

return Dolphin