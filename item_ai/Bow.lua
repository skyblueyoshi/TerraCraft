---@class Bow:TC.BaseRangedWeapon
local Bow = class("Bow", require("BaseRangedWeapon"))

function Bow:IsCheckingConsume(player)
    return true
end

function Bow:NeedAttachItemToProjectile(player)
    return true
end

--function Bow:CheckShoot(itemSlot, hitbox, consumeItemID, projectileID, fireX, fireY, shootSpeed, shootAngle, baseAttack)
--    -- check enchantments
--    baseAttack.attack = baseAttack.attack + itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("power"))
--    baseAttack.knockBack = baseAttack.knockBack + itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("punch"))
--    return true
--end
--
--function Bow:OnShootFromPlayer(itemSlot, player, hitbox, consumeItemID, projectileID, fireX, fireY, shootSpeed, shootAngle,
--    baseAttack)
--    local flameLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("flame"))
--    local shootTimes = itemSlot.shootTimes
--    for i = 1, shootTimes do
--        local angle = shootAngle + Utils.RandSym(itemSlot.deviation)
--        local speed = shootSpeed
--        local proj = ProjectileUtils.CreateFromPlayer(player, projectileID, fireX, fireY, math.cos(angle) * speed,
--                         math.sin(angle) * speed, baseAttack)
--        proj.isCheckPlayer = true
--        proj.isCheckNpc = true
--        if proj.modData:DataOf("Arrow") then
--            if i == 1 and consumeItemID > 0 then
--                proj.modData.attachItemID = consumeItemID
--            end
--            proj.modData.flameLevel = flameLevel
--        end
--    end
--    return true
--end
--
--function Bow:OnShootFromNpc(itemSlot, npc, hitbox, consumeItemID, projectileID, fireX, fireY, shootSpeed, shootAngle,
--    baseAttack)
--    local flameLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("flame"))
--    local shootTimes = itemSlot.shootTimes
--    for i = 1, shootTimes do
--        local angle = shootAngle + Utils.RandSym(itemSlot.deviation)
--        local speed = shootSpeed
--        local proj = ProjectileUtils.CreateFromNpc(npc, projectileID, fireX, fireY, math.cos(angle) * speed,
--                         math.sin(angle) * speed, baseAttack)
--        proj.isCheckPlayer = true
--        proj.isCheckNpc = false
--        if proj.modData:DataOf("Arrow") then
--            if i == 1 and consumeItemID > 0 then
--                proj.modData.attachItemID = consumeItemID
--            end
--            proj.modData.flameLevel = flameLevel
--        end
--    end
--    return true
--end
--
--function Bow:CheckConsumeItem(itemSlot, player, projectileID)
--    local infinityLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("infinity"))
--    -- Has unlimited enchantments, so no items are consumed
--    if infinityLevel > 0 then
--        return false
--    end
--    return true
--end

return Bow