---@type ModProjectile
local StarMagic = class("StarMagic", ModProjectile)

function StarMagic:Update()
    local projectile = self.projectile
    projectile:Rotate(0.2)
    if projectile.tickTime % 8 == 0 then
        EffectUtils.Create(
                Reg.EffectID("star"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(2),
                projectile.speedY / 4 + Utils.RandSym(2),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 0.5),
                0,
                Color.new(255, 220, 0)
        )
    end
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(2),
                projectile.speedY / 4 + Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(0.75, 0.4),
                0,
                Color.Yellow
        )
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 16, 16, 0)
end

function StarMagic:OnKilled()
    local projectile = self.projectile
    for _ = 1, 8 do
        EffectUtils.Create(
                Reg.EffectID("star"),
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(2),
                Utils.RandSym(2),
                0,
                Utils.RandDoubleArea(0.5, 0.25),
                0,
                Color.Yellow
        )
    end
end

function StarMagic:OnHitNpc(npc, _)
    local projectile = self.projectile
    if projectile.modData.crossCount >= 3 then
        projectile:Kill()
    end
    projectile.modData.crossCount = projectile.modData.crossCount + 1
    npc:AddBuff(Reg.BuffID("glowing"), 120)
end

function StarMagic:OnHitPlayer(player, _)
    local projectile = self.projectile
    if projectile.modData.crossCount >= 2 then
        projectile:Kill()
    end
    projectile.modData.crossCount = projectile.modData.crossCount + 1
    player:AddBuff(Reg.BuffID("glowing"), 120)
end

function StarMagic:OnTileCollide(_, _)
    self.projectile:Kill()
end

return StarMagic