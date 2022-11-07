---@class TC.LightingWheel:ModProjectile
local LightingWheel = class("LightingWheel", ModProjectile)

function LightingWheel:TouchEffect()
    local projectile = self.projectile
    for _ = 1, 4 do
        EffectUtils.Create(
                Reg.EffectID("fire_flame"),
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(1),
                Utils.RandSym(1),
                0,
                Utils.RandDoubleArea(1, 1),
                Utils.RandDoubleArea(0.5, 0.5),
                Color.new(150, 150, 40)
        )
    end
end

function LightingWheel:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.rotateAngle + 0.2

    local effect = EffectUtils.Create(
            Reg.EffectID("circle"),
            projectile.hots[1].x,
            projectile.hots[1].y,
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(0.5, 0.5),
            1.0,
            Color.new(255, 255, 130)
    )
    effect:SetDisappearTime(30)

    if projectile.tickTime > 0 and projectile.tickTime % 32 == 0 then
        local angle = -projectile.tickTime / 32 - math.pi / 2
        local proj = ProjectileUtils.Create(Reg.ProjectileID("lighting_bullet_yellow"),
                projectile.centerX, projectile.centerY,
                2 * math.cos(angle), 2 * math.sin(angle),
                projectile.baseAttack)
        proj.isCheckPlayer = true
    end

end

function LightingWheel:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function LightingWheel:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function LightingWheel:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return LightingWheel