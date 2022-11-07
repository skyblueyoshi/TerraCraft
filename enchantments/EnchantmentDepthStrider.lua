---@class TC.EnchantmentDepthStrider:TC.BaseEnchantmentProxy
local EnchantmentDepthStrider = class("EnchantmentDepthStrider")

function EnchantmentDepthStrider.OnEquipped(equipmentIndex, level, player, _)
    if player.inLiquid then
		player.speedRate = player.speedRate + level * 0.2
	end
end

return EnchantmentDepthStrider