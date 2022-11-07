---@class TC.FireFlowLarge:ModProjectile
local FireFlowLarge = class("FireFlowLarge", ModProjectile)

function FireFlowLarge:TouchEffect()
    local projectile = self.projectile
    for _ = 1, 8 do
        EffectUtils.Create(
                Reg.EffectID("fire_flame"),
                projectile.centerX,
                projectile.centerY,
                -projectile.speedX / 4 + Utils.RandSym(3),
                -projectile.speedY / 4 + Utils.RandSym(3),
                0,
                Utils.RandDoubleArea(1, 1),
                1.0,
                Color.new(255, 200, 0)
        )
    end
end

function FireFlowLarge:Update()
    local projectile = self.projectile
    projectile.color = Color.new(0, 0, 0, 0)
    projectile.speedY = projectile.speedY + 0.2

    if projectile.tickTime == 0 then
        for _ = 1, 2 do
            EffectUtils.Create(
                    Reg.EffectID("fire_flame"),
                    projectile.centerX,
                    projectile.centerY,
                    projectile.speedX / 6 + Utils.RandSym(1),
                    projectile.speedY / 6 + Utils.RandSym(1),
                    0,
                    1.0,
                    Utils.RandDoubleArea(0.5, 0.5),
                    Color.new(255, 200, 0)
            )
        end
    end

    local effect = EffectUtils.Create(
            Reg.EffectID("fire_flame"),
            projectile.hots[1].x,
            projectile.hots[1].y,
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(1.5, 0.5),
            1.0,
            Color.new(255, 180, 130)
    )
    effect:SetDisappearTime(60)

    if projectile.tickTime > 100 then
        projectile:Kill()
    end

    local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 30)
    if npcTarget ~= nil then
        npcTarget:AddBuff(Reg.BuffID("fire"), 100)
    end
end

function FireFlowLarge:OnHitNpc(npc, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function FireFlowLarge:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function FireFlowLarge:OnTileCollide(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

return FireFlowLarge