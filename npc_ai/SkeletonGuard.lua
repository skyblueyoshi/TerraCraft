---@class TC.SkeletonGuard:TC.HumanFighter
local SkeletonGuard = class("SkeletonGuard", require("HumanFighter"))

function SkeletonGuard:Init()
    SkeletonGuard.super.Init(self)

    self.isFrontHandLook = true
    self.isBackHandLook = true
    self.isFrontHandLookAngleSameDirection = true
    self.isBackHandLookAngleSameDirection = true

    self.shootColdTime = 0
    self.shootingAnimation = false
end

function SkeletonGuard:Update()
    SkeletonGuard.super.Update(self)
    local npc = self.npc

    self.frontHandLookAngle = math.cos(self.npc.tickTime / 16) / 16
    self.backHandLookAngle = math.sin(self.npc.tickTime / 16) / 16

    self.npc:Fly(true)

    local effect = EffectUtils.Create(Reg.EffectID("chip"),
            self.npc.randX, self.npc.bottomY + Utils.RandSym(12),
            Utils.RandSym(0.1), Utils.RandDoubleArea(1, 1),
            Utils.RandSym(1), 1.0, 0.7,
            Color.new(200, 200, 200))
    effect:SetDisappearTime(20)

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
                local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("lighting_wheel"),
                        npc.centerX, npc.centerY, 3 * math.cos(angle), 3 * math.sin(angle), npc.baseAttack)
                proj.isCheckPlayer = true

                self.shootColdTime = 0
                self.shootingAnimation = true
            end
        end
	else
		npc:Fly(false)
	end

    if self.shootingAnimation then
        self.frontHandLookAngle = -math.sin(self.shootColdTime / 30 * math.pi)
        self.backHandLookAngle = self.frontHandLookAngle
        self.shootColdTime = self.shootColdTime + 1
        if self.shootColdTime > 30 then
            self.shootColdTime = 0
            self.shootingAnimation = false
        end
        npc.speedX = npc.speedX / 2
        npc.speedY = npc.speedY / 2
    end
end

return SkeletonGuard