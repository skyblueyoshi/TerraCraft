---@class AssetManager
local AssetManager = {}

---getLastWriteTime
---@param path string
---@return DateTime
function AssetManager.getLastWriteTime(path)
end

---readAsString
---@param path string
---@return string
function AssetManager.readAsString(path)
end

---readAsBytes
---@param path string
---@return Bytes
function AssetManager.readAsBytes(path)
end

---
---@param filePath string
---@param isFullPath boolean
---@return string[]
function AssetManager.getAllSubFolders(filePath, isFullPath)
end

---
---@param path string
---@param extension string
---@param resultNoExtension boolean
---@param getAbsPath boolean
---@param recursion boolean
---@return string[]
function AssetManager.getAllFiles(path, extension, resultNoExtension, getAbsPath, recursion)
end

---isPathExist
---@param path string
---@return boolean
function AssetManager.isPathExist(path)
end

---genPackFromSource
---@param sourceParentFolderPath string
---@param folderName string
---@param assetMappingPath string
---@return string
function AssetManager.genPackFromSource(sourceParentFolderPath, folderName, assetMappingPath)
end

return AssetManager