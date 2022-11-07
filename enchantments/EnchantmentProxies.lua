---@class TC.EnchantmentProxies
local EnchantmentProxies = class("EnchantmentProxies")

local s_instance
---@return TC.EnchantmentProxies
function EnchantmentProxies.getInstance()
    if s_instance == nil then
        s_instance = EnchantmentProxies.new()
    end
    return s_instance
end

function EnchantmentProxies:__init()
    ---@type TC.BaseEnchantmentProxy[]
    self._proxies = {}
end

---OnHeld
---@param itemStack ItemStack
---@param player Player
function EnchantmentProxies:OnHeld(itemStack, player)
    if not itemStack:HasEnchantment() then
        return
    end
    for index = 0, itemStack.enchantmentCount - 1 do
        local enchantment = itemStack:GetEnchantmentByIndex(index)
        local proxy = self._proxies[enchantment.id]
        if proxy and proxy.OnHeld ~= nil then
            proxy.OnHeld(enchantment.level, player, itemStack)
        end
    end
end


---OnUpdateSecond
---@param itemStack ItemStack
---@param player Player
function EnchantmentProxies:OnUpdateSecond(itemStack, player)
    if not itemStack:HasEnchantment() then
        return
    end
    for index = 0, itemStack.enchantmentCount - 1 do
        local enchantment = itemStack:GetEnchantmentByIndex(index)
        local proxy = self._proxies[enchantment.id]
        if proxy and proxy.OnUpdateSecond ~= nil then
            proxy.OnUpdateSecond(enchantment.level, player, itemStack)
        end
    end
end

---@param equipmentIndex int
---@param itemStack ItemStack
---@param player Player
function EnchantmentProxies:OnEquipped(equipmentIndex, itemStack, player)
    if not itemStack:HasEnchantment() then
        return
    end
    for index = 0, itemStack.enchantmentCount - 1 do
        local enchantment = itemStack:GetEnchantmentByIndex(index)
        local proxy = self._proxies[enchantment.id]
        if proxy and proxy.OnEquipped ~= nil then
            proxy.OnEquipped(equipmentIndex, enchantment.level, player, itemStack)
        end
    end
end

---@param equipmentIndex int
---@param itemStack ItemStack
---@param player Player
---@param npc Npc
function EnchantmentProxies:OnEquippedHitByNpc(equipmentIndex, itemStack, player, npc)
    if not itemStack:HasEnchantment() then
        return
    end
    for index = 0, itemStack.enchantmentCount - 1 do
        local enchantment = itemStack:GetEnchantmentByIndex(index)
        local proxy = self._proxies[enchantment.id]
        if proxy and proxy.OnEquippedHitByNpc ~= nil then
            proxy.OnEquippedHitByNpc(equipmentIndex, enchantment.level, player, itemStack, npc)
        end
    end
end

---@param equipmentIndex int
---@param itemStack ItemStack
---@param player Player
---@param projectile Projectile
function EnchantmentProxies:OnEquippedHitByProjectile(equipmentIndex, itemStack, player, projectile)
    if not itemStack:HasEnchantment() then
        return
    end
    for index = 0, itemStack.enchantmentCount - 1 do
        local enchantment = itemStack:GetEnchantmentByIndex(index)
        local proxy = self._proxies[enchantment.id]
        if proxy and proxy.OnEquippedHitByProjectile ~= nil then
            proxy.OnEquippedHitByProjectile(equipmentIndex, enchantment.level, player, itemStack, projectile)
        end
    end
end

function EnchantmentProxies:Register(idName, proxy)
    local id = Reg.EnchantmentID(idName)
    self._proxies[id] = proxy
end

function EnchantmentProxies:RegisterAll()
    self:Register("tc:knockback", require("EnchantmentKnockBack"))
    self:Register("tc:sharpness", require("EnchantmentSharpness"))
    self:Register("tc:blast_protection", require("EnchantmentBlastProtection"))
    self:Register("tc:aqua_affinity", require("EnchantmentAquaAffinity"))
    self:Register("tc:depth_strider", require("EnchantmentDepthStrider"))
    self:Register("tc:feather_falling", require("EnchantmentFeatherFalling"))
    self:Register("tc:fire_protection", require("EnchantmentFireProtection"))
    self:Register("tc:projectile_protection", require("EnchantmentProjectileProtection"))
    self:Register("tc:protection", require("EnchantmentProtection"))
    self:Register("tc:respiration", require("EnchantmentRespiration"))
    self:Register("tc:frost_walker", require("EnchantmentFrostWalker"))
    self:Register("tc:thorns", require("EnchantmentThorns"))
    self:Register("tc:phyton", require("EnchantmentPhyton"))
end

return EnchantmentProxies