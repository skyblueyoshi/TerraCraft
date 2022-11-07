---@class TC.EnchantmentProtection:TC.BaseEnchantmentProxy
local EnchantmentProtection = class("EnchantmentProtection")

function EnchantmentProtection.OnEquipped(equipmentIndex, level, player, _)
	player.baseDefense.defense = player.baseDefense.defense + level
end

return EnchantmentProtection