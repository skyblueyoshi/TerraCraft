---@type ModProjectile
local Fireball = class("Fireball", ModProjectile)

function Fireball:Update()
    local projectile = self.projectile

    projectile:Rotate(0.1)
    if projectile.tickTime % 8 == 0 then
        local fire_flame = Reg.EffectID("fire_flame")
        local flame_star = Reg.EffectID("flame_star")
        EffectUtils.Create(
                fire_flame,
                projectile.randX,
                projectile.randY,
                Utils.RandSym(4),
                Utils.RandSym(4),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 0.5)
        )
        EffectUtils.Create(
                flame_star,
                projectile.randX,
                projectile.randY,
                Utils.RandSym(3),
                Utils.RandSym(3),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 0.5)
        )
    end
end

function Fireball:OnKilled()
    local projectile = self.projectile
    -- explode
    if projectile.modData.boom then
        MiscUtils.CreateExplosion(projectile.centerXi, projectile.centerYi, 5, -- attack
                projectile.isCheckNpc, projectile.isCheckPlayer, -- hurt npc / player
                true, false, -- kill tiles but not walls
                true, -- play sound
                100) -- max hardness
        EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)
    else
        local fire_flame = Reg.EffectID("fire_flame")
        local flame_star = Reg.EffectID("flame_star")
        for _ = 1, 8 do
            EffectUtils.Create(
                    fire_flame,
                    projectile.randX,
                    projectile.randY,
                    Utils.RandSym(3),
                    Utils.RandSym(3),
                    Utils.RandSym(0.1),
                    Utils.RandDoubleArea(0.5, 0.5)
            )
            EffectUtils.Create(
                    flame_star,
                    projectile.randX,
                    projectile.randY,
                    Utils.RandSym(5),
                    Utils.RandSym(5),
                    Utils.RandSym(0.1),
                    Utils.RandDoubleArea(0.5, 0.5)
            )
        end
        SoundUtils.PlaySoundGroup(Reg.SoundGroupID("explode"), projectile.centerXi, projectile.centerYi)
    end

end

function Fireball:OnHitNpc(npc, hitAttack)
    self.projectile:Kill()
end

function Fireball:OnHitPlayer(player, hitAttack)
    self.projectile:Kill()
end

function Fireball:OnTileCollide(oldSpeedX, oldSpeedY)
    self.projectile:Kill()
end

return Fireball