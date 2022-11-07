---@class TC.BaseEnchantmentProxy
local BaseEnchantmentProxy = class("BaseEnchantmentProxy")

---OnHeld
---@param level int
---@param player Player
---@param itemStack ItemStack
function BaseEnchantmentProxy.OnHeld(level, player, itemStack)
end

---OnUpdateSecond
---@param level int
---@param player Player
---@param itemStack ItemStack
function BaseEnchantmentProxy.OnUpdateSecond(level, player, itemStack)
end

---OnEquipped
---@param equipmentIndex int
---@param level int
---@param player Player
---@param itemStack ItemStack
function BaseEnchantmentProxy.OnEquipped(equipmentIndex, level, player, itemStack)
end

---OnEquippedHitByNpc
---@param equipmentIndex int
---@param level int
---@param player Player
---@param itemStack ItemStack
---@param npc Npc
function BaseEnchantmentProxy.OnEquippedHitByNpc(equipmentIndex, level, player, itemStack, npc)
end

---OnEquippedHitByProjectile
---@param equipmentIndex int
---@param level int
---@param player Player
---@param itemStack ItemStack
---@param projectile Projectile
function BaseEnchantmentProxy.OnEquippedHitByProjectile(equipmentIndex, level, player, itemStack, projectile)
end

return BaseEnchantmentProxy