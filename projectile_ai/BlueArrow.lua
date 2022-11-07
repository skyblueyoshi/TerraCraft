---@class TC.BlueArrow:ModProjectile
local BlueArrow = class("BlueArrow", ModProjectile)

function BlueArrow:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 2 == 0 then
        local spx = projectile.speedX / 4 + Utils.RandSym(1)
        local spy = projectile.speedY / 4 + Utils.RandSym(1)
        local effect = EffectUtils.Create(
                Reg.EffectID("chip_fast"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                spx,
                spy,
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(1.0, 1.0)
        )
        effect.lightAlpha = 24
        effect.color = Color.new(255, 100, 255)
        effect.gravity = false
    end
    projectile.gravity = 0
end

function BlueArrow:OnKilled()
    local projectile = self.projectile
    local effectId = Reg.EffectID("chip_fast")
    for _ = 1, 8 do
        local spx = -projectile.speedX / 8 + Utils.RandSym(1)
        local spy = -projectile.speedY / 8 + Utils.RandSym(1)
        local effect = EffectUtils.Create(
                effectId,
                projectile.centerX,
                projectile.centerY,
                spx,
                spy,
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 1.0),
                1.0,
                Color.new(255, 100, 255)
        )
        effect.lightAlpha = 24
        effect.gravity = false
    end
    SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
end

function BlueArrow:OnHitNpc(npc, _)
    self.projectile:Kill()
end

function BlueArrow:OnHitPlayer(player, _)
    self.projectile:Kill()
end

function BlueArrow:OnTileCollide(_, _)
    self.projectile:Kill()
end

return BlueArrow