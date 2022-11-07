---@class TC.FireFlow:ModProjectile
local FireFlow = class("FireFlow", ModProjectile)

function FireFlow:TouchEffect()
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

function FireFlow:Update()
    local projectile = self.projectile
    projectile.color = Color.new(0, 0, 0, 0)

    if projectile.tickTime == 0 then
        for _ = 1, 8 do
            EffectUtils.Create(
                    Reg.EffectID("fire_flame"),
                    projectile.centerX,
                    projectile.centerY,
                    projectile.speedX / 6 + Utils.RandSym(1),
                    projectile.speedY / 6 + Utils.RandSym(1),
                    0,
                    Utils.RandDoubleArea(0.5, 0.5),
                    Utils.RandDoubleArea(0.5, 0.5),
                    Color.new(150, 150, 40)
            )
        end
    end

    local effect = EffectUtils.Create(
            Reg.EffectID("fire_flame"),
            projectile.hots[1].x,
            projectile.hots[1].y,
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(0.5, 0.5),
            1.0,
            Color.new(255, 180, 130)
    )
    effect:SetDisappearTime(30)

    if projectile.tickTime > 32 then
        projectile:Kill()
    end
end

function FireFlow:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function FireFlow:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function FireFlow:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return FireFlow