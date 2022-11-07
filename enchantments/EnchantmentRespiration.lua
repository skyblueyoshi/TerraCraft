---@class TC.EnchantmentRespiration:TC.BaseEnchantmentProxy
local EnchantmentRespiration = class("EnchantmentRespiration")

function EnchantmentRespiration.OnEquipped(equipmentIndex, level, player, _)
	player.baseDefense.breathDefense = player.baseDefense.breathDefense + level
end

return EnchantmentRespiration