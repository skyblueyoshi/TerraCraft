---@type ModProjectile
local AmethystMagic = class("AmethystMagic", ModProjectile)

function AmethystMagic:Update()
    local projectile = self.projectile
    projectile:Rotate(0.4)
    if projectile.tickTime % 8 == 0 then
        EffectUtils.Create(
                Reg.EffectID("star"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(1),
                projectile.speedY / 4 + Utils.RandSym(1),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 0.5),
                1.0,
                Color.new(160, 100, 255)
        )
    end
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(2),
                projectile.speedY / 4 + Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(1, 1),
                1.0,
                Color.new(160, 100, 255)
        )
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 8, 0, 16)
end

function AmethystMagic:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 8 do
        EffectUtils.Create(
                flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(2),
                Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(1, 1),
                1.0,
                Color.new(160, 100, 255)
        )
    end
end

function AmethystMagic:OnHitNpc(_, _)
    self.projectile:Kill()
end

function AmethystMagic:OnHitPlayer(_, _)
    self.projectile:Kill()
end

function AmethystMagic:OnTileCollide(_, _)
    self.projectile:Kill()
end

return AmethystMagic