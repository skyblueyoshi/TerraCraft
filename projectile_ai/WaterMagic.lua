---@type ModProjectile
local WaterMagic = class("WaterMagic", ModProjectile)

function WaterMagic:TouchEffect()
    local projectile = self.projectile
    for _ = 1, 2 do
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(2),
                Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(1, 1),
                0,
                Color.new(66, 66, 255)
        )
    end
end

function WaterMagic:Update()
    local projectile = self.projectile
    if projectile.tickTime % 2 == 0 then
        EffectUtils.Create(
                Reg.EffectID("chip"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(0.25),
                projectile.speedY / 4 + Utils.RandSym(0.25),
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 1),
                0.5,
                Color.new(66, 66, 255)
        )
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 0, 0, 16)
    if projectile.tickTime > 32 then
        projectile:Kill()
    end
end

function WaterMagic:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function WaterMagic:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function WaterMagic:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return WaterMagic