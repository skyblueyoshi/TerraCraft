---@class TC.EnchantmentKnockBack:TC.BaseEnchantmentProxy
local EnchantmentKnockBack = class("EnchantmentKnockBack")

function EnchantmentKnockBack.OnHeld(level, player, _)
    player.baseAttack.knockBack = player.baseAttack.knockBack + level
end

return EnchantmentKnockBack