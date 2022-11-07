---@class TC.Gun:TC.BaseRangedWeapon
local Gun = class("Gun", require("BaseRangedWeapon"))

function Gun:IsCheckingConsume(player)
    return true
end

function Gun:NeedAttachItemToProjectile(player)
    return true
end

--local e_fire_smoke = Reg.EffectID("fire_smoke")
--local e_liquid_paticular = Reg.EffectID("liquid_paticular")
--
--function Gun:CheckShoot(itemSlot, hitbox, consumeItemID, projectileID, fireX, fireY, shootSpeed, shootAngle, baseAttack)
--    -- Add some gunpowder effect.
--
--    local special = itemSlot.special
--    if special == 1 then -- Shoot from a normal gun.
--        local effect = EffectUtils.Create(e_fire_smoke, fireX, fireY, math.cos(shootAngle) * 0.5 + Utils.RandSym(0.25),
--                           math.cos(shootAngle) * 0.5 + Utils.RandSym(0.25), Utils.RandSym(0.1),
--                           Utils.RandDoubleArea(1.5, 0.5), 0.5)
--        effect.color = Color.new(200,200,200)
--        for i = 1, 3 do
--            local effect2 = EffectUtils.Create(e_liquid_paticular, fireX, fireY,
--                                math.cos(shootAngle) * 1.0 + Utils.RandSym(0.25),
--                                math.cos(shootAngle) * 1.0 - Utils.RandDouble(0.5), Utils.RandSym(0.1), 0.5)
--            effect2.color = Color.Yellow
--        end
--    elseif special == 2 then -- Shoot from a fire gun.
--        local effect = EffectUtils.Create(e_liquid_paticular, fireX, fireY,
--                           math.cos(shootAngle) * 0.2 + Utils.RandSym(0.25), -Utils.RandDouble(0.75),
--                           Utils.RandSym(0.1), Utils.RandDoubleArea(0.5, 1.0), 0.5)
--        effect.color = Color.new(255,180,0)
--    elseif special == 3 then -- Shoot from a laser gun.
--        for i = 1, 3 do
--            EffectUtils.Create(e_liquid_paticular, fireX, fireY, math.cos(shootAngle) * 0.2 + Utils.RandSym(0.25),
--                -Utils.RandDouble(0.75), Utils.RandSym(0.1), Utils.RandDoubleArea(0.5, 1.0), 0.5)
--        end
--    end
--
--    return true
--end

return Gun