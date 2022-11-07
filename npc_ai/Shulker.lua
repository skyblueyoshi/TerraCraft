---@type ModNpc
local Shulker = class("Shulker", ModNpc)

local ST_NORMAL = 0
local ST_OPENING = 1
local ST_OPENED = 2
local ST_CLOSING = 3

function Shulker:Teleport()
    local npc = self.npc
	local currentX = npc.x
	local currentY = npc.y
	local teleportSuccess = npc:RandomTeleport(16, true)
	if teleportSuccess then
		for i = 1, 16 do
			EffectUtils.Create(Reg.EffectID("ender_flash"), currentX + Utils.RandInt(npc.width),
				currentY + Utils.RandInt(npc.height),
				Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(1), 2)
		end
		for i = 1, 16 do
			EffectUtils.Create(Reg.EffectID("ender_flash"), npc.randX, npc.randY,
				Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(1), 2)
		end
		SoundUtils.PlaySoundGroup(Reg.SoundGroupID("portal"), npc.centerXi, npc.centerYi)
	end
end

function Shulker:Update()
    local npc = self.npc
	npc.speedX = Utils.SlowSpeed1D(npc.speedX, 0.05)
	npc.speedY = Utils.SinValue(npc.tickTime, 128)
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	if playerTarget ~= nil then
		npc.direction = (playerTarget.centerX > npc.centerX)
	end
	if npc.state == ST_NORMAL then
		if Utils.RandTry(128) then
			npc.stateTimer = 0
			npc.state = ST_OPENING
			SoundUtils.PlaySound(Reg.SoundID("shulker_open"), npc.centerXi, npc.centerYi)
		end
	elseif npc.state == ST_OPENING then
		npc.stateTimer = npc.stateTimer + 1
		if npc.stateTimer >= 32 then
			npc.stateTimer = 0
			npc.state = ST_OPENED
		end
	elseif npc.state == ST_OPENED then
		if playerTarget ~= nil then
			local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
			if distance < 640 then
				if npc.tickTime % 128 == 0 then
					local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
					local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("shulker_bullet"),
						npc.centerX, npc.centerY, 4 * math.cos(angle), 4 * math.sin(angle), npc.baseAttack)
					proj.isCheckPlayer = true
					SoundUtils.PlaySound(Reg.SoundID("fireball"), npc.centerXi, npc.centerYi)
				end
			end
		end
		npc.stateTimer = npc.stateTimer + 1
		if npc.stateTimer >= 256 then
			npc.stateTimer = 0
			npc.state = ST_CLOSING
			SoundUtils.PlaySound(Reg.SoundID("shulker_close"), npc.centerXi, npc.centerYi)
		end
	elseif npc.state == ST_CLOSING then
		npc.stateTimer = npc.stateTimer + 1
		if npc.stateTimer >= 32 then
			npc.stateTimer = 0
			npc.state = ST_NORMAL
		end
	end
	if npc.tickTime % 128 == 0 then
		if Utils.RandTry(2) then
			Teleport()
		end
	end
end

function Shulker:OnHit()
	self:Teleport()
end

function Shulker:OnDraw()
    local npc = self.npc
	npc.spriteEx.angle = npc.speedY / 16 + npc.speedY / 8
	if npc.state == ST_NORMAL then
		npc.frameTickTime = 0
	elseif npc.state == ST_OPENING then
		
	elseif npc.state == ST_OPENED then
		npc.frameTickTime = (npc.frames - 1) * npc.frameSpeed
	elseif npc.state == ST_CLOSING then
		npc.frameTickTime = npc.frameTickTime - 2
	end
	npc.frameTickTime = math.max(npc.frameTickTime, 0)
	npc.frameTickTime = math.min(npc.frameTickTime, (npc.frames - 1) * npc.frameSpeed)
	npc.spriteEx.x = npc.spriteDefaultWidth * npc.frameIndex
end

return Shulker