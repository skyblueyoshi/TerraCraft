---@class TC.Creeper:ModNpc
local Creeper = class("Creeper", ModNpc)

local ST_NORMAL = 0
local ST_EXPANDING_EXPLOSION = 1
local ST_CANCELING_EXPLOSION = 2

function Creeper:Init()
	self.boomPower = 8
	self.boomHurtNpc = true
	self.boomHurtPlayer = true
	self.boomKillTile = true
	self.boomKillWall = true
	self.boomWaitTime = 128
	self.boomCancelTime = 240
	self.triggerExpandingDistance = 64
end

function Creeper:Update()
    local npc = self.npc
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	npc.noMove = false
	if npc.state == ST_NORMAL then
		if npc.stand then
			if playerTarget ~= nil then

				local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
				if distance < self.triggerExpandingDistance then
					npc.state = ST_EXPANDING_EXPLOSION
					SoundUtils.PlaySound(Reg.SoundID("fuse"), npc.centerXi, npc.centerYi)
				end
			end
		end
	elseif npc.state == ST_EXPANDING_EXPLOSION then
		npc.noMove = true
		npc.stateTimer = npc.stateTimer + 1
		local canceling = false
		if playerTarget ~= nil then
			local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
			if distance > self.boomCancelTime then
				npc.state = ST_CANCELING_EXPLOSION
				canceling = true
			end
		end
		if not canceling then
			if npc.stateTimer > self.boomWaitTime then
				npc:Kill()
				MiscUtils.CreateExplosion(npc.centerXi, npc.centerYi, self.boomPower, self.boomHurtNpc, self.boomHurtPlayer, self.boomKillTile, self.boomKillWall)
				self:OnCreateBoomEffect(npc.centerX, npc.centerY)
			end
		end
	elseif npc.state == ST_CANCELING_EXPLOSION then
		npc.noMove = true
		npc.stateTimer = npc.stateTimer - 8
		if npc.stateTimer <= 0 then
			npc.stateTimer = 0
			npc.state = ST_NORMAL
		end
	end

	npc:Walk()
end

function Creeper:OnCreateBoomEffect(centerX, centerY)
	EffectUtils.CreateExplosion(centerX, centerY)
end

function Creeper:OnDraw()
    local npc = self.npc
	if npc.state == ST_EXPANDING_EXPLOSION or npc.state == ST_CANCELING_EXPLOSION then
		local scale = 1 + npc.stateTimer / 200
		npc.spriteEx.scaleRateX = scale
		npc.spriteEx.scaleRateY = scale
		npc.spriteRect.x = npc.spriteDefaultWidth * npc.frames
		npc.spriteOffsetX = math.floor(-(scale - 1) * npc.spriteDefaultWidth / 2)
		npc.spriteOffsetY = math.floor(-(scale - 1) * npc.spriteDefaultHeight)
	else
		npc.spriteEx.scaleRateX = 1
		npc.spriteEx.scaleRateY = 1
		npc.spriteOffsetX = 0
		npc.spriteOffsetY = 0
		if npc.speedX == 0 and npc.stand then
			npc.frameTickTime = 0
		end
	end
end

return Creeper