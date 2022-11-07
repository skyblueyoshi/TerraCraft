---@type ModProjectile
local ShulkerBullet = class("ShulkerBullet", ModProjectile)

function ShulkerBullet:Update()
    local projectile = self.projectile
    if projectile.isCheckPlayer then
        local playerTarget = PlayerUtils.SearchNearestPlayer(projectile.centerX, projectile.centerY, 360)
        if playerTarget ~= nil then
            projectile.speedX, projectile.speedY = Utils.ForceSpeed2D(projectile.speedX, projectile.speedY, 0.3,
                    projectile:GetAngleTo(playerTarget.centerX, playerTarget.centerY), projectile.maxSpeed)
        end
    end
    projectile:Rotate(0.1)
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("laser_flash"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                Utils.RandSym(1),
                Utils.RandSym(1),
                Utils.RandSym(0.1)
        )
    end
    if projectile.tickTime > 200 then
        projectile:Kill()
    end
end

function ShulkerBullet:OnKilled()
    local projectile = self.projectile
    local laser_flash = Reg.EffectID("laser_flash")
    for i = 0, 15 do
        local angle = i * math.pi * 2 / 16
        EffectUtils.Create(
                laser_flash,
                projectile.hots[1].x,
                projectile.hots[1].y,
                math.cos(angle) * 2,
                math.sin(angle) * 2,
                Utils.RandSym(0.1),
                2
        )
    end
end

function ShulkerBullet:OnHitPlayer(player, _)
    player:AddBuff(Reg.BuffID("levitation"), 120)
    self.projectile:Kill()
end

function ShulkerBullet:OnTileCollide(_, _)
    self.projectile:Kill()
end

return ShulkerBullet