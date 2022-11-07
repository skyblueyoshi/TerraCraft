---@class TC.Spike:ModProjectile
local Spike = class("Spike", ModProjectile)

function Spike:Update()
    local projectile = self.projectile

    if projectile.modData.crossCount == 0 then
        projectile.rotateAngle = projectile.speedAngle

        local effect = EffectUtils.Create(
                Reg.EffectID("chip"),
                projectile.centerX,
                projectile.centerY,
                projectile.speedX / 2 + Utils.RandSym(2),
                projectile.speedY / 2 + Utils.RandSym(2),
                Utils.RandSym(1),
                Utils.RandDoubleArea(0.5, 0.5),
                1.0,
                Color.new(200, 200, 200)
        )
        effect.gravity = false
        effect:SetDisappearTime(20)
    else
        projectile.rotateAngle = projectile.rotateAngle + 0.1
    end
end

function Spike:OnKilled()
    local projectile = self.projectile
    local effectId = Reg.EffectID("chip")
    for _ = 1, 8 do
        local effect = EffectUtils.Create(
                effectId,
                projectile.centerX,
                projectile.centerY,
                projectile.speedX + Utils.RandSym(2),
                -projectile.speedY + Utils.RandSym(2),
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 1.5),
                1.0,
                Color.new(200, 200, 200)
        )
        effect:SetDisappearTime(40)
    end
end

function Spike:OnHitNpc(npc, _)
    local projectile = self.projectile
    if projectile.modData.crossCount >= 6 then
        projectile:Kill()
    end
    projectile.modData.crossCount = projectile.modData.crossCount + 1
end

function Spike:OnHitPlayer(player, _)
    local projectile = self.projectile
    if projectile.modData.crossCount >= 6 then
        projectile:Kill()
    end
    projectile.modData.crossCount = projectile.modData.crossCount + 1
end

function Spike:OnTileCollide(_, _)
    local projectile = self.projectile
    if projectile.modData.crossCount >= 2 then
        projectile:Kill()
    end
    projectile.modData.crossCount = projectile.modData.crossCount + 1
    projectile.speedX = -projectile.speedX / 2
end

return Spike