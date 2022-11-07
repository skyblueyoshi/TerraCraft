---@class TC.EnchantmentSharpness:TC.BaseEnchantmentProxy
local EnchantmentSharpness = class("EnchantmentSharpness")

function EnchantmentSharpness.OnHeld(level, player, _)
    player.baseAttack.attack = player.baseAttack.attack + level
end

return EnchantmentSharpness