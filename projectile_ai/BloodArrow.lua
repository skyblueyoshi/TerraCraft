---@type ModProjectile
local BloodArrow = class("BloodArrow", require("Arrow"))

function BloodArrow:PostUpdate()
    local projectile = self.projectile
    if projectile.modData.flameLevel == 0 then
        if projectile.tickTime % 2 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("arrow_paticular"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    projectile.speedX / 8 + Utils.RandSym(2),
                    projectile.speedY / 8 + Utils.RandSym(2),
                    0,
                    Utils.RandDoubleArea(1, 1),
                    0,
                    Color.Red
            )
        end
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 16, 20, 12)
end

---OnHitNpc
---@param npc Npc
---@param hitAttack Attack
function BloodArrow:OnHitNpc(npc, hitAttack)
    local projectile = self.projectile
    npc:AddBuff(Reg.BuffID("hurt"), 120)
    if projectile.modData.flameLevel > 0 then
        npc:AddBuff(Reg.BuffID("fire"), 60 * (projectile.modData.flameLevel + 1))
    end
    if projectile.modData.piercingCount > 0 then
        projectile.modData.piercingCount = projectile.modData.piercingCount - 1
    else
        projectile:Kill()
    end
end

---OnHitPlayer
---@param player Player
---@param hitAttack Attack
function BloodArrow:OnHitPlayer(player, hitAttack)
    local projectile = self.projectile
    player:AddBuff(Reg.BuffID("hurt"), 120)
    if projectile.modData.flameLevel > 0 then
        player:AddBuff(Reg.BuffID("fire"), 60 * (projectile.modData.flameLevel + 1))
    end
    projectile:Kill()
end

return BloodArrow