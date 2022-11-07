---@class TC.EnchantmentBlastProtection:TC.BaseEnchantmentProxy
local EnchantmentBlastProtection = class("EnchantmentBlastProtection")

function EnchantmentBlastProtection.OnEquipped(equipmentIndex, level, player, _)
    player.baseDefense.blastDefense = player.baseDefense.blastDefense + level
end

return EnchantmentBlastProtection