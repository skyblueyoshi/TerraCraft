---@class TC.MusicSystem
local MusicSystem = class("MusicSystem")
local MusicScene = require("MusicScene")
local MusicPool = require("MusicPool")
local MusicSceneProxy = require("MusicSceneProxy")
local SettingsData = require("settings.SettingsData")
local RecordData = require("record.RecordData")

local BIOME_TYPE_SURFACE = Reg.BiomeTypeID("tc:Surface")
local BIOME_TYPE_UNDERGROUND = Reg.BiomeTypeID("tc:Underground")
local BIOME_TYPE_NETHER = Reg.BiomeTypeID("tc:Nether")

local s_instance

local COPYRIGHT_DISPLAY_SECONDS = 4

---@return TC.MusicSystem
function MusicSystem.getInstance()
    if s_instance == nil then
        s_instance = MusicSystem.new()
    end
    return s_instance
end

function MusicSystem:__init()
    self.musicScenes = {}
    self.currentMusicScene = nil ---@type TC.MusicScene
    self.currentMusicSceneName = nil
    self.nextMusicSceneName = nil
    self.lastMusicSceneNameForContinue = nil
    self.lastMusicIndexForContinue = 1
    self.lastMusicTimeForContinue = 0
    self.usingLastMusicScene = false
    self.usingLastMusicIndex = 1
    self.usingLastMusicTime = 0

    self.nextMusicPendingTime = 0
    self.isNextMusicPending = false
    self.musicIndexInList = 1

    self.test = 0
    self.lastBossID = -1
    self.lastBiomeType = -1
    self.lastBiomeID = -1
    self.lastIsNight = false

    self.playingTime = 0
    self._lastSoundVolumePercent = 100
    self._lastMusicVolumePercent = 100
    self.musicCopyright = nil
    self.musicCopyrightTick = 0

    Audio.addMusicFinishedListener({ MusicSystem._onMusicFinished, self })
end

function MusicSystem:_onMusicFinished()
    self.playingTime = 0
    if self.nextMusicSceneName ~= nil then
        self.currentMusicScene = self.musicScenes[self.nextMusicSceneName]
        self.currentMusicSceneName = self.nextMusicSceneName
        self.nextMusicSceneName = nil

        local offsetTime = 0
        if self.usingLastMusicScene ~= nil then
            self.musicIndexInList = self.usingLastMusicIndex
            offsetTime = self.usingLastMusicTime
        else
            self.musicIndexInList = 1
            self.currentMusicScene:doRandomList()
        end
        self:_playCurrentMusic(offsetTime)
    else
        self.isNextMusicPending = true
        self.nextMusicPendingTime = self.currentMusicScene.interval + math.random(self.currentMusicScene.intervalRandOffset)
    end
end

function MusicSystem:update()
    if self._lastMusicVolumePercent ~= SettingsData.musicVolume then
        self._lastMusicVolumePercent = SettingsData.musicVolume
        Audio.setMusicVolume(self._lastMusicVolumePercent / 100.0)
    end

    if self._lastSoundVolumePercent ~= SettingsData.soundVolume then
        self._lastSoundVolumePercent = SettingsData.soundVolume
        Audio.setAllSoundEffectVolume(self._lastSoundVolumePercent / 100.0)
    end

    if self.isNextMusicPending then
        if self.nextMusicPendingTime > 0 then
            self.nextMusicPendingTime = self.nextMusicPendingTime - Time.deltaTime * 1000
        end
        if self.nextMusicPendingTime <= 0 then
            self.isNextMusicPending = false
            self.nextMusicPendingTime = 0

            self.musicIndexInList = self.musicIndexInList + 1
            if self.musicIndexInList > #self.currentMusicScene.musicList then
                self.musicIndexInList = 1
            end
            self:_playCurrentMusic()
        end
    end
    self.test = self.test + 1
    if self.test == 60 * 10 then
        --self:switchToScene("tc:forest")
    end
    if Audio.isMusicPlaying() then
        self.playingTime = self.playingTime + Time.deltaTime
    else
        self.playingTime = 0
    end

    if self.musicCopyrightTick > 0 then
        self.musicCopyrightTick = self.musicCopyrightTick - 1
        if self.musicCopyrightTick == 0 then
            self.musicCopyright = nil
        end
    end
end

function MusicSystem:updateGaming()
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player == nil then
        return
    end
    local biomeType = player.biomeType
    local biomeID = player.biomeID
    local isNight = MiscUtils.isNight
    local bossID = RecordData.getInstance().curBossID
    local playingBossMusic = false

    if self.lastBossID ~= bossID then
        self.lastBossID = bossID
        if bossID > 0 then
            local name = MusicSceneProxy.getInstance():tryGetBossSceneName(bossID)
            if name ~= nil then
                self:switchToScene(name)
            end
        end
    end

    if self.lastBossID > 0 then
        playingBossMusic = true
        self.lastBiomeType = -1
        self.lastBiomeID = -1
    end

    if not playingBossMusic then
        if self.lastBiomeType ~= biomeType or self.lastBiomeID ~= biomeID or self.lastIsNight ~= isNight then

            self.lastBiomeType = biomeType
            self.lastBiomeID = biomeID
            self.lastIsNight = isNight

            if biomeType == BIOME_TYPE_SURFACE then

                if not isNight then
                    local name = MusicSceneProxy.getInstance():tryGetBiomeSceneName(biomeType, biomeID, "day")
                    if name ~= nil then
                        self:switchToScene(name)
                    else
                        name = MusicSceneProxy.getInstance():tryGetBiomeSceneName(biomeType, Reg.BiomeID("tc:forest"), "day")
                        self:switchToScene(name)
                    end
                else
                    local name = MusicSceneProxy.getInstance():tryGetBiomeSceneName(biomeType, biomeID, "night")
                    if name ~= nil then
                        self:switchToScene(name)
                    else
                        name = MusicSceneProxy.getInstance():tryGetBiomeSceneName(biomeType, Reg.BiomeID("tc:forest"), "night")
                        self:switchToScene(name)
                    end
                end
            elseif biomeType == BIOME_TYPE_UNDERGROUND then
                local name = MusicSceneProxy.getInstance():tryGetBiomeSceneName(biomeType, biomeID, "default")
                if name ~= nil then
                    self:switchToScene(name)
                else
                    self:switchToScene("tc:cave")
                end
            elseif biomeType == BIOME_TYPE_NETHER then
                local name = MusicSceneProxy.getInstance():tryGetBiomeSceneName(biomeType, biomeID, "default")
                if name ~= nil then
                    self:switchToScene(name)
                else
                    self:switchToScene("tc:nether")
                end
            end
        end
    end
end

function MusicSystem:_playCurrentMusic(offsetTime)
    if offsetTime == nil then
        offsetTime = 0
    end
    if #self.currentMusicScene.musicList > 0 then
        local name = self.currentMusicScene.musicList[self.musicIndexInList]
        local musicID = MusicPool.getInstance():getIDAndActivateMusic(name)
        Audio.playMusic(musicID, 1, self.currentMusicScene.fadeInTime, offsetTime * 1000)

        local MusicCopyright = require("MusicCopyright")
        if MusicCopyright[name] ~= nil then
            self.musicCopyright = MusicCopyright[name]
            self.musicCopyrightTick = 60 * COPYRIGHT_DISPLAY_SECONDS
        else
            self.musicCopyright = MusicCopyright['tc:unfinished']
            self.musicCopyrightTick = 60 * COPYRIGHT_DISPLAY_SECONDS
        end

    end
end

function MusicSystem:switchToScene(sceneName)
    local scene = self.musicScenes[sceneName] ---@type TC.MusicScene
    if scene == nil then
        return
    end
    print("Play Music Scene:", sceneName)
    if self.currentMusicSceneName == nil then
        self.currentMusicSceneName = sceneName
        self.currentMusicScene = scene

        self.musicIndexInList = 1
        self.currentMusicScene:doRandomList()
        self:_playCurrentMusic()
    else
        if sceneName == self.currentMusicSceneName then
            return
        end
        if self.lastMusicSceneNameForContinue ~= nil and sceneName == self.lastMusicSceneNameForContinue then
            self.usingLastMusicScene = self.lastMusicSceneNameForContinue
            self.usingLastMusicIndex = self.lastMusicIndexForContinue
            self.usingLastMusicTime = self.lastMusicTimeForContinue
        else
            self.usingLastMusicScene = nil
            self.usingLastMusicIndex = 1
            self.usingLastMusicTime = 0
            scene:doRandomList()
        end
        self.lastMusicSceneNameForContinue = self.currentMusicSceneName
        self.lastMusicIndexForContinue = self.musicIndexInList
        self.lastMusicTimeForContinue = self.playingTime

        self.nextMusicSceneName = sceneName
        Audio.stopMusic(self.currentMusicScene.fadeOutTime)
    end
end

function MusicSystem:playCurrentMusicSceneImmediately()
    if self.currentMusicScene == nil then
        return
    end
end

function MusicSystem:registerFromProxy()
    local Proxy = require("MusicSceneProxy")
    for name, data in pairs(Proxy.getInstance().proxy) do
        local musicList = {}
        local fadeInTime = 0
        local fadeOutTime = 0
        local interval = 0
        local intervalRandOffset = 0
        if data.musicList ~= nil then
            musicList = data.musicList
        end
        if data.fadeInTime ~= nil then
            fadeInTime = data.fadeInTime
        end
        if data.fadeOutTime ~= nil then
            fadeOutTime = data.fadeOutTime
        end
        if data.interval ~= nil then
            interval = data.interval
        end
        if data.intervalRandOffset ~= nil then
            intervalRandOffset = data.intervalRandOffset
        end

        self.musicScenes[name] = MusicScene.new(
                musicList,
                fadeInTime,
                fadeOutTime,
                interval,
                intervalRandOffset
        )
    end

end

return MusicSystem