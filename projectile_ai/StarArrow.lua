---@type ModProjectile
local StarArrow = class("StarArrow", require("Arrow"))

function StarArrow:CheckFallStarArrow()
    local projectile = self.projectile
    if projectile.modData.attachItemID > 0 then
        local height = 256
        local width = 1024
        local offsetX = 0
        if projectile.speedX < 0 then
            offsetX = Utils.RandInt(256)
        else
            offsetX = width - Utils.RandInt(256)
        end
        local shootX = projectile.centerX - width / 2 + offsetX
        local shootY = projectile.centerY - height
        local angle = projectile:GetAngleFrom(shootX, shootY)
        local speed = 10
        local proj = ProjectileUtils.Create(
                projectile.id,
                shootX,
                shootY,
                speed * math.cos(angle),
                speed * math.sin(angle),
                projectile.baseAttack
        )
        proj.isCheckPlayer = projectile.isCheckPlayer
        proj.isCheckNpc = projectile.isCheckNpc
        local star = Reg.EffectID("star")
        for _ = 1, 12 do
            EffectUtils.Create(
                    star,
                    shootX,
                    shootY,
                    Utils.RandSym(4),
                    Utils.RandSym(4),
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(1, 0.5),
                    0,
                    Color.Yellow
            )
        end
    end
end

function StarArrow:Update()
    local projectile = self.projectile
    projectile.rotateAngle = projectile.speedAngle
    if projectile.tickTime % 8 == 0 then
        EffectUtils.Create(
                Reg.EffectID("star"),
                projectile.hots[1].x,
                projectile.hots[1].y,
                projectile.speedX / 4 + Utils.RandSym(2),
                projectile.speedY / 4 + Utils.RandSym(2),
                Utils.RandSym(0.25),
                0,
                0,
                Color.Yellow
        )
    end
    LightingUtils.AddDelay(projectile.centerXi, projectile.centerYi, 32, 32)
end

function StarArrow:OnKilled()
    local projectile = self.projectile
    local flame_star = Reg.EffectID("flame_star")
    for _ = 1, 8 do
        EffectUtils.Create(
                flame_star,
                projectile.centerX,
                projectile.centerY,
                Utils.RandSym(2),
                Utils.RandDoubleArea(-2, 3),
                Utils.RandSym(1),
                Utils.RandDoubleArea(1, 0.5),
                0,
                Color.new(200,200,200)
        )
    end
    EffectUtils.Create(
            Reg.EffectID("star"),
            projectile.centerX,
            projectile.centerY,
            -projectile.speedX / 4 + Utils.RandSym(2),
            -projectile.speedY / 4 + Utils.RandSym(2),
            Utils.RandSym(0.25),
            Utils.RandDoubleArea(1, 0.5),
            0,
            Color.Yellow
    )
    SoundUtils.PlaySound(Reg.SoundID("bowhit"), projectile.centerXi, projectile.centerYi)
end

function StarArrow:OnHitNpc(_, _)
    self:CheckFallStarArrow()
    self.projectile:Kill()
end

function StarArrow:OnHitPlayer(_, _)
    self:CheckFallStarArrow()
    self.projectile:Kill()
end

function StarArrow:OnTileCollide(_, _)
    local projectile = self.projectile
    if projectile.modData.attachItemID > 0 then
        ItemUtils.CreateDrop(projectile.modData.attachItemID, 1, projectile.centerX, projectile.centerY,
                -1.5 * math.cos(projectile.rotateAngle), -4 * math.sin(projectile.rotateAngle))
    end
    self:CheckFallStarArrow()
    projectile:Kill()
end

return StarArrow