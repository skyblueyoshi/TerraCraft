---@type ModProjectile
local SnowFlake = class("SnowFlake", ModProjectile)

function SnowFlake:Update()
    local projectile = self.projectile
    if projectile.speedX == 0 and projectile.speedY == 0 then
        projectile:Kill()
    else
        projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 0.05, projectile.speedAngle, 14.0)
    end
    if projectile.tickTime >= 600 then
        projectile:Kill()
    end
    projectile:Rotate(0.03)
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.hots[1].x + Utils.RandSym(20),
                projectile.hots[1].y + Utils.RandSym(20),
                Utils.RandSym(2),
                Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(1.5, 1)
        )
    end
end

function SnowFlake:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 12 do
        EffectUtils.Create(
                flash2,
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(5),
                Utils.RandSym(5),
                0,
                Utils.RandDoubleArea(1, 1)
        )
    end
end

function SnowFlake:OnHitNpc(_, _)
    self.projectile:Kill()
end

function SnowFlake:OnHitPlayer(_, _)
    self.projectile:Kill()
end

function SnowFlake:OnTileCollide(_, _)
    self.projectile:Kill()
end

return SnowFlake