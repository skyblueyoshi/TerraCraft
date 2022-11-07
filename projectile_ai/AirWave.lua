---@class TC.AirWave:ModProjectile
local AirWave = class("AirWave", ModProjectile)

function AirWave:TouchEffect()
    local projectile = self.projectile
    for _ = 1, 4 do
        EffectUtils.Create(
                Reg.EffectID("star"),
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(1),
                Utils.RandSym(1),
                0,
                Utils.RandDoubleArea(0.4, 0.1),
                Utils.RandDoubleArea(0.5, 0.5),
                Color.new(177, 177, 255)
        )
    end
end

function AirWave:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle

    local effect = EffectUtils.Create(
            Reg.EffectID("circle"),
            projectile.hots[1].x + Utils.RandSym(10),
            projectile.hots[1].y + Utils.RandSym(10),
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(0.15, 0.15),
            1.0,
            Color.new(200, 255, 255)
    )
    effect:SetDisappearTime(30)

end

function AirWave:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function AirWave:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function AirWave:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return AirWave