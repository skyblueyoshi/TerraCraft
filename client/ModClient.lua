local ModClient = class("ModClient")
local MusicPool = require("MusicPool")
local MusicSystem = require("MusicSystem")
local UIManager = require("ui.UIManager")
local InputControl = require("InputControl")
local CameraInGame = require("CameraInGame")
local ModTextures = require("mod_textures.ModTextures")
local RecordData = require("record.RecordData")

--- the constructor of this class
function ModClient:__init()
    self._cameraGameObject = nil

    -- the menu background element renderer
    self._hudUI = nil
    self._pendingUI = nil
    self._lastState = nil

    self._stateBeginProxies = {
        [ClientState.InMenu] = self.beginInMenu,
        [ClientState.Joining] = self.beginJoining,
        [ClientState.Gaming] = self.beginGaming,
        [ClientState.SavingWorld] = self.beginSavingWorld,
        [ClientState.LosingConnection] = self.beginSavingWorld,
    }

    self._stateEndProxies = {
        [ClientState.LoadingWorld] = self.endLoadingWorld,
        [ClientState.Gaming] = self.endGaming,
        [ClientState.SavingWorld] = self.endSavingWorld,
        [ClientState.LosingConnection] = self.endSavingWorld,
    }

    self._stateUpdateProxies = {
        [ClientState.InMenu] = self.updateInMenu,
        [ClientState.Joining] = self.updateJoining,
        [ClientState.Gaming] = self.updateGaming,
    }
    self._stateRenderProxies = {
        [ClientState.InMenu] = self.renderInMenu,
        [ClientState.Gaming] = self.renderGaming,
    }
    self._testTime = 0
end

function ModClient:init()
    FontManager.load(Path.join(Mod.current.assetRootPath, "font/msyhbd.ttf"), "msyhbd")
    require("languages.LocaleHelper").reload(require("languages.Locale"))
    require("settings.Settings").loadData()

    -- create the main camera
    self._cameraGameObject = GameObject.instantiate()
    self._cameraGameObject.camera:init()
    CameraInGame.getInstance():setCamera(self._cameraGameObject.camera)

    MusicPool.getInstance():initModMusicResources(Mod.GetByID("tc_music"), "music")
    MusicSystem.getInstance():registerFromProxy()

    ModTextures.getInstance()

    UIManager.getInstance():init()
    UIManager.getInstance():initUISpriteResources(Mod.current, "ui_res")
    UIManager.getInstance():initUISpriteResources(Mod.current, "ui_res_large")
    UIManager.getInstance():postInit()
end

function ModClient:start()

end

function ModClient:beginInMenu()
    require("ui.StartUI").new()

    MusicSystem.getInstance():switchToScene("tc:menu")
end

function ModClient:preUpdate()
    InputControl.getInstance():update()
    self._cameraGameObject.transform.position = Vector3.new(MiscUtils.screenX, MiscUtils.screenY, 0)
end

function ModClient:update()

    -- check end
    if self._lastState ~= nil and self._lastState ~= ClientState.current then
        print("end game state:", self._lastState, " -> ", ClientState.current)
        local proxy = self._stateEndProxies[self._lastState]
        if proxy then
            proxy(self)
        end
    end
    -- check begin
    if self._lastState ~= ClientState.current then
        self._lastState = ClientState.current
        print("begin game state:", self._lastState)
        local proxy = self._stateBeginProxies[ClientState.current]
        if proxy then
            proxy(self)
        end
    end
    -- check update
    local proxy = self._stateUpdateProxies[ClientState.current]
    if proxy then
        proxy(self)
    end
    UIManager.getInstance():update()
    MusicSystem.getInstance():update()
end

function ModClient:render()
    local proxy = self._stateRenderProxies[ClientState.current]
    if proxy then
        proxy(self)
    end
    UIManager.getInstance():render()
end

function ModClient:exit()
end

function ModClient:updateInMenu()
end

function ModClient:renderInMenu()
end

function ModClient:beginGaming()
    local HudUI = require("ui.hud.HudUI")
    self._hudUI = HudUI.new()
end

function ModClient:endGaming()
    self._hudUI:closeWindow()
    self._hudUI = nil
end

function ModClient:updateGaming()
    self._hudUI:update()
    MusicSystem.getInstance():updateGaming()
    RecordData.getInstance():update()
end

function ModClient:renderGaming()

end

function ModClient:beginJoining()
    local PendingUI = require("ui.PendingUI")
    self._pendingUI = PendingUI.new()
end

function ModClient:updateJoining()
end

function ModClient:endLoadingWorld()
    self._pendingUI:closeWindow()
    self._pendingUI = nil
end

function ModClient:beginSavingWorld()
    local PendingUI = require("ui.PendingUI")
    self._pendingUI = PendingUI.new()
end

function ModClient:endSavingWorld()
    self._pendingUI:closeWindow()
    self._pendingUI = nil
end

return ModClient