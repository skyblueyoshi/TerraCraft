---@type ModProjectile
local Bullet = class("Bullet", ModProjectile)

function Bullet:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 8, 24)
end

function Bullet:OnKilled()
    local projectile = self.projectile
    local spx = math.min(math.max(projectile.speedX, -24), 24)
    local spy = math.min(math.max(projectile.speedY, -24), 24)

    EffectUtils.Create(
            Reg.EffectID("liquid_paticular"),
            projectile.centerX,
            projectile.centerY,
            -spx / 16 + Utils.RandSym(1),
            -spy / 16 - Utils.RandDouble(2),
            0,
            0.5,
            0,
            Color.Yellow
    )
end

function Bullet:OnHitNpc(_, _)
    self.projectile:Kill()
end

function Bullet:OnHitPlayer(_, _)
    self.projectile:Kill()
end

function Bullet:OnTileCollide(_, _)
    self.projectile:Kill()
end

return Bullet