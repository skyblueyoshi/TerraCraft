---@type ModProjectile
local IceMagic = class("IceMagic", ModProjectile)

function IceMagic:Update()
    local projectile = self.projectile
    projectile.speedY = projectile.speedY + 0.2
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(3),
                projectile.speedY / 4 + Utils.RandSym(3),
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(1, 0.25),
                1.0,
                Color.new(240, 160, 255)
        )
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 24, 0, 0, 16)
end

function IceMagic:OnKilled()
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
                2.0,
                1.0,
                Color.new(240, 160, 255)
        )
    end
end

function IceMagic:OnHitNpc(_, _)
    local projectile = self.projectile
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("glass"), projectile.centerXi, projectile.centerYi)
    projectile:Kill()
end

function IceMagic:OnHitPlayer(_, _)
    local projectile = self.projectile
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("glass"), projectile.centerXi, projectile.centerYi)
    projectile:Kill()
end

function IceMagic:OnTileCollide(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    if projectile.modData.bounceTimes >= 4 then
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
                    Color.new(240, 160, 255)
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

return IceMagic