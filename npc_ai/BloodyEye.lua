---@type ModNpc
local BloodyEye = class("BloodyEye", ModNpc)

function BloodyEye:Update()
	local npc = self.npc
	npc:Fly()
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	local useShootTimer = false
	if playerTarget ~= nil then
		local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
		if distance < 560 then
			local angle = npc.speedAngle
			useShootTimer = true
			npc.stateTimer = npc.stateTimer + 1
			if npc.stateTimer >= 128 then
				npc.stateTimer = 0
				if MiscUtils.RayReach(npc.centerX, npc.centerY, playerTarget.centerX, playerTarget.centerY) then
					local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("bullet_super"),
						npc.centerX + math.cos(angle) * 20, npc.centerY + math.sin(angle) * 20,
						16 * math.cos(angle), 16 * math.sin(angle), npc.baseAttack)
					proj.isCheckPlayer = true
					SoundUtils.PlaySound(Reg.SoundID("gore1"), npc.centerXi, npc.centerYi)
				end
			end
			if npc.tickTime % 32 == 0 then
				angle = angle + Utils.RandSym(0.5)
				EffectUtils.Create(Reg.EffectID("fire_flame"),
					npc.centerX + math.cos(angle) * 20, npc.centerY + math.sin(angle) * 20,
					3 * math.cos(angle), 3 * math.sin(angle), 1,
					Utils.RandDoubleArea(0.5, 0.5), Utils.RandDoubleArea(0.75, 0.25))
			end
		end
	end
	if not useShootTimer then
		npc.stateTimer = 0
	end
end

function BloodyEye:OnDraw()
	self.npc.spriteEx.angle = self.npc.speedAngle
end

return BloodyEye