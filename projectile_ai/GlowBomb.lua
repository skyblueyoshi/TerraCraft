---@type ModProjectile
local GlowBomb = class("GlowBomb", require("Bomb"))

---MakeGlowingBombEffect
---@param centerX double
---@param centerY double
function MakeGlowingBombEffect(centerX, centerY)
    local loops = 32
    local flowEffectID = Reg.EffectID("flow_particular")
    for i = 1, loops do
        local rate = Utils.RandSym(1)
        local speed = 1 + 20 * math.abs(rate)
        local spx = speed * math.cos(i / loops * 2 * math.pi)
        local spy = speed * math.sin(i / loops * 2 * math.pi)

        local rotateSpeed = 0.1 * (1 - math.abs(rate))
        if rate < 0 then
            rotateSpeed = -rotateSpeed
        end
        EffectUtils.Create(
                flowEffectID,
                centerX,
                centerY,
                spx,
                spy,
                rotateSpeed,
                0,
                0,
                Color.Yellow
        )
    end
end

function GlowBomb:PostUpdate()
    local projectile = self.projectile
    LightingUtils.Add(projectile.centerXi, projectile.centerYi, 30)
end

function GlowBomb:OnKilled()
    local projectile = self.projectile
    MakeGlowingBombEffect(projectile.centerX, projectile.centerY)
    EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)
    MiscUtils.CreateExplosion(projectile.centerXi, projectile.centerYi, projectile.baseAttack.attack,
            true, true, -- hurt npc / player
            true, true, -- kill tiles / walls
            true) -- play explosion sound
end

return GlowBomb