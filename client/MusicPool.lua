---@class TC.MusicPool
local MusicPool = class("MusicPool")

---@class TC.MusicPoolElement
local MusicPoolElement = class("MusicPoolElement")

function MusicPoolElement:__init(musicAssetPath)
    self.musicID = 0
    self.musicAssetPath = musicAssetPath
end

local s_instance

---@return TC.MusicPool
function MusicPool.getInstance()
    if s_instance == nil then
        s_instance = MusicPool.new()
    end
    return s_instance
end

function MusicPool:__init()
    self._elements = {}
end

---initModMusicResources
---@param mod Mod
---@param dirPathInMod string
function MusicPool:initModMusicResources(mod, dirPathInMod)
    local searchPath = Path.join(mod.assetRootPath, dirPathInMod)
    local musicNameMP3s = AssetManager.getAllFiles(searchPath, ".mp3",
            true, false, true)
    local musicNameOGGs = AssetManager.getAllFiles(searchPath, ".ogg",
            true, false, true)

    for _, musicName in ipairs(musicNameMP3s) do
        local name = mod.modId .. ":" .. musicName
        --print(name)
        self._elements[name] = MusicPoolElement.new(Path.join(searchPath, musicName .. ".mp3"))
    end

    for _, musicName in ipairs(musicNameOGGs) do
        local name = mod.modId .. ":" .. musicName
        --print(name)
        self._elements[name] = MusicPoolElement.new(Path.join(searchPath, musicName .. ".ogg"))
    end
end

function MusicPool:getIDAndActivateMusic(musicName)
    local element = self._elements[musicName]
    if element == nil then
        print("MusicPool:getIDAndActivateMusic failed:", musicName)
        assert(false)
    end
    if element.musicID == 0 then
        local bytes = AssetManager.readAsBytes(element.musicAssetPath)
        element.musicID = Audio.loadMusicEffectFromMemory(bytes, 0, bytes.count)
    end
    return element.musicID
end

function MusicPool:recycleAndEnsureMusicMemory(ensureMusicNames)
    local ensureNameDict = {}
    for _, name in ipairs(ensureMusicNames) do
        ensureNameDict[name] = true
    end

    -- unload all music if not ensured
    ---@param element TC.MusicPoolElement
    for name, element in pairs(self._elements) do
        if ensureNameDict[name] == nil then
            if element.musicID ~= 0 then
                Audio.unloadMusicEffectByID(element.musicID)
                element.musicID = 0
            end
        end
    end

    -- load all music if ensured
    for name, _ in pairs(ensureNameDict) do
        ---@type TC.MusicPoolElement
        local element = self._elements[name]
        if element.musicID == 0 then
            local bytes = AssetManager.readAsBytes(element.musicAssetPath)
            element.musicID = Audio.loadMusicEffectFromMemory(bytes, 0, bytes.count)
        end
    end


end

return MusicPool