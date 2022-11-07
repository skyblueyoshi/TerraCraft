---@type ModProjectile
local Glowball = class("Glowball", ModProjectile)

function Glowball:Update()
    local projectile = self.projectile
    -- slow speed
    if projectile.stand then
        projectile.speedX = Utils.SlowSpeed1D(projectile.speedX, 0.025)
    end
    -- rotate
    if projectile.speedX ~= 0 then
        projectile:Rotate(projectile.speedX / (projectile.height / 2))
    end
    LightingUtils.Add(projectile.centerXi, projectile.centerYi, 28)
    -- make fire effect every 4 ticks
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flame_star"),
                projectile.randX,
                projectile.randY,
                Utils.RandSym(1),
                Utils.RandSym(1),
                0,
                Utils.RandDoubleArea(1, 1)
        )
    end
    -- make explosion after the bomb survives target time
    if projectile.tickTime > projectile.targetTime then
        projectile:Kill()
    end
end

function Glowball:OnKilled()
    local projectile = self.projectile
    local flame_star = Reg.EffectID("flame_star")
    for i = 1, 32 do
        EffectUtils.Create(
                flame_star,
                projectile.randX,
                projectile.randY,
                Utils.RandSym(3),
                Utils.RandSym(3),
                0,
                Utils.RandDoubleArea(1, 1)
        )
    end
end

---OnHitNpc
---@param npc Npc
---@param hitAttack Attack
function Glowball:OnHitNpc(npc, hitAttack)
    npc:AddBuff(Reg.BuffID("glowing"), 120)
end

function Glowball:OnTileCollide(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    -- bounce
    if projectile.stand then
        if oldSpeedY > 0.5 then
            projectile.speedY = -oldSpeedY / 1.5
        end
    end
end

return Glowball