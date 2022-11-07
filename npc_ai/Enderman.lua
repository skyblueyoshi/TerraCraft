---@type ModNpc
local Enderman = class("Enderman", require("HumanFighter"))

local function Teleport(npc)
	local currentX = npc.x
	local currentY = npc.y
	local teleportSuccess = npc:RandomTeleport(32)
	if teleportSuccess then

		local sg_portal = Reg.SoundGroupID("portal")
		local e_ender_flash = Reg.EffectID("ender_flash")

		for _ = 1, 16 do
			EffectUtils.Create(e_ender_flash, currentX + Utils.RandInt(npc.width),
				currentY + Utils.RandInt(npc.height),
				Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(1), 2)
		end
		for _ = 1, 16 do
			EffectUtils.Create(e_ender_flash, npc.randX, npc.randY,
				Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(1), 2)
		end
		SoundUtils.PlaySoundGroup(sg_portal, npc.centerXi, npc.centerYi)
	end
end

function Enderman:Init()
    self.boneSizeIndex = 1
	Enderman.super.Init(self)
end

function Enderman:Update()
	local npc = self.npc
	if npc.angry then
		print("aaaa")
		npc.maxSpeed = npc.maxSpeed * 1.5
		if npc.stand and Utils.RandTry(32) then
			npc.speedY = -6
		end
	else
		npc:TryMakeSound()
	end
	npc:Walk()
	local tp = false
	if npc.inLiquid then
		tp = true
	elseif npc.stand and Utils.RandTry(256) then
		tp = true
	else
		-- check projectiles
		local projectiles = ProjectileUtils.SearchByCircle(npc.centerX, npc.centerY, 80)
		for i = 1, projectiles.length do
			local proj = projectiles[i]
			if proj.isCheckNpc then
				tp = true
				break
			end
		end
	end
	if tp then
		Teleport(npc)
	end
end

function Enderman:OnHit()
	Teleport(self.npc)
end

return Enderman