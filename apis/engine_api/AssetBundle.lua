---@class AssetBundle
local AssetBundle = {}

---
---@return AssetBundle
function AssetBundle.new()
end

---clone
---@param value AssetBundle
---@return AssetBundle
function AssetBundle.clone(value)
end

---
---@param abPath string
---@return string
function AssetBundle:loadFromFileSystem(abPath)
end

---
---@param abPath string
function AssetBundle:saveToFileSystem(abPath)
end

---
---@param filePath string
---@param data Bytes
---@param offset number
---@param size number
function AssetBundle:addFileData(filePath, data, offset, size)
end

---
---@param filePath string
---@return string
function AssetBundle:getFileString(filePath)
end

---
---@param filePath string
---@return Bytes
function AssetBundle:getFileBytes(filePath)
end

function AssetBundle:clear()
end

function AssetBundle:freeMemory()
end

---
---@param filePath string
---@return boolean
function AssetBundle:isFileExist(filePath)
end

---
---@param folderPath string
---@return boolean
function AssetBundle:isFolderExist(folderPath)
end

---
---@param filePath string
---@param isFullPath boolean
---@return table
function AssetBundle:getAllSubFolders(filePath, isFullPath)
end

---
---@param path string
---@param extension string
---@param resultNoExtension boolean
---@param getAbsPath boolean
---@param recursion boolean
---@return table
function AssetBundle:getAllFiles(path, extension, resultNoExtension, getAbsPath, recursion)
end

return AssetBundle