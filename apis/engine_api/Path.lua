---@class Path
local Path = {}

---
---@param path string
---@return string
function Path.fix(path)
end

---
---@overload fun(path1:string,path2:string):string
---@overload fun(path1:string,path2:string,path3:string):string
---@param path1 string
---@param path2 string
---@param path3 string
---@param path4 string
---@return string
function Path.join(path1, path2, path3, path4)
end

---
---@param path string
---@return string
function Path.getExtension(path)
end

---
---@param path string
---@return string
function Path.getFileName(path)
end

---
---@param path string
---@return string
function Path.getFileNameWithoutExtension(path)
end

---
---@param relativeTo string
---@param path string
---@return string
function Path.getRelativePath(relativeTo, path)
end

---isRelativePath
---@param relativeTo string
---@param path string
---@return boolean
function Path.isRelativePath(relativeTo, path)
end

---
---@param path string
---@return string
function Path.getParentDirectory(path)
end

return Path