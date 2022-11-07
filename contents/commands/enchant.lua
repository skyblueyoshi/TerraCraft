function RunCommand(myPlayer, enchantmentID, enchantmentLevel)
    local heldItemSlot = myPlayer:GetHeldItemSlot()
    local ok = false
    if heldItemSlot.hasItem then
        ok = heldItemSlot:AddEnchantment(enchantmentID, enchantmentLevel)
    end
    if ok then
        MiscUtils.UnicastUTF8(myPlayer,
            string.format(LangUtils.ModText("em_ok"), myPlayer.name, LangUtils.ItemName(heldItemSlot.id),
                LangUtils.EnchantmentName(enchantmentID), enchantmentLevel))
    else
        MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("em_fail")))
    end
end
