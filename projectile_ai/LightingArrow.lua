---@type ModProjectile
local LightingArrow = class("LightingArrow", require("Arrow"))

function LightingArrow:PreUpdate()
    local projectile = self.projectile
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 32)
end

function LightingArrow:OnKilled()
    local projectile = self.projectile
    if projectile.modData.flameLevel > 0 then
        local fire_flame = Reg.EffectID("fire_flame")
        for _ = 1, 4 do
            EffectUtils.Create(
                    fire_flame,
                    projectile.centerX,
                    projectile.centerY,
                    Utils.RandSym(2),
                    Utils.RandDoubleArea(-2, 3),
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(1, 0.5),
                    1.0,
                    Color.new(200,200,200)
            )
        end
    else
        local flame_star = Reg.EffectID("flame_star")
        for _ = 1, 8 do
            EffectUtils.Create(
                    flame_star,
                    projectile.centerX,
                    projectile.centerY,
                    Utils.RandSym(2),
                    Utils.RandDoubleArea(-2, 3),
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(1, 0.5),
                    1.0,
                    Color.new(200,200,200)
            )
        end
    end
    EffectUtils.Create(
            Reg.EffectID("flame_star"),
            projectile.centerX,
            projectile.centerY,
            -projectile.speedX / 4 + Utils.RandSym(2),
            -projectile.speedY / 4 + Utils.RandSym(2),
            Utils.RandSym(0.25),
            Utils.RandDoubleArea(1, 0.5),
            1.0,
            Color.Yellow
    )
    SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
end

---OnHitNpc
---@param npc Npc
---@param hitAttack Attack
function LightingArrow:OnHitNpc(npc, hitAttack)
    local projectile = self.projectile
    npc:AddBuff(Reg.BuffID("glowing"), 300)
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
function LightingArrow:OnHitPlayer(player, hitAttack)
    local projectile = self.projectile
    player:AddBuff(Reg.BuffID("glowing"), 300)
    if projectile.modData.flameLevel > 0 then
        player:AddBuff(Reg.BuffID("fire"), 60 * (projectile.modData.flameLevel + 1))
    end
    projectile:Kill()
end

return LightingArrow