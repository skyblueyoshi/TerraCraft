---@class TC.AdvancementTriggers
local AdvancementTriggers = class("AdvancementProxies")

local s_instance
---@return TC.AdvancementTriggers
function AdvancementTriggers.getInstance()
    if s_instance == nil then
        s_instance = AdvancementTriggers.new()
    end
    return s_instance
end

function AdvancementTriggers:__init()
    self._itemTriggerProxies = {}
    self._oreDictionaryTriggerProxies = {}
    self._npcKillTriggerProxies = {}
    self._biomeTypeTriggerProxies = {}
    self._biomeTriggerProxies = {}
end

function AdvancementTriggers:TriggerEnterBiome(player, biomeID)
    local biomeData = BiomeUtils.GetData(biomeID)
    self:_TryTriggerProxy(player, self._biomeTriggerProxies[biomeID])
    self:_TryTriggerProxy(player, self._biomeTypeTriggerProxies[biomeData.biomeType])
end

---TriggerGetItem
---@param player Player
---@param itemID int
---@param stackSize int
function AdvancementTriggers:TriggerGetItem(player, itemID, stackSize)
    -- trigger by single item
    self:_TryTriggerProxy(player, self._itemTriggerProxies[itemID])

    -- trigger by item ore dictionary
    local item = ItemRegistry.GetItemByID(itemID)
    for _, oreDictionaryID in each(item.oreDictionaryIDs) do
        self:_TryTriggerProxy(player, self._oreDictionaryTriggerProxies[oreDictionaryID])
    end
end

---TriggerKillNpc
---@param player Player
---@param npc Npc
function AdvancementTriggers:TriggerKillNpc(player, npc)
    self:_TryTriggerProxy(player, self._npcKillTriggerProxies[npc.id])
end

function AdvancementTriggers:_TryTriggerProxy(player, proxy)
    if proxy ~= nil then
        self:_TriggerAll(player, proxy)
    end
end

---_TriggerAll
---@param player Player
---@param advancementIDs int[]
function AdvancementTriggers:_TriggerAll(player, advancementIDs)
    for _, advancementID in ipairs(advancementIDs) do
        player:FinishAdvancement(advancementID)
    end
end

function AdvancementTriggers:_AddProxyAdvancement(triggerProxies, key, advancementIDName)
    local advancementID = Reg.AdvancementID(advancementIDName)
    if triggerProxies[key] == nil then
        triggerProxies[key] = {}
    end
    local exist = false
    for _, v in ipairs(triggerProxies[key]) do
        if v == advancementID then
            exist = true
            break
        end
    end
    if not exist then
        table.insert(triggerProxies[key], advancementID)
    end
end

function AdvancementTriggers:RegisterItemTrigger(advancementIDName, itemIDName)
    self:_AddProxyAdvancement(self._itemTriggerProxies, Reg.ItemID(itemIDName), advancementIDName)
end

function AdvancementTriggers:RegisterOreDictionaryTrigger(advancementIDName, oreDictionaryName)
    self:_AddProxyAdvancement(self._oreDictionaryTriggerProxies, Reg.OreDictionaryID(oreDictionaryName), advancementIDName)
end

function AdvancementTriggers:RegisterNpcKillTrigger(advancementIDName, npcIDName)
    self:_AddProxyAdvancement(self._npcKillTriggerProxies, Reg.NpcID(npcIDName), advancementIDName)
end

function AdvancementTriggers:RegisterBiomeTypeTrigger(advancementIDName, biomeTypeIDName)
    self:_AddProxyAdvancement(self._biomeTypeTriggerProxies, Reg.BiomeTypeID(biomeTypeIDName), advancementIDName)
end

function AdvancementTriggers:RegisterBiomeTrigger(advancementIDName, biomeIDName)
    self:_AddProxyAdvancement(self._biomeTriggerProxies, Reg.BiomeID(biomeIDName), advancementIDName)
end

function AdvancementTriggers:RegisterAll()
    self:RegisterItemTrigger("crafting_table", "crafting_table")
    self:RegisterItemTrigger("ender_chest", "ender_chest")
    self:RegisterItemTrigger("blaze_rod", "blaze_rod")
    self:RegisterItemTrigger("crafting_table", "crafting_table")
    self:RegisterItemTrigger("bow", "wooden_bow")
    self:RegisterItemTrigger("crossbow", "cross_bow")
    self:RegisterItemTrigger("crossbow", "shot_bow")
    self:RegisterItemTrigger("bread", "bread")
    self:RegisterItemTrigger("brew", "brewing_stand")
    self:RegisterItemTrigger("bronze", "bronze_ingot")
    self:RegisterItemTrigger("cake", "cake")
    self:RegisterItemTrigger("diamond", "diamond")
    self:RegisterItemTrigger("enchant", "enchantment_table")
    self:RegisterItemTrigger("ender_pearl", "ender_pearl")
    self:RegisterItemTrigger("furnace", "furnace")
    self:RegisterItemTrigger("lava", "bucket_lava")
    self:RegisterItemTrigger("leather", "leather")
    self:RegisterItemTrigger("mine", "wooden_pickaxe")
    self:RegisterItemTrigger("mine_up", "stone_pickaxe")
    self:RegisterItemTrigger("netherite", "ore_ancient_debris")
    self:RegisterItemTrigger("pumpkin_helmet", "pumpkin_helmet")
    self:RegisterItemTrigger("redstone", "redstone")
    self:RegisterItemTrigger("redstone_wire", "red_wire")
    self:RegisterItemTrigger("steel", "steel_ingot")
    self:RegisterItemTrigger("stone", "cobblestone")
    self:RegisterItemTrigger("strange_len", "strange_len")
    self:RegisterItemTrigger("rocket_boost", "rocket_boost")
    self:RegisterItemTrigger("mine_copper", "copper_pickaxe")
    self:RegisterItemTrigger("mine_copper", "tin_pickaxe")
    self:RegisterItemTrigger("mine_iron", "iron_pickaxe")
    self:RegisterItemTrigger("mine_iron", "lead_pickaxe")
    self:RegisterItemTrigger("mine_bronze", "bronze_pickaxe")
    self:RegisterItemTrigger("mine_bronze", "steel_pickaxe")
    self:RegisterItemTrigger("mine_gold", "golden_pickaxe")
    self:RegisterItemTrigger("mine_gold", "silver_pickaxe")
    self:RegisterItemTrigger("mine_diamond", "diamond_pickaxe")
    self:RegisterItemTrigger("mine_netherite", "nether_pickaxe")
    self:RegisterItemTrigger("repair", "anvil")
    self:RegisterItemTrigger("gold", "gold_ingot")
    self:RegisterItemTrigger("super_diamond_sword", "super_diamond_sword")
    self:RegisterItemTrigger("ghost_crystal", "ghost_crystal")
    self:RegisterItemTrigger("ghost", "ghost")
    self:RegisterItemTrigger("ice_element_ball", "ice_element_ball")
    self:RegisterItemTrigger("diamond_ingot", "diamond_ingot")
    self:RegisterItemTrigger("ancient_ingot", "ancient_ingot")
    self:RegisterItemTrigger("knight_ingot", "knight_ingot")
    self:RegisterItemTrigger("flesh_ingot", "flesh_ingot")
    self:RegisterItemTrigger("gun", "handgun")
    self:RegisterItemTrigger("gun", "rocket_launcher")
    self:RegisterItemTrigger("gun", "shotgun")
    self:RegisterItemTrigger("gun", "sniper")
    self:RegisterItemTrigger("gun", "rifle")
    self:RegisterItemTrigger("magic_limit", "mana_piece")

    self:RegisterOreDictionaryTrigger("wood", "OD_WOOD")
    self:RegisterOreDictionaryTrigger("farm", "OD_HOE")
    self:RegisterOreDictionaryTrigger("sword", "OD_SWORD")
    self:RegisterOreDictionaryTrigger("staff", "OD_STAFF")
    self:RegisterOreDictionaryTrigger("iron", "OD_IRON_INGOT")

    self:RegisterNpcKillTrigger("guardian", "guardian")
    self:RegisterNpcKillTrigger("ghast", "ghast")
    self:RegisterNpcKillTrigger("snow_guard", "snow_guardian")
    self:RegisterNpcKillTrigger("snow_guard", "snow_guardian_archer")

    self:RegisterBiomeTypeTrigger("nether", "Nether")
    self:RegisterBiomeTrigger("go_ghost_house", "more_dungeons:ghost_dungeon")
    self:RegisterBiomeTrigger("go_bone_dungeon", "more_dungeons:bone_dungeon")
    self:RegisterBiomeTrigger("go_dark_dungeon", "more_dungeons:tr_dungeon")
    self:RegisterBiomeTrigger("go_deep_snow", "deep_ice_cave")
    self:RegisterBiomeTrigger("go_ice_dungeon", "more_dungeons:blue_dungeon")
    self:RegisterBiomeTrigger("go_lava_dungeon", "more_dungeons:volcano_dungeon")
    self:RegisterBiomeTrigger("go_desert_dungeon", "more_dungeons:desert_dungeon")
end

return AdvancementTriggers