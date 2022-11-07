---@class AtlasLoader
local AtlasLoader = {}

---saveToFileSystem
---@param atlasInfos AtlasInfos
---@param folderPath string
function AtlasLoader.saveToFileSystem(atlasInfos, folderPath)
end

---saveToAssetBundle
---@param assetBundle AssetBundle
---@param atlasInfos AtlasInfos
---@param folderPath string
function AtlasLoader.saveToAssetBundle(assetBundle, atlasInfos, folderPath)
end

---loadFromFileSystem
---@param folderPath string
---@return AtlasInfos
function AtlasLoader.loadFromFileSystem(folderPath)
end

---loadFromAssetBundle
---@param assetBundle AssetBundle
---@param folderPath string
---@return AtlasInfos
function AtlasLoader.loadFromAssetBundle(assetBundle, folderPath)
end

return AtlasLoader