---@class TexturePacker
local TexturePacker = {}

---genAtlasFromFileSystem
---@overload fun(folderPath:string,subPaths:string[],ignorePaths:string[],atlasName:string):AtlasInfos
---@param folderPath string
---@param subPaths string[]
---@param ignorePaths string[]
---@param atlasName string
---@param maxSize number
---@return AtlasInfos
function TexturePacker.genAtlasFromFileSystem(folderPath, subPaths, ignorePaths, atlasName, maxSize)
end

---genAtlasFromAssetBundle
---@overload fun(assetBundle:AssetBundle,folderPath:string,subPaths:string[],ignorePaths:string[],atlasName:string):AtlasInfos
---@param assetBundle AssetBundle
---@param folderPath string
---@param subPaths string[]
---@param ignorePaths string[]
---@param atlasName string
---@param maxSize number
---@return AtlasInfos
function TexturePacker.genAtlasFromAssetBundle(assetBundle, folderPath, subPaths, ignorePaths, atlasName, maxSize)
end

return TexturePacker