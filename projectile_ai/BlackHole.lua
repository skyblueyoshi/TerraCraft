---@class TC.BlackHole:ModProjectile
local BlackHole = class("BlackHole", ModProjectile)

function BlackHole:Update()
    local projectile = self.projectile

    local angle = projectile.speedAngle
    local speed = Vector2.new(projectile.speedX, projectile.speedY).length

    if speed < 0.2 then
        projectile:Kill()
        return
    end

    speed = speed * 0.98
    projectile.speedX = speed * math.cos(angle)
    projectile.speedY = speed * math.sin(angle)

    if projectile.isCheckNpc then
        local npcTarget = NpcUtils.SearchNearestEnemy(projectile.centerX, projectile.centerY, 128)
        if npcTarget ~= nil then
            npcTarget.speedX, npcTarget.speedY = Utils.ForceSpeed2D(npcTarget.speedX, npcTarget.speedY, 0.5,
                    npcTarget:GetAngleTo(projectile.centerX, projectile.centerY), 4.0)
            if npcTarget.stand then
                npcTarget.speedY = -6
            end
        end
    end
    if projectile.tickTime % 1 == 0 then

        local effectAngle = Utils.RandSym(math.pi)
        local d = 96
        local effectX = projectile.centerX + math.cos(effectAngle) * d
        local effectY = projectile.centerY + math.sin(effectAngle) * d

        local effectSpeed = 6
        local effectSpeedAngle = Utils.FixAngle(effectAngle + math.pi)
        local spx = projectile.speedX + math.cos(effectSpeedAngle) * effectSpeed
        local spy = projectile.speedY + math.sin(effectSpeedAngle) * effectSpeed

        local colorChannel = Utils.RandIntArea(64, 140)

        EffectUtils.Create(
                Reg.EffectID("flash2"),
                effectX,
                effectY,
                spx,
                spy,
                Utils.RandSym(0.5),
                Utils.RandDoubleArea(0.5,0.7),
                1,
                Color.new(colorChannel, colorChannel, colorChannel)
        )
    end

    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 30)

end

function BlackHole:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 12 do
        local colorChannel = Utils.RandIntArea(100, 140)
        EffectUtils.Create(flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(6),
                Utils.RandSym(6),
                0,
                Utils.RandDoubleArea(1, 1),
                1.0,
                Color.new(colorChannel, colorChannel, colorChannel)
        )
    end
end

function BlackHole:OnHitNpc(npc, hitAttack)
    --self.projectile:Kill()
end

function BlackHole:OnHitPlayer(player, hitAttack)
    --self.projectile:Kill()
end

function BlackHole:OnTileCollide(oldSpeedX, oldSpeedY)
    --self.projectile:Kill()
end

return BlackHole