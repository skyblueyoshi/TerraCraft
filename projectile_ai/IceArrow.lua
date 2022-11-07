---@type ModProjectile
local IceArrow = class("Grenade", require("Arrow"))

function IceArrow:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.modData.flameLevel == 0 then
        if projectile.tickTime % 2 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("arrow_paticular"),
                    projectile.hots[1].x,
                    projectile.hots[1].y,
                    Utils.RandSym(2),
                    Utils.RandSym(2),
                    Utils.RandSym(0.25),
                    0,
                    0,
                    Color.new(0, 200, 255)
            )
        end
    end
end

function IceArrow:OnKilled()
    local projectile = self.projectile
    local flash2 = Reg.EffectID("flash2")
    for _ = 1, 8 do
        EffectUtils.Create(
                flash2,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(4),
                Utils.RandSym(4)
        )
    end
    SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
end

function IceArrow:OnHitNpc(_, _)
    local projectile = self.projectile
    if projectile.modData.piercingCount > 0 then
        projectile.modData.piercingCount = projectile.modData.piercingCount - 1
    else
        projectile:Kill()
    end
end

function IceArrow:OnHitPlayer(_, _)
    self.projectile:Kill()
end

---OnTileCollide
---@param oldSpeedX double
---@param oldSpeedY double
function IceArrow:OnTileCollide(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    if not projectile.modData.bounceOnce then
        if projectile.stand or projectile.isCollisionTop then
            projectile.speedY = -oldSpeedY / 2
            projectile.speedX = oldSpeedX / 2
        elseif projectile.isCollisionLeft or projectile.isCollisionRight then
            projectile.speedX = -oldSpeedX / 2
        end
        projectile.modData.bounceOnce = true
        SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
    else
        if projectile.modData.attachItemID > 0 then
            ItemUtils.CreateDrop(projectile.modData.attachItemID, 1, projectile.centerX, projectile.centerY,
                    -1.5 * math.cos(projectile.rotateAngle), -4 * math.sin(projectile.rotateAngle))
        end
        projectile:Kill()
    end
end

return IceArrow