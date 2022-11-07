local ModTerraCraft = class("ModTerraCraft")
local RecordData = require("record.RecordData")

function ModTerraCraft:__init()
    self.m_client = nil
    self.m_server = nil

    self.m_gcTick = 0
    if NetMode.current == NetMode.Client then
        self.m_client = require("client.ModClient").new()
    end
end

function ModTerraCraft:registerProxy()
    math.randomseed(os.time())
    local guiLoader = require("ui.GuiLoader").new()
    if NetMode.current == NetMode.Client then
        Mod.current:RegisterClientGuiLoaderCallback({ guiLoader.GetClientGuiElement, guiLoader })
    else
        Mod.current:RegisterServerGuiLoaderCallback({ guiLoader.GetServerGuiElement, guiLoader })

        local TCModWorldData = require("world.TCModWorldData")
        local wdIns = TCModWorldData.getInstance()
        Mod.current:RegisterWorldServerSaver({ TCModWorldData.Save, wdIns })
        Mod.current:RegisterWorldServerLoader({ TCModWorldData.Load, wdIns })
    end

    local networkProxyHandler = require("network.TCNetworkProxyHandler")
    networkProxyHandler.new()

    local EnchantmentProxies = require("enchantments.EnchantmentProxies")
    EnchantmentProxies.getInstance():RegisterAll()

    local BuffProxies = require("buffs.BuffProxies")
    BuffProxies.getInstance():RegisterAll()

    local AdvancementTriggers = require("advancements.AdvancementTriggers")
    AdvancementTriggers.getInstance():RegisterAll()

    if NetMode.current == NetMode.Client then
        local MusicSceneProxy = require("client.MusicSceneProxy")
        MusicSceneProxy.getInstance():registerAll()
    end

    collectgarbage()
end

function ModTerraCraft:init()
    self:registerProxy()

    if Mod.GetByID("mod_edit") then
        print("has mod_edit!")
    end
    if NetMode.current == NetMode.Server then
    else
        self.m_client:init()
    end
end

function ModTerraCraft:start()
    if NetMode.current == NetMode.Server then
    else
        self.m_client:start()
    end
end

function ModTerraCraft:preUpdate()
    if NetMode.current == NetMode.Server then
    else
        self.m_client:preUpdate()
    end
end

function ModTerraCraft:update()
    if NetMode.current == NetMode.Server then
        RecordData.getInstance():update()
    else
        self.m_client:update()
    end

    self.m_gcTick = self.m_gcTick + 1
    if self.m_gcTick >= 60 then
        -- do gc every 1 seconds
        self.m_gcTick = 0
        collectgarbage()
    end
end

function ModTerraCraft:render()
    if NetMode.current == NetMode.Client then
        self.m_client:render()
    end
end

function ModTerraCraft:exit()
    if NetMode.current == NetMode.Server then
    else
        self.m_client:exit()
    end
end

return ModTerraCraft