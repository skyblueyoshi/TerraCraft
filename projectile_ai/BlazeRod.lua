---@type ModProjectile
local BlazeRod = class("BlazeRod", ModProjectile)

function BlazeRod:Update()
    local projectile = self.projectile
    local ownerNpc = NpcUtils.Get(projectile.npcOwnerIndex)
    if ownerNpc ~= nil then
        local angle = projectile.modData.beginDir * math.pi / 2 + projectile.tickTime / 32
        local d = Utils.SinValue(projectile.tickTime, 128) * 8 + 56
        projectile.x = ownerNpc.centerX + math.cos(angle) * d - projectile.width / 2
        projectile.y = ownerNpc.centerY + math.sin(angle) * d - projectile.height / 2
        projectile.rotateAngle = angle + math.pi / 2
        if projectile.tickTime % 8 == 0 then
            EffectUtils.Create(
                    Reg.EffectID("fire_flame"),
                    projectile.centerX,
                    projectile.centerY,
                    0,
                    0,
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(0.5, 0.5),
                    1
            )
        end
    else
        projectile:Kill()
    end
end

return BlazeRod