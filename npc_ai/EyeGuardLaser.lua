---@class TC.EyeGuardLaser:ModNpc
local EyeGuardLaser = class("EyeGuardLaser", ModNpc)

function EyeGuardLaser:Init()

end

function EyeGuardLaser:Update()
	local npc = self.npc
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	if playerTarget ~= nil then
		local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
		if distance < 360 then
			npc:Fly(false)	-- random fly
		else
			npc:Fly()
		end
		npc.direction = npc.centerX < playerTarget.centerX
        if distance < 640 then
            if npc.tickTime > 0 and npc.tickTime % 128 == 0 then
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
				if angle > -math.pi / 2 and angle < math.pi / 2 then
					angle = angle - 0.5
				else
					angle = angle + 0.5
				end
                local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("fire_wave"),
                        npc.centerX, npc.centerY, 6 * math.cos(angle), 6 * math.sin(angle), npc.baseAttack)
                proj.isCheckPlayer = true
            end
        end
	else
		npc:Fly(false)
	end


	if npc.tickTime % 64 == 0 then
		EffectUtils.Create(Reg.EffectID("flame_star"), npc.randX, npc.randY,
			-npc.speedX, -npc.speedY,
			Utils.RandSym(1.0), Utils.RandDoubleArea(1, 2))
	end
	LightingUtils.Add(npc.centerXi, npc.centerYi, 24, 12, 0, 0)
end

function EyeGuardLaser:OnDraw()
	local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 4
	else
		npc.spriteEx.angle = 0
	end
end

return EyeGuardLaser