---@type ModProjectile
local LaserBullet = class("LaserBullet", require("Bullet"))

function LaserBullet:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 0, 0, 24)
end

function LaserBullet:OnKilled()
    local projectile = self.projectile
    EffectUtils.Create(
            Reg.EffectID("liquid_paticular"),
            projectile.centerX,
            projectile.centerY,
            Utils.RandSym(2),
            Utils.RandSym(2),
            0,
            0.5,
            0.5,
            Color.new(100, 100, 255)
    )
end

return LaserBullet