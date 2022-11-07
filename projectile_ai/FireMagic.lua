---@type ModProjectile
local FireMagic = class("FireMagic", ModProjectile)

function FireMagic:Update()
    local projectile = self.projectile
    if projectile.isCheckNpc then
        local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 120)
        if npcTarget ~= nil then
            projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 0.4,
                    projectile:GetAngleTo(npcTarget.centerX, npcTarget.centerY), projectile.maxSpeed)
        end
    end
    EffectUtils.Create(
            Reg.EffectID("circle"),
            projectile.hots[1].x,
            projectile.hots[1].y,
            0,
            0,
            0,
            0.75,
            0.8,
            Color.Yellow
    )
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 30)
end

function FireMagic:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 8 do
        EffectUtils.Create(flash2,
                projectile.centerX,
                projectile.centerY,
                -projectile.speedX / 8 + Utils.RandSym(2),
                -projectile.speedY / 8 - Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(1, 1),
                0,
                Color.Yellow
        )
    end
end

---OnHitNpc
---@param npc Npc
---@param _ Attack
function FireMagic:OnHitNpc(npc, _)
    npc:AddBuff(Reg.BuffID("fire"), 240)
    self.projectile:Kill()
end

---OnHitPlayer
---@param player Player
---@param _ Attack
function FireMagic:OnHitPlayer(player, _)
    player:AddBuff(Reg.BuffID("fire"), 240)
    self.projectile:Kill()
end

function FireMagic:OnTileCollide(_, _)
    self.projectile:Kill()
end

return FireMagic