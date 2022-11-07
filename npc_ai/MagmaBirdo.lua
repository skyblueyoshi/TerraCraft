---@type ModNpc
local MagmaBirdo = class("MagmaBirdo", ModNpc)

local ST_NORMAL = 0
local ST_READY_TO_FIRE = 1
local ST_FIRING = 2

function MagmaBirdo:Update()
	local npc = self.npc
	if npc.state == ST_NORMAL then
		local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
		if playerTarget ~= nil then
			local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
			if distance < 240 then
				if Utils.RandTry(64) then
					npc.state = ST_READY_TO_FIRE
				end
			end
		end
	elseif npc.state == ST_READY_TO_FIRE then
		npc.maxSpeed = npc.maxSpeed * 0.5
		npc.stateTimer = npc.stateTimer + 1
		if npc.stateTimer > 128 then
			npc.stateTimer = 0
			npc.state = ST_FIRING
		end
	elseif npc.state == ST_FIRING then
		npc.maxSpeed = npc.maxSpeed * 0.25
		if npc.tickTime % 8 == 0 then
			local angle = npc.speedAngle
			local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("gun_fire"),
				npc.centerX + math.cos(angle) * 20, npc.centerY + math.sin(angle) * 20,
				10 * math.cos(angle), 10 * math.sin(angle), Attack.new(npc.baseAttack.attack * 0.4, 0, 0))
			proj.isCheckPlayer = true
		end
		npc.stateTimer = npc.stateTimer + 1
		if npc.stateTimer > 128 then
			npc.stateTimer = 0
			npc.state = ST_NORMAL
		end
	end
	npc:Fly()
end

function MagmaBirdo:OnDraw()
	local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	end
end

return MagmaBirdo