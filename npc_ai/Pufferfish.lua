---@type ModNpc
local Pufferfish = class("Pufferfish", ModNpc)

local ST_NORMAL = 0
local ST_EXPANDING = 1

function Pufferfish:Update()
    local npc = self.npc
	npc:Swim()
	npc.state = ST_NORMAL
	local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
	if playerTarget ~= nil then
		local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
		if distance < 128 then
			npc.state = ST_EXPANDING
		end
	end
end

function Pufferfish:OnDraw()
    local npc = self.npc
	local scaleRate = npc.spriteEx.scaleRateX
	if npc.state == ST_EXPANDING then
		scaleRate = math.min(scaleRate + 0.01, 2)
	else
		scaleRate = math.max(scaleRate - 0.01, 1)
	end
	npc.spriteEx.scaleRateX = scaleRate
	npc.spriteEx.scaleRateY = scaleRate
	if scaleRate > 1 then
		npc.spriteRect.x = npc.spriteRect.x + npc.spriteDefaultWidth
		npc.spriteOffsetX = -(scaleRate - 1)* npc.spriteDefaultWidth / 2
		npc.spriteOffsetY = -(scaleRate - 1)* npc.spriteDefaultHeight / 2
	end
end

return Pufferfish