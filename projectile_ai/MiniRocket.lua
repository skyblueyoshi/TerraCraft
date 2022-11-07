---@class TC.MiniRocket:ModProjectile
local MiniRocket = class("MiniRocket", ModProjectile)

function MiniRocket:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime == 0 then
        for i = 1, 5 do
            EffectUtils.Create(
                    Reg.EffectID("smoke"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    projectile.speedX / 4 + Utils.RandSym(2),
                    projectile.speedY / 4 + Utils.RandSym(2),
                    Utils.RandSym(0.1),
                    Utils.RandDoubleArea(0.25, 0.75),
                    0.9,
                    Color.new(255, 255, 200)
            )
        end
        local s = Vector2.new(projectile.speedX, projectile.speedY).length
        s = s * Utils.RandDoubleArea(0.7, 0.3)
        local angle = projectile.speedAngle
        projectile.speedX = s * math.cos(angle)
        projectile.speedY = s * math.sin(angle)
    end
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("smoke"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(1),
                Utils.RandSym(1),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.25, 0.5),
                0.9,
                Color.new(164, 164, 64)
        )
    end
    if projectile.tickTime % 1 == 0 then
        EffectUtils.Create(
                Reg.EffectID("fire_flame"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(0.2),
                Utils.RandSym(0.2),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 0.25)
        )
    end

    local chasing = false
    if projectile.isCheckNpc then
        local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 128)
        if npcTarget ~= nil then
            projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 0.63,
                    projectile:GetAngleTo(npcTarget.centerX, npcTarget.centerY), projectile.maxSpeed)
            chasing = true
        end
    end

    projectile.speedX = projectile.speedX + Utils.RandSym(0.52)
    projectile.speedY = projectile.speedY + Utils.RandSym(0.52)
end

function MiniRocket:OnKilled()
    local projectile = self.projectile
    --MiscUtils.CreateExplosion(projectile.centerXi, projectile.centerYi, 11, projectile.isCheckNpc, projectile.isCheckPlayer)
    --EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)


    local explosionEffect = EffectUtils.Create(
            Reg.EffectID("explosion"),
            projectile.centerX,
            projectile.centerY,
            0,
            0,
            0,
            1,
            1.0,
            Color.new(255, 255, 200)
    )
end

function MiniRocket:OnHitNpc(_, _)
    self.projectile:Kill()
end

function MiniRocket:OnHitPlayer(_, _)
    self.projectile:Kill()
end

function MiniRocket:OnTileCollide(_, _)
    self.projectile:Kill()
end

return MiniRocket