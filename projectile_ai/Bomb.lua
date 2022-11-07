---@type ModProjectile
local Bomb = class("Bomb", ModProjectile)

function Bomb:Update()
    local projectile = self.projectile
    -- slow speed
    if projectile.stand then
        projectile.speedX = Utils.SlowSpeed1D(projectile.speedX, 0.025)
    end
    -- rotate
    if projectile.speedX ~= 0 then
        projectile:Rotate(projectile.speedX / (projectile.height / 2))
    end
    -- make fire effect every 4 ticks
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flame_star"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(0.3),
                Utils.RandSym(0.2),
                0,
                Utils.RandDoubleArea(1, 1)
        )
    end
    -- make explosion after the bomb survives target time
    if projectile.tickTime > projectile.targetTime then
        projectile:Kill()
    end
end

function Bomb:OnKilled()
    local projectile = self.projectile
    EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)
    MiscUtils.CreateExplosion(projectile.centerXi, projectile.centerYi, projectile.baseAttack.attack,
            true, true, -- hurt npc / player
            true, true, -- kill tiles / walls
            true) -- play explosion sound
end

function Bomb:OnHitNpc(npc, hitAttack)
    self.projectile:Kill()
end

function Bomb:OnHitPlayer(player, hitAttack)
    self.projectile:Kill()
end

function Bomb:OnTileCollide(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    --bounce
    if projectile.stand then
        if oldSpeedY > 0.5 then
            projectile.speedY = -oldSpeedY / 3
        end
    end
end

return Bomb