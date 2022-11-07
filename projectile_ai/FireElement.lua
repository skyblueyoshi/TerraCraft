---@type ModProjectile
local FireElement = class("FireElement", ModProjectile)

function FireElement:Update()
    local projectile = self.projectile
    projectile.speedY = projectile.speedY + 0.1
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 2 == 0 then
        local effect = EffectUtils.Create(
                Reg.EffectID("fire_flame"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(1),
                projectile.speedY / 4 + Utils.RandSym(1),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(0.5, 0.55),
                1.0
        )
        effect:SetDisappearTime(30)
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 0, 0, 16)
end

function FireElement:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("fire_flame")
    for _ = 1, 8 do
        EffectUtils.Create(
                flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(2),
                Utils.RandSym(2),
                0,
                1.0,
                1.0
        )
    end
end

function FireElement:OnHitNpc(_, _)
    local projectile = self.projectile
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("glass"), projectile.centerXi, projectile.centerYi)
    projectile:Kill()
end

function FireElement:OnHitPlayer(_, _)
    local projectile = self.projectile
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("glass"), projectile.centerXi, projectile.centerYi)
    projectile:Kill()
end

function FireElement:OnTileCollide(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    if projectile.modData.bounceTimes >= 2 then
        projectile:Kill()
    else
        local star = Reg.EffectID("star")
        for _ = 1, 3 do
            EffectUtils.Create(
                    star,
                    projectile.centerX,
                    projectile.centerY,
                    Utils.RandSym(2),
                    Utils.RandSym(2),
                    0,
                    1.0,
                    1.0,
                    Color.new(255, 220, 0)
            )
        end
    end
    if projectile.stand or projectile.isCollisionTop then
        projectile.speedY = -oldSpeedY * 0.8
    elseif projectile.isCollisionLeft or projectile.isCollisionRight then
        projectile.speedX = -oldSpeedX * 0.8
    end
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("glass"), projectile.centerXi, projectile.centerYi)
    projectile.modData.bounceTimes = projectile.modData.bounceTimes + 1
end

return FireElement