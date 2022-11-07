---@type ModProjectile
local IceBullet = class("IceBullet", ModProjectile)

function IceBullet:Update()
    local projectile = self.projectile
    if projectile.tickTime % 8 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.randX,
                projectile.randY,
                Utils.RandSym(1),
                Utils.RandSym(1)
        )
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 30)
end

function IceBullet:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 8 do
        EffectUtils.Create(
                flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(4),
                Utils.RandSym(4)
        )
    end
end

function IceBullet:OnHitNpc(npc, hitAttack)
    self.projectile:Kill()
end

function IceBullet:OnHitPlayer(player, hitAttack)
    self.projectile:Kill()
end

function IceBullet:OnTileCollide(oldSpeedX, oldSpeedY)
    self.projectile:Kill()
end

return IceBullet