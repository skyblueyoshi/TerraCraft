---@class TC.EnchantmentFireProtection:TC.BaseEnchantmentProxy
local EnchantmentFireProtection = class("EnchantmentFireProtection")

function EnchantmentFireProtection.OnEquipped(equipmentIndex, level, player, _)
    player.baseDefense.flameDefense = player.baseDefense.flameDefense + level
end

return EnchantmentFireProtection