---@class TC.EnchantmentAquaAffinity:TC.BaseEnchantmentProxy
local EnchantmentAquaAffinity = class("EnchantmentAquaAffinity")

function EnchantmentAquaAffinity.OnEquipped(equipmentIndex, level, player, _)
    if player.inLiquid then
		player.digSpeedRate = player.digSpeedRate + level * 0.1
	end
end

return EnchantmentAquaAffinity