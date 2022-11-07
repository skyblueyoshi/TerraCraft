---@type ModProjectile
local Rocket = class("Rocket", ModProjectile)

function Rocket:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("smoke"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(2),
                Utils.RandSym(2),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.25, 0.5),
                0.6,
                Color.new(64, 64, 64)
        )
    end
    if projectile.tickTime % 2 == 0 then
        EffectUtils.Create(
                Reg.EffectID("fire_flame"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(0.1),
                Utils.RandSym(0.1),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(1, 2)
        )
    end
end

function Rocket:OnKilled()
    local projectile = self.projectile
    MiscUtils.CreateExplosion(projectile.centerXi, projectile.centerYi, 11, projectile.isCheckNpc, projectile.isCheckPlayer,
    true,true)
    EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)
end

function Rocket:OnHitNpc(_, _)
    self.projectile:Kill()
end

function Rocket:OnHitPlayer(_, _)
    self.projectile:Kill()
end

function Rocket:OnTileCollide(_, _)
    self.projectile:Kill()
end

return Rocket