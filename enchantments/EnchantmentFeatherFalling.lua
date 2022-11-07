---@class TC.EnchantmentFeatherFalling:TC.BaseEnchantmentProxy
local EnchantmentFeatherFalling = class("EnchantmentFeatherFalling")

function EnchantmentFeatherFalling.OnEquipped(equipmentIndex, level, player, _)
    player.baseDefense.fallDefense = player.baseDefense.fallDefense + level
end

return EnchantmentFeatherFalling