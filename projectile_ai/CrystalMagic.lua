---@type ModProjectile
local CrystalMagic = class("CrystalMagic", ModProjectile)

function CrystalMagic:Update()
    local projectile = self.projectile
    local chasing = false
    if projectile.isCheckNpc then
        local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 300)
        if npcTarget ~= nil then
            projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 0.1,
                    projectile:GetAngleTo(npcTarget.centerX, npcTarget.centerY), projectile.maxSpeed)
            chasing = true
        end
    end
    if not chasing then
        -- random move
        projectile.speedX = projectile.speedX + Utils.RandSym(0.2)
        projectile.speedY = projectile.speedY + Utils.RandSym(0.2)
        if projectile.tickTime % 4 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("flash2"),
                    projectile.randX,
                    projectile.randY,
                    Utils.RandSym(1),
                    Utils.RandSym(1),
                    0, 1,
                    1
            )
        end
    else
        if projectile.tickTime % 2 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("flash2"),
                    projectile.randX,
                    projectile.randY,
                    -projectile.speedX / 4 + Utils.RandSym(2),
                    -projectile.speedY / 4 + Utils.RandSym(2),
                    0,
                    1,
                    1
            )
        end
    end

    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 30)

end

function CrystalMagic:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 12 do
        EffectUtils.Create(flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(6),
                Utils.RandSym(6),
                0,
                Utils.RandDoubleArea(1, 1)
        )
    end
end

function CrystalMagic:OnHitNpc(npc, hitAttack)
    self.projectile:Kill()
end

function CrystalMagic:OnHitPlayer(player, hitAttack)
    self.projectile:Kill()
end

function CrystalMagic:OnTileCollide(oldSpeedX, oldSpeedY)
    self.projectile:Kill()
end

return CrystalMagic