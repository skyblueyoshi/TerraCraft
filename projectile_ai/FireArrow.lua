---@class TC.FireArrow:ModProjectile
local FireArrow = class("AmethystMagic", ModProjectile)

function FireArrow:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 2 == 0 then
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
    if projectile.tickTime % 1 == 0 then
        local effect = EffectUtils.Create(
                Reg.EffectID("fire_flame"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(0.3),
                Utils.RandSym(0.3),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 1.0)
        )
        effect:SetDisappearTime(20)
    end
end

function FireArrow:OnKilled()
    local projectile = self.projectile
    local effectId = Reg.EffectID("fire_flame")
    for _ = 1, 8 do
        EffectUtils.Create(
                effectId,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(2) + projectile.speedX / 4,
                Utils.RandDoubleArea(-2, 3) + projectile.speedY / 4,
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 0.5),
                1.0,
                Color.new(200, 200, 200)
        )
        EffectUtils.Create(
                Reg.EffectID("smoke"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(2) + projectile.speedX / 3,
                Utils.RandSym(2) + projectile.speedY / 3,
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.25, 0.5),
                0.9,
                Color.new(200, 200, 100)
        )
    end
    local explosionEffect = EffectUtils.Create(
            Reg.EffectID("explosion"),
            projectile.centerX,
            projectile.centerY,
            0,
            0,
            0,
            1,
            1.0,
            Color.new(200, 200, 0)
    )


end

function FireArrow:OnHitNpc(npc, _)
    local projectile = self.projectile
    projectile:Kill()
end

function FireArrow:OnHitPlayer(player, _)
    local projectile = self.projectile
    projectile:Kill()
end

function FireArrow:OnTileCollide(_, _)
    local projectile = self.projectile
    projectile:Kill()
end

return FireArrow