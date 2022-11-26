---@API

---@class Path 标准化路径处理类。本项目对于文件路径，认为形如如下的路径都是标准化的。文件夹：Folder、Folder/Folder；文件：File.ext、Folder/File.ext。
local Path = {}

---修正路径为标准化路径。
---@param path string 原始路径。
---@return string 标准化路径。
function Path.fix(path)
end

---连接路径。
---@overload fun(path1:string,path2:string):string
---@overload fun(path1:string,path2:string,path3:string):string
---@param path1 string
---@param path2 string
---@param path3 string
---@param path4 string
---@return string 标准化路径。
function Path.join(path1, path2, path3, path4)
end

---获取后缀名称。例："abc/test.png"，返回".png"。
---@param path string
---@return string
function Path.getExtension(path)
end

---获取文件名。例："abc/test.png"，返回"test.png"。
---@param path string
---@return string
function Path.getFileName(path)
end

---获取不带后缀的文件名。例："abc/test.png"，返回"test"。
---@param path string
---@return string
function Path.getFileNameWithoutExtension(path)
end

---获取相对路径。例："folder"，"folder/folder2/test.txt"，返回"folder2/test.txt"。
---@param relativeTo string
---@param path string
---@return string
function Path.getRelativePath(relativeTo, path)
end

---判断是否是相对路径。例：
---
---（1）"folder"，"folder/folder2/test.txt"，返回true。
---
---（2）"folder_abc"，"folder/folder2/test.txt"，返回false。
---
---（3）"folder"，"folder_abc/folder2/test.txt"，返回false。
---@param relativeTo string
---@param path string
---@return boolean
function Path.isRelativePath(relativeTo, path)
end

---获取上级目录。例："abc/def/test.txt"返回"abc/def"。
---@param path string
---@return string
function Path.getParentDirectory(path)
end

return Path