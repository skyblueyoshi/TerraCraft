---@class TC.DungeonSoul:ModNpc
local DungeonSoul = class("DungeonSoul", ModNpc)

function DungeonSoul:Init()

end

function DungeonSoul:Update()
	local npc = self.npc
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	if playerTarget ~= nil then
		local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
		if distance < 360 then
			npc:Fly(false)	-- random fly
		else
			npc:Fly()
		end
		if distance < 640 then
			if npc.tickTime > 0 and npc.tickTime % 128 == 0 then
				if MiscUtils.RayReach(npc.centerX, npc.centerY, playerTarget.centerX, playerTarget.centerY) then
					local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
					local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("fire_charge"),
						npc.centerX, npc.centerY, 5 * math.cos(angle), 5 * math.sin(angle), npc.baseAttack)
					proj.isCheckPlayer = true
					SoundUtils.PlaySound(Reg.SoundID("fireball"), npc.centerXi, npc.centerYi)
				end
			end
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

function DungeonSoul:OnDraw()
	local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 4
	else
		npc.spriteEx.angle = 0
	end
end

return DungeonSoul