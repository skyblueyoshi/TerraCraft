---@type ModProjectile
local SuperBullet = class("SuperBullet", require("Bullet"))

function SuperBullet:PostUpdate()
    local projectile = self.projectile
    for i = 1, 2 do
        EffectUtils.Create(
                Reg.EffectID("liquid_paticular"),
                projectile.centerX - projectile.speedX * i / 2,
                projectile.centerY - projectile.speedY * i / 2,
                Utils.RandSym(1),
                -1 - Utils.RandDouble(1), -- speed
                Utils.RandSym(0.05),
                Utils.RandDoubleArea(0.5, 0.5),
                1,
                Color.Yellow
        ) -- rotate, scale, alpha
    end
    EffectUtils.Create(
            Reg.EffectID("fire_flame"),
            projectile.centerX - Utils.RandDouble(projectile.speedX),
            projectile.centerY - Utils.RandDouble(projectile.speedY),
            Utils.RandSym(0.6),
            -Utils.RandDouble(1),
            Utils.RandSym(0.05),
            Utils.RandDoubleArea(0.5, 0.5),
            Utils.RandDoubleArea(0.5, 0.5)
    )
end

function SuperBullet:OnKilled()
    local projectile = self.projectile
    EffectUtils.Create(
            Reg.EffectID("liquid_paticular"),
            projectile.centerX,
            projectile.centerY,
            projectile.speedX / 16 + Utils.RandSym(0.6),
            projectile.speedY / 16 - Utils.RandDouble(1), -- speed
            Utils.RandSym(0.05),
            Utils.RandDoubleArea(0.5, 0.5),
            1,
            Color.Yellow
    ) -- rotate, scale, alpha
end

return SuperBullet