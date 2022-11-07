---@class TC.LightingBulletYellow:ModProjectile
local LightingBulletYellow = class("LightingBulletYellow", ModProjectile)

function LightingBulletYellow:TouchEffect()
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

function LightingBulletYellow:Update()
    local projectile = self.projectile

end

function LightingBulletYellow:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function LightingBulletYellow:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function LightingBulletYellow:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return LightingBulletYellow