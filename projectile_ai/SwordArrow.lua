---@type ModProjectile
local SwordArrow = class("SwordArrow", require("Arrow"))

function SwordArrow:Update()
    local projectile = self.projectile
    local chasing = false
    if projectile.isCheckNpc then
        local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 120)
        if npcTarget ~= nil then
            projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 1.0,
                    projectile:GetAngleTo(npcTarget.centerX, npcTarget.centerY), projectile.maxSpeed)
            chasing = true
        end
    end
    if not chasing then
        projectile.gravity = 0.2
        EffectUtils.Create(
                Reg.EffectID("circle"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                0,
                0,
                0,
                0.5
        )
    else
        projectile.gravity = 0.0
        EffectUtils.Create(
                Reg.EffectID("circle"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(2),
                Utils.RandSym(2),
                0,
                0.75,
                0.25
        )
    end
    projectile.rotateAngle = projectile.speedAngle
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 24, 24)
end

function SwordArrow:OnKilled()
    local projectile = self.projectile
    local circle = Reg.EffectID("circle")
    for _ = 1, 8 do
        EffectUtils.Create(
                circle,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(4),
                Utils.RandSym(4)
        )
    end
    SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
end

function SwordArrow:OnHitNpc(npc, hitAttack)
    self.projectile:Kill()
end

function SwordArrow:OnHitPlayer(player, hitAttack)
    self.projectile:Kill()
end

return SwordArrow