---@class TC.MusicSceneProxy
local MusicSceneProxy = class("MusicSceneProxy")
local ModMusicSceneProxy = require("ModMusicSceneProxy")

local s_instance

---@return TC.MusicSceneProxy
function MusicSceneProxy.getInstance()
    if s_instance == nil then
        s_instance = MusicSceneProxy.new()
    end
    return s_instance
end

function MusicSceneProxy:__init()
    self.proxy = {}
    self.biomeProxy = {}
    self.bossProxy = {}
end

function MusicSceneProxy:register(name, data)
    self.proxy[name] = data
end

function MusicSceneProxy:registerAll()
    self:register("tc:menu", {
        musicList = {
            "tc_music:unfinished",
            "tc_music:menu1",
            "tc_music:menu2",
        },
        fadeInTime = 5000,
        fadeOutTime = 1000,
        interval = 2000,
        intervalRandOffset = 100,
    })
    self:register("tc:forest", {
        musicList = {
            "tc_music:overworld",
            "tc_music:day2",
            "tc_music:day3",
            "tc_music:day4",
            "tc_music:mc_aria_math",
            "tc_music:mc_blind_spots",
            "tc_music:mc_haunt_muskie",
            "tc_music:mc_chris",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 2000,
        intervalRandOffset = 100,
    })
    self:register("tc:night", {
        musicList = {
            "tc_music:night1",
            "tc_music:night2",
            "tc_music:night3",
            "tc_music:night4",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 12000,
        intervalRandOffset = 10000,
    })
    self:register("tc:snow", {
        musicList = {
            "tc_music:mc_snow",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 2000,
        intervalRandOffset = 100,
    })
    self:register("tc:tainted", {
        musicList = {
            "tc_music:cr_deep_freeze",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 2000,
        intervalRandOffset = 100,
    })
    self:register("tc:flesh", {
        musicList = {
            "tc_music:cr_dark_drifting",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 2000,
        intervalRandOffset = 100,
    })
    self:register("tc:jungle", {
        musicList = {
            "tc_music:mc_aria_math",
            "tc_music:mc_blind_spots",
            "tc_music:mc_haunt_muskie",
            "tc_music:mc_chris",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 32000,
        intervalRandOffset = 16000,
    })
    self:register("tc:cave", {
        musicList = {
            "tc_music:mcunder1",
            "tc_music:mcunder2",
            "tc_music:mcunder3",
            "tc_music:mcunder4",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 8000,
        intervalRandOffset = 100,
    })
    self:register("tc:mushroom_cave", {
        musicList = {
            "tc_music:cr_star_trails",
        },
        fadeInTime = 3000,
        fadeOutTime = 3000,
        interval = 1000,
        intervalRandOffset = 100,
    })
    self:register("tc:lava", {
        musicList = {
            "tc_music:cr_calamity_of_dread",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 8000,
        intervalRandOffset = 100,
    })
    self:register("tc:ice_cave", {
        musicList = {
            "tc_music:cr_snow_delta",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 8000,
        intervalRandOffset = 100,
    })
    self:register("tc:nether", {
        musicList = {
            "tc_music:mcnether1",
        },
        fadeInTime = 5000,
        fadeOutTime = 3000,
        interval = 2000,
        intervalRandOffset = 100,
    })
    self:register("tc:boss", {
        musicList = {
            "tc_music:boss",
        },
        fadeInTime = 100,
        fadeOutTime = 1000,
        interval = 100,
        intervalRandOffset = 100,
    })

    self:registerBiomeScene("tc:Surface", "tc:forest", "day", "tc:forest")
    self:registerBiomeScene("tc:Surface", "tc:forest", "night", "tc:night")

    self:registerBiomeScene("tc:Surface", "tc:soft_snow_land", "day", "tc:snow")
    self:registerBiomeScene("tc:Surface", "tc:soft_snow_land", "night", "tc:night")

    self:registerBiomeScene("tc:Surface", "tc:snow_land", "day", "tc:snow")
    self:registerBiomeScene("tc:Surface", "tc:snow_land", "night", "tc:night")

    self:registerBiomeScene("tc:Surface", "tc:tainted_land", "day", "tc:tainted")
    self:registerBiomeScene("tc:Surface", "tc:tainted_land", "night", "tc:tainted")

    self:registerBiomeScene("tc:Surface", "tc:flesh", "day", "tc:flesh")
    self:registerBiomeScene("tc:Surface", "tc:flesh", "night", "tc:flesh")

    self:registerBiomeScene("tc:Surface", "tc:jungle", "day", "tc:jungle")

    self:registerBiomeScene("tc:Surface", "tc:super_volcano", "day", "tc:lava")
    self:registerBiomeScene("tc:Surface", "tc:super_volcano", "night", "tc:lava")

    self:registerBiomeScene("tc:Underground", "tc:deep_ice_cave", "default", "tc:ice_cave")
    self:registerBiomeScene("tc:Underground", "tc:blue_mushroom_cave", "default", "tc:mushroom_cave")

    self:registerBiomeScene("tc:Underground", "tc:flesh_cave", "default", "tc:flesh")
    self:registerBiomeScene("tc:Underground", "tc:tainted_cave", "default", "tc:tainted")

    self:registerBiomeScene("tc:Nether", "tc:nether", "default", "tc:nether")

    self:registerBossScene("tc:snow_queen", "tc:boss")
    self:registerBossScene("tc:worm_head", "tc:boss")
    self:registerBossScene("tc:crison_eye", "tc:boss")
    self:registerBossScene("tc:dungeon_eater_head", "tc:boss")

    ---@type TC.ModMusicSceneProxy[]
    local modProxies = {}
    for _, c in ipairs(ModMusicSceneProxy.getProxy()) do
        table.insert(modProxies, c.new(self))
    end
    for _, p in ipairs(modProxies) do
        p:onRegisterAllScenes()
    end
end

function MusicSceneProxy:registerBossScene(bossIDName, musicSceneName)
    local bossID = Reg.NpcID(bossIDName)
    self.bossProxy[bossID] = musicSceneName
end

function MusicSceneProxy:tryGetBossSceneName(bossID)
    return self.bossProxy[bossID]
end

---registerBiomeScene
---@param biomeTypeName string
---@param biomeIDName string
---@param style string
---@param musicSceneName string
function MusicSceneProxy:registerBiomeScene(biomeTypeName, biomeIDName, style, musicSceneName)
    local biomeType = Reg.BiomeTypeID(biomeTypeName)
    local biomeID = Reg.BiomeID(biomeIDName)
    if self.biomeProxy[biomeType] == nil then
        self.biomeProxy[biomeType] = {}
    end
    if self.biomeProxy[biomeType][biomeID] == nil then
        self.biomeProxy[biomeType][biomeID] = {}
    end
    self.biomeProxy[biomeType][biomeID][style] = musicSceneName
end

---tryGetBiomeSceneName
---@param biomeType int
---@param biomeID int
---@param style string
function MusicSceneProxy:tryGetBiomeSceneName(biomeType, biomeID, style)
    local biomeTypeProxy = self.biomeProxy[biomeType]
    if biomeTypeProxy == nil then
        return nil
    end
    local biomeIDProxy = biomeTypeProxy[biomeID]
    if biomeIDProxy == nil then
        return nil
    end
    return biomeIDProxy[style]
end

return MusicSceneProxy