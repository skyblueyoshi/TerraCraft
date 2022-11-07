---@class TC.MagicWave:ModProjectile
local MagicWave = class("MagicWave", ModProjectile)

function MagicWave:TouchEffect()
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
                Color.new(200, 200, 255)
        )
    end
end

function MagicWave:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle

    local effect = EffectUtils.Create(
            Reg.EffectID("circle"),
            projectile.hots[1].x + Utils.RandSym(10),
            projectile.hots[1].y + Utils.RandSym(10),
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(0.15, 0.35),
            1.0,
            Color.new(200, 200, 255)
    )
    effect:SetDisappearTime(30)

end

function MagicWave:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function MagicWave:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function MagicWave:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return MagicWave