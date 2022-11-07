---@class TC.WaterFlow:ModProjectile
local WaterFlow = class("WaterFlow", ModProjectile)

function WaterFlow:TouchEffect()
    local projectile = self.projectile
    for _ = 1, 4 do
        EffectUtils.Create(
                Reg.EffectID("liquid_paticular"),
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(1),
                Utils.RandSym(1) - 2,
                0,
                Utils.RandDoubleArea(1, 1),
                Utils.RandDoubleArea(1.5, 1.5),
                Color.new(30, 80, 255)
        )
    end
end

function WaterFlow:Update()
    local projectile = self.projectile
    projectile.color = Color.new(0, 0, 0, 0)
    projectile.gravity = 0

    if projectile.tickTime == 0 then
        for _ = 1, 2 do
            local effect = EffectUtils.Create(
                    Reg.EffectID("liquid_paticular"),
                    projectile.centerX,
                    projectile.centerY,
                    projectile.speedX / 12 + Utils.RandSym(1),
                    projectile.speedY / 12 + Utils.RandSym(1),
                    0,
                    Utils.RandDoubleArea(1.0, 1.5),
                    1.0,
                    Color.new(30, 80, 255)
            )
            effect.gravity = false
        end
    end

    local effect = EffectUtils.Create(
            Reg.EffectID("liquid_paticular"),
            projectile.hots[1].x,
            projectile.hots[1].y,
            projectile.speedX / 4 + Utils.RandSym(0.25),
            projectile.speedY / 4 + Utils.RandSym(0.25),
            Utils.RandSym(1),
            Utils.RandDoubleArea(1.0, 1.5),
            1.0,
            Color.new(30, 80, 255)
    )
    effect.gravity = false
    effect:SetDisappearTime(50)

    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 32)
    if projectile.tickTime > 160 then
        projectile:Kill()
    end
end

function WaterFlow:OnHitNpc(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function WaterFlow:OnHitPlayer(_, _)
    self:TouchEffect()
    self.projectile:Kill()
end

function WaterFlow:OnTileCollide(_, _)
    self:TouchEffect()

    local projectile = self.projectile
    if projectile.stand then
        projectile.speedY = -math.abs(projectile.speedY)
    elseif projectile.isCollisionTop then
        projectile.speedY = math.abs(projectile.speedY)
    end
    if projectile.isCollisionLeft then
        projectile.speedX = math.abs(projectile.speedX)
    elseif projectile.isCollisionRight then
        projectile.speedX = -math.abs(projectile.speedX)
    end
end

return WaterFlow