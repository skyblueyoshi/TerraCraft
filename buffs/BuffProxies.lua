---@class TC.BuffProxies
local BuffProxies = class("BuffProxies")

local s_instance
---@return TC.BuffProxies
function BuffProxies.getInstance()
    if s_instance == nil then
        s_instance = BuffProxies.new()
    end
    return s_instance
end

function BuffProxies:__init()
    ---@type TC.BaseBuffProxy[]
    self._proxies = {}
end

---@param player Player
function BuffProxies:OnUpdatePlayer(player)
    if not player:HasAnyBuff() then
        return
    end
    local buffs = player:GetBuffList()
    ---@param buff Buff
    for _, buff in each(buffs) do
        if buff.time > 0 then
            local proxy = self._proxies[buff.id]
            if proxy then
                proxy.OnUpdatePlayer(player, buff.time)
            end
        end
    end
end

---@param npc Npc
function BuffProxies:OnUpdateNpc(npc)

end

function BuffProxies:Register(idName, proxy)
    local id = Reg.BuffID(idName)
    self._proxies[id] = proxy
end

function BuffProxies:RegisterAll()
    self:Register("tc:fire", require("BuffFire"))
    self:Register("tc:blindness", require("BuffBlindness"))
    self:Register("tc:glowing", require("BuffGlowing"))
    self:Register("tc:happiness", require("BuffHappiness"))
    self:Register("tc:health_boost", require("BuffHealthBoost"))
    self:Register("tc:hunger", require("BuffHunger"))
    self:Register("tc:hurt", require("BuffHurt"))
    self:Register("tc:invisibility", require("BuffInvisibility"))
    self:Register("tc:jump_boost", require("BuffJumpBoost"))
    self:Register("tc:levitation", require("BuffLevitation"))
    self:Register("tc:mining_fatique", require("BuffMiningFatigue"))
    self:Register("tc:poison", require("BuffPoison"))
    self:Register("tc:regeneration", require("BuffRegeneration"))
    self:Register("tc:resistance", require("BuffResistance"))
    self:Register("tc:sadness", require("BuffSadness"))
    self:Register("tc:slow_falling", require("BuffSlowFalling"))
    self:Register("tc:slow_mining", require("BuffSlowMining"))
    self:Register("tc:slowness", require("BuffSlowness"))
    self:Register("tc:speed", require("BuffSpeed"))
    self:Register("tc:strength", require("BuffStrength"))
    self:Register("tc:weak", require("BuffWeak"))
    self:Register("tc:wither", require("BuffWither"))
    self:Register("tc:vision", require("BuffVision"))

end

return BuffProxies