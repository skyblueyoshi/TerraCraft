local Sword = class("Sword", ModItem)

--function Sword:CheckHitNpc(itemSlot, npcTarget, hitbox, fireX, fireY, hitAngle, baseAttack)
--    -- check enchantments
--    local arthropodsLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("bane_of_arthropods"))
--    local fireAspectLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("fire_aspect"))
--    local smiteLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("smite"))
--
--    if fireAspectLevel > 0 then
--        npcTarget:AddBuff(Reg.BuffID("fire"), fireAspectLevel * 60)
--    end
--    if arthropodsLevel > 0 and npcTarget.type == NPC_TYPE_ARTHROPODS then
--        baseAttack.attack = baseAttack.attack + arthropodsLevel * 2
--    end
--    if smiteLevel > 0 and npcTarget.type == NPC_TYPE_SMITE then
--        baseAttack.attack = baseAttack.attack + smiteLevel * 2
--    end
--
--    return true
--end
--
--function Sword:CheckHitPlayer(itemSlot, playerTarget, hitbox, fireX, fireY, hitAngle, baseAttack)
--    -- check enchantments
--    local fireAspectLevel = itemSlot:GetEnchantmentLevel(Reg.EnchantmentID("fire_aspect"))
--    if fireAspectLevel > 0 then
--        playerTarget:AddBuff(Reg.BuffID("fire"), fireAspectLevel * 60)
--    end
--    return true
--end

return Sword