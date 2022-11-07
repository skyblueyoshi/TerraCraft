---@type ModProjectile
local ShadowMagic = class("ShadowMagic", ModProjectile)

function ShadowMagic:Update()
    local projectile = self.projectile
    local chasing = false
    if projectile.isCheckNpc then
        local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 120)
        if npcTarget ~= nil then
            projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 0.8,
                    projectile:GetAngleTo(npcTarget.centerX, npcTarget.centerY), projectile.maxSpeed)
            chasing = true
        end
    end
    if not chasing then
        EffectUtils.Create(
                Reg.EffectID("circle"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                0,
                0,
                0,
                0.75,
                0.25
        )
    else
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
    if projectile.tickTime % 2 == 0 then
        if not chasing then
            EffectUtils.Create(
                    Reg.EffectID("flash2"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    Utils.RandSym(2),
                    Utils.RandSym(2),
                    Utils.RandSym(0.1),
                    Utils.RandDoubleArea(1, 0.25)
            )
        else
            EffectUtils.Create(
                    Reg.EffectID("flash2"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    Utils.RandSym(8),
                    Utils.RandSym(8),
                    Utils.RandSym(0.1),
                    Utils.RandDoubleArea(1, 0.25)
            )
        end
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 0, 0, 16)
end

function ShadowMagic:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 8 do
        EffectUtils.Create(
                flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(4),
                Utils.RandSym(4),
                0,
                Utils.RandDoubleArea(1, 1)
        )
    end
end

function ShadowMagic:OnHitNpc(_, _)
    self.projectile:Kill()
end

function ShadowMagic:OnHitPlayer(_, _)
    self.projectile:Kill()
end

function ShadowMagic:OnTileCollide(_, _)
    self.projectile:Kill()
end

return ShadowMagic