---@type ModNpc
local IceElf = class("IceElf", ModNpc)

local e_liquid_paticular = Reg.EffectID("liquid_paticular")

function IceElf:Update()
    local npc = self.npc
	npc:Fly()
	if Utils.RandTry(16) then
		EffectUtils.Create(e_liquid_paticular, npc.randX, npc.randY,
			Utils.RandSym(1.0), Utils.RandSym(1.0))
	end
end

function IceElf:OnDraw()
    local npc = self.npc
	if npc.maxSpeed > 0 then
		npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
	else
		npc.spriteEx.angle = 0
	end
end

return IceElf