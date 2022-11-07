---@class TC.FlameSoul:ModNpc
local FlameSoul = class("FlameSoul", ModNpc)

function FlameSoul:Init()

end

function FlameSoul:Update()
	local npc = self.npc
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	if playerTarget ~= nil then
		local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
		if distance < 360 then
			npc:Fly(false)	-- random fly
		else
			npc:Fly()
		end
	else
		npc:Fly(false)
	end

	if npc.tickTime % 4 == 0 then
		EffectUtils.Create(Reg.EffectID("flame_star"), npc.randX, npc.randY,
			-npc.speedX, -npc.speedY,
			Utils.RandSym(1.0), Utils.RandDoubleArea(1, 2))
	end
	LightingUtils.Add(npc.centerXi, npc.centerYi, 24, 12, 0, 0)
end

function FlameSoul:OnDraw()
	local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 4
	else
		npc.spriteEx.angle = 0
	end
end

return FlameSoul