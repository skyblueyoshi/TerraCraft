---@class TC.Settings
local Settings = class("Settings")
local SettingsData = require("SettingsData")

local SETTING_FILE = "tc_settings.json"

local s_instance
---@return TC.Settings
function Settings.getInstance()
    if s_instance == nil then
        s_instance = Settings.new()
    end
    return s_instance
end

function Settings:__init()
    self.uiConfig = {
        {
            name = "常规",
            elements = {
                -- TODO:有BUG，后面再搞
                --{
                --    name = "地图显示比例", type = "Slider",
                --    maxValue = 15, minValue = 0,
                --    valueStep = 1,
                --    getter = function() return (MiscUtils.GetMapDisplayScale() - 0.5) * 10 end,
                --    setter = function(value) MiscUtils.SetMapDisplayScale(value * 0.1 + 0.5) end,
                --},
                {
                    name = "音乐音量", type = "Slider",
                    maxValue = 100, minValue = 0,
                    getter = function() return SettingsData.musicVolume end,
                    setter = function(value) SettingsData.musicVolume = value end,
                },
                {
                    name = "音效音量", type = "Slider",
                    maxValue = 100, minValue = 0,
                    getter = function() return SettingsData.soundVolume end,
                    setter = function(value) SettingsData.soundVolume = value end,
                },
                {
                    name = "显示音乐信息", type = "Boolean",
                    getter = function() return SettingsData.showMusicInfo end,
                    setter = function(value) SettingsData.showMusicInfo = value end,
                },
            }
        },
        {
            name = "开发者调试",
            elements = {
                {
                    name = "移动端操作模拟", type = "Boolean",
                    getter = function() return SettingsData.isMobileOperation end,
                    setter = function(value)
                        if App.isPC then
                            SettingsData.isMobileOperation = value
                        end
                    end,
                },
                {
                    name = "显示调试信息", type = "Boolean",
                    getter = function() return SettingsData.isShowDebugInfo end,
                    setter = function(value) SettingsData.isShowDebugInfo = value end,
                },
                {
                    name = "显示GUI布局", type = "Boolean",
                    getter = function() return SettingsData.isShowUIDebug end,
                    setter = function(value) SettingsData.isShowUIDebug = value end,
                },
                --{
                --    name = "TEST VALUE", type = "Slider",
                --    maxValue = 100, minValue = 0,
                --    getter = nil,
                --    setter = nil,
                --},
                --{
                --    name = "TEST BOOL 3", type = "Boolean",
                --    getter = nil,
                --    setter = nil,
                --},
                --{
                --    name = "TEST BOOL 4", type = "Boolean",
                --    getter = nil,
                --    setter = nil,
                --},
                --{
                --    name = "TEST VALUE 2", type = "Slider",
                --    maxValue = 100, minValue = 0,
                --    getter = nil,
                --    setter = nil,
                --},
                --{
                --    name = "TEST BOOL 5", type = "Boolean",
                --    getter = nil,
                --    setter = nil,
                --},
                --{
                --    name = "TEST BOOL 6", type = "Boolean",
                --    getter = nil,
                --    setter = nil,
                --},
                --{
                --    name = "TEST BOOL 7", type = "Boolean",
                --    getter = nil,
                --    setter = nil,
                --},
            }
        }
    }
end

function Settings.loadData()
    local path = Path.join(App.persistentDataPath, SETTING_FILE)
    if File.isPathExist(path) then
        local jsonStr = File.readAsString(path)
        local data = JsonUtil.fromJson(jsonStr)

        local function _readProperty(name)
            if data[name] ~= nil then
                SettingsData[name] = data[name]
            end
        end

        for k, _ in pairs(SettingsData) do
            _readProperty(k)
        end
    else
        -- 默认值
        SettingsData.isMobileOperation = App.isMobile and true or false
    end
    print("Current Settings Data:", SettingsData)
end

function Settings.saveData()
    local path = Path.join(App.persistentDataPath, SETTING_FILE)
    local jsonStr = JsonUtil.toJson(SettingsData)
    File.saveString(path, jsonStr)
    print("Save Settings Data:", SettingsData)
end

return Settings