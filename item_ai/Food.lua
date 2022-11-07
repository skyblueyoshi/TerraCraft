---@class TC.Food:ModItem
local Food = class("Food", ModItem)
local Constants = require("constants.Constants")

function Food:CanUse(player)
    local stack = self.itemStack
    local healthCodeID = Reg.BuffID("health_cold")
    local item = stack:GetItem()
    local buffs = item.buffs
    if player:HasBuff(healthCodeID) then
        for _, buff in ipairs(buffs) do
            if buff.id == healthCodeID then
                return false
            end
        end
    end
    if #buffs > 0 then
        return true
    end
    if item.addHealth > 0 or (item.addMagic > 0 and item.addMaxMagic == 0) then
        return true
    end
    if item.addMaxMagic > 0 then
        if player.maxMana < Constants.PLAYER_MAX_MAX_MANA then
            return true
        end
        return false
    end
    if item.food > 0 and player.foodLevel < 100 then
        return true
    end

    return false
end

function Food:OnUsed(player)
    local item = self.itemStack:GetItem()
    if item.addHealth ~= 0 then
        local v = math.abs(item.addHealth)
        if item.addHealth < 0 then
            player:Strike(DeathReason.BUFF, Attack.new(v, 0, 0), 0, false, false)
        else
            player:Heal(v)
        end
    end
    if item.addMaxMagic ~= 0 then
        local PlayerConstants = require("player.PlayerConstants")
        player.maxMana = math.min(PlayerConstants.MaxManaA, player.maxMana + item.addMaxMagic)
    end
    if item.addMagic ~= 0 then
        local v = math.abs(item.addMagic)
        player:AddMagic(v)
    end
    local buffs = item.buffs
    for _, buff in ipairs(buffs) do
        player:AddBuff(buff.id, buff.time)
    end
    if item.food > 0 and player.foodLevel < 100 then
        player:AddFood(item.food, item.foodSaturation)
    end

    self:PlayEatSound(player)
end

function Food:PlayEatSound(player)
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("eat"), player.centerXi, player.centerYi)
end

function Food:IsKilledAfterUsed()
    return true
end

return Food