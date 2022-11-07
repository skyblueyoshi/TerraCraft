---@type ModProjectile
local AirBullet = class("AirBullet", ModProjectile)

---@param oldSpeedX double
---@param oldSpeedY double
function AirBullet:TileBounce(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    if projectile.stand or projectile.isCollisionTop then
        projectile.speedY = -oldSpeedY
    elseif projectile.isCollisionLeft or projectile.isCollisionRight then
        projectile.speedX = -oldSpeedX
    end
    projectile.modData.bounceTimes = projectile.modData.bounceTimes + 1
end

function AirBullet:TouchBounce()
    local projectile = self.projectile
    local angle = projectile.speedAngle
    angle = angle + math.pi + Utils.RandSym(0.2)
    local speed = Utils.GetDistance(projectile.speedX, projectile.speedY)
    projectile.speedX = speed * math.cos(angle)
    projectile.speedY = speed * math.sin(angle)
    projectile.modData.bounceTimes = projectile.modData.bounceTimes + 1
end

function AirBullet:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 4 == 0 then
        EffectUtils.Create(
                Reg.EffectID("chip"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(0.5),
                projectile.speedY / 4 - Utils.RandDouble(2),
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 0.5),
                0,
                Color.new(200, 200, 255)
        )
    end
    if projectile.tickTime % 8 == 0 then
        EffectUtils.Create(
                Reg.EffectID("flash2"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(0.5),
                projectile.speedY / 4 - Utils.RandDouble(2),
                0,
                Utils.RandDoubleArea(1, 0.5),
                0,
                Color.new(200, 200, 255)
        )
    end

end

function AirBullet:OnKilled()
    local projectile = self.projectile
    local chipId = Reg.EffectID("chip")
    for _ = 1, 8 do
        EffectUtils.Create(
                chipId, projectile.centerX, projectile.centerY,
                -projectile.speedX / 4 + Utils.RandSym(2),
                -projectile.speedY / 4 - Utils.RandDouble(3),
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 0.5)
        )
    end
end

function AirBullet:OnHitNpc(_, _)
    if self.projectile.modData.bounceTimes > 1 then
        self.projectile:Kill()
    else
        self:TouchBounce()
    end
end

function AirBullet:OnHitPlayer(_, _)
    if self.projectile.modData.bounceTimes > 1 then
        self.projectile:Kill()
    else
        self:TouchBounce()
    end
end

---OnTileCollide
---@param oldSpeedX double
---@param oldSpeedY double
function AirBullet:OnTileCollide(oldSpeedX, oldSpeedY)
    if self.projectile.modData.bounceTimes > 4 then
        self.projectile:Kill()
    else
        self:TileBounce(oldSpeedX, oldSpeedY)
    end
end

return AirBullet