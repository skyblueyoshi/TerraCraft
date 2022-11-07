---@class TC.EnchantmentPhyton:TC.BaseEnchantmentProxy
local EnchantmentPhyton = class("EnchantmentProtection")

function EnchantmentPhyton.OnUpdateSecond(level, player, itemStack)
	itemStack:AddDurable(level * 2)
end

return EnchantmentPhyton