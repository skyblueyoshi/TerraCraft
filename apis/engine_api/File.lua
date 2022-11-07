---@class File
local File = {}

---getLastWriteTime
---@param path string
---@return DateTime
function File.getLastWriteTime(path)
end

---
---@param filePath string
---@param isFullPath boolean
---@return string[]
function File.getAllSubFolders(filePath, isFullPath)
end

---
---@param path string
---@param extension string
---@param resultNoExtension boolean
---@param getAbsPath boolean
---@param recursion boolean
---@return string[]
function File.getAllFiles(path, extension, resultNoExtension, getAbsPath, recursion)
end

---saveString
---@param path string
---@param str string
function File.saveString(path, str)
end

---saveBytes
---@param path string
---@param bytes Bytes
function File.saveBytes(path, bytes)
end

---readAsString
---@param path string
---@return string
function File.readAsString(path)
end

---readAsBytes
---@param path string
---@return Bytes
function File.readAsBytes(path)
end

---isPathExist
---@param path string
---@return boolean
function File.isPathExist(path)
end

---openFolderWindow
---@param path string
function File.openFolderWindow(path)
end

---makeFolder
---@param path string
function File.makeFolder(path)
end

return File