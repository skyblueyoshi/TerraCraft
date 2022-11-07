---@class TC.ModTextures
local ModTextures = class("ModTextures")

local s_instance
---@return TC.ModTextures
function ModTextures.getInstance()
    if s_instance == nil then
        s_instance = ModTextures.new()
    end
    return s_instance
end

function ModTextures:__init()
    self.textureNameDict = {}
    self:loadAll()

end

function ModTextures:loadAll()
    local allPngNames = AssetManager.getAllFiles(Path.join(Mod.current.assetRootPath, "mod_textures"), ".png", true, false, false)
    for _, pngName in ipairs(allPngNames) do
        local realPath = Path.join(Mod.current.assetRootPath, "mod_textures", pngName .. ".png")
        self.textureNameDict[pngName] = TextureManager.load(realPath)
    end
end

function ModTextures:getTexture(pngName)
    return self.textureNameDict[pngName]
end

return ModTextures