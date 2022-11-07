---@class TC.RedSpeedUp:ModProjectile
local RedSpeedUp = class("RedSpeedUp", ModProjectile)

function RedSpeedUp:TouchEffect()
    local projectile = self.projectile
    for _ = 1, 12 do
        EffectUtils.Create(
                Reg.EffectID("circle"),
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(3),
                Utils.RandSym(3),
                0,
                Utils.RandDoubleArea(0.25, 0.25),
                Utils.RandDoubleArea(0.5, 0.5),
                Color.new(200, 0, 0)
        )
    end
end

function RedSpeedUp:Update()
    local projectile = self.projectile

    local angle = projectile.speedAngle
    local speed = Vector2.new(projectile.speedX, projectile.speedY).length
    speed = speed + 0.1
    projectile.speedX = speed * math.cos(angle)
    projectile.speedY = speed * math.sin(angle)

    local effect = EffectUtils.Create(
            Reg.EffectID("circle"),
            projectile.hots[1].x + Utils.RandSym(10),
            projectile.hots[1].y + Utils.RandSym(10),
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(0.15, 0.35),
            1.0,
            Color.new(200, 0, 0)
    )
    effect:SetDisappearTime(30)

end

function RedSpeedUp:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function RedSpeedUp:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function RedSpeedUp:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return RedSpeedUp