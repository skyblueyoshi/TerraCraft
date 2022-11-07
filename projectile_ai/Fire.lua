---@type ModProjectile
local Fire = class("Fire", ModProjectile)

function Fire:GetFireScale()
    local projectile = self.projectile
    local scale = 1.0
    if projectile.tickTime < 30 then
        scale = 0.25 + 1.75 * projectile.tickTime / 30
    elseif projectile.tickTime < 60 then
        scale = 2 - (projectile.tickTime - 30) / 10
    end
    scale = scale * 1.25
    return scale
end

function Fire:Update()
    local projectile = self.projectile
    projectile.speedX, projectile.speedY = Utils.SlowSpeed2D(projectile.speedX, projectile.speedY, 0.14)
    projectile:Rotate(0.2)
    local scale = self:GetFireScale()
    if scale <= 0 or scale >= 60 then
        projectile:Kill()
    else
        local lighting = math.floor((1 - projectile.tickTime / 60) * 32)
        LightingUtils.Add(projectile.centerXi, projectile.centerYi, lighting, 8, 6, 0)
        if Utils.RandTry(32) then
            EffectUtils.Create(
                    Reg.EffectID("liquid_paticular"),
                    projectile.centerX,
                    projectile.centerY,
                    projectile.speedX / 2 + Utils.RandSym(0.25),
                    projectile.speedY - Utils.RandDouble(0.75),
                    Utils.RandSym(0.05),
                    0.5,
                    0,
                    Color.new(255, 128, 0)
            )
        end
    end
end

function Fire:OnDraw()
    local projectile = self.projectile
    projectile.color = Color.new(255, 255, 255, math.floor((1 - projectile.tickTime / 60) * 255))
    local scale = math.max(self:GetFireScale(), 0.1)
    projectile.spriteEx.angle = projectile.rotateAngle
    projectile.spriteEx.scaleRateX = scale
    projectile.spriteEx.scaleRateY = scale
    projectile.spriteOffsetX = math.floor((1 - projectile.spriteEx.scaleRateX) * projectile.spriteDefaultWidth / 2);
    projectile.spriteOffsetY = math.floor((1 - projectile.spriteEx.scaleRateY) * projectile.spriteDefaultHeight / 2);
end

---OnHitNpc
---@param npc Npc
---@param _ Attack
function Fire:OnHitNpc(npc, _)
    npc:AddBuff(Reg.BuffID("fire"), 100)
end

---OnHitPlayer
---@param player Player
---@param _ Attack
function Fire:OnHitPlayer(player, _)
    player:AddBuff(Reg.BuffID("fire"), 100)
end

function Fire:OnTileCollide(oldSpeedX, oldSpeedY)
    local projectile = self.projectile
    for _ = 1, 4 do
        local effect = EffectUtils.Create(
                Reg.EffectID("liquid_paticular"),
                projectile.centerX,
                projectile.centerY,
                -oldSpeedX / 4 + Utils.RandSym(1),
                -oldSpeedY / 4 - Utils.RandDouble(2),
                Utils.RandSym(0.05),
                0.5,
                0,
                Color.new(255, 128, 0)
        )
    end
    projectile:Kill()
end

return Fire