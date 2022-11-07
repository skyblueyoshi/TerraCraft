---@class TC.EnchantmentProjectileProtection:TC.BaseEnchantmentProxy
local EnchantmentProjectileProtection = class("EnchantmentProjectileProtection")

function EnchantmentProjectileProtection.OnEquipped(equipmentIndex, level, player, _)
	player.baseDefense.projectileDefense = player.baseDefense.projectileDefense + level
end

return EnchantmentProjectileProtection