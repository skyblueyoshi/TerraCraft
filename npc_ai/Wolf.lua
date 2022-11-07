---@type ModNpc
local Wolf = class("Wolf", ModNpc)

function Wolf:Update()
    local npc = self.npc
	if npc.angry then
		if Utils.RandTry(512) then
			npc.angry = false
		end
	end
	npc:TryMakeSound()
	if npc.angry then
		npc.maxSpeed = npc.maxSpeed * 1.5
		npc:Walk()
	else
		npc:RandomWalk()
	end
end

function Wolf:PostUpdate()
    local npc = self.npc
	if npc.speedX == 0 then
		npc.frameTickTime = 0
	end
end

function Wolf:OnDraw()
    local npc = self.npc
	if npc.angry then
		npc.spriteRect.y = npc.spriteDefaultHeight
	end
	if npc.frameTickTime > 0 then
		npc.spriteRect.x = npc.spriteRect.x + npc.spriteDefaultWidth
	end
end

return Wolf