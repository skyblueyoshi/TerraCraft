---@type ModProjectile
local Arrow = class("AmethystMagic", ModProjectile)

function Arrow:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.modData.flameLevel > 0 then
        if projectile.tickTime % 4 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("fire_flame"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    Utils.RandSym(2),
                    Utils.RandSym(2),
                    Utils.RandSym(0.1),
                    Utils.RandDoubleArea(0.5, 0.5)
            )
        end
    end
end

function Arrow:PostUpdate()
    local projectile = self.projectile
    if projectile.modData.flameLevel == 0 then
        if projectile.tickTime % 2 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("arrow_paticular"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    Utils.RandSym(0.5),
                    Utils.RandSym(0.5),
                    Utils.RandSym(0.25)
            )
        end
    end
end

function Arrow:OnKilled()
    local projectile = self.projectile
    if projectile.modData.flameLevel > 0 then
        local effectId = Reg.EffectID("fire_flame")
        for _ = 1, 4 do
            EffectUtils.Create(
                    effectId,
                    projectile.centerX,
                    projectile.centerY,
                    Utils.RandSym(2),
                    Utils.RandDoubleArea(-2, 3),
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(1, 0.5),
                    1.0,
                    Color.new(200, 200, 200)
            )
        end
    else
        local effectId = Reg.EffectID("chip")
        for _ = 1, 4 do
            EffectUtils.Create(
                    effectId,
                    projectile.centerX,
                    projectile.centerY,
                    Utils.RandSym(2),
                    Utils.RandDoubleArea(-2, 3),
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(1, 0.5),
                    1.0,
                    Color.new(200, 200, 200)
            )
        end
    end
    SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
    --EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)
end

function Arrow:OnHitNpc(npc, _)
    local projectile = self.projectile
    if projectile.modData.flameLevel > 0 then
        npc:AddBuff(Reg.BuffID("fire"), 60 * (projectile.modData.flameLevel + 1))
    end
    if projectile.modData.piercingCount > 0 then
        projectile.modData.piercingCount = projectile.modData.piercingCount - 1
    else
        projectile:Kill()
    end
end

function Arrow:OnHitPlayer(player, _)
    local projectile = self.projectile
    if projectile.modData.flameLevel > 0 then
        player:AddBuff(Reg.BuffID("fire"), 60 * (projectile.modData.flameLevel + 1))
    end
    projectile:Kill()
end

function Arrow:OnTileCollide(_, _)

    local projectile = self.projectile
    if self.attachItemID ~= nil and self.attachItemID > 0 then
        ItemUtils.CreateDrop(self.attachItemID, 1, projectile.centerX, projectile.centerY,
                -1.5 * math.cos(projectile.rotateAngle), -4 * math.sin(projectile.rotateAngle))
    end
    projectile:Kill()
end

return Arrow