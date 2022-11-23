---@class Mod 描述一个模组，维护模组的基本信息。
---@field modId string 模组的命名空间。
---@field displayName string 模组显示名称。
---@field version string 模组版本号。
---@field gameVersion string 游戏版本号。
---@field assetRootPath string 模组文件夹在assets系统中的文件夹根目录。
---@field current Mod 返回当前执行的脚本环境的模组。
---@field serverBoundPacket ServerBoundPacket
---@field clientBoundPacket ClientBoundPacket
---@field registry Registry
---@field modList Array
local Mod = {}

---RegisterClientGuiLoaderCallback
---@param callback function|table
---@return ListenerID
function Mod:RegisterClientGuiLoaderCallback(callback)
end

---@param callback function|table
---@return ListenerID
function Mod:RegisterServerGuiLoaderCallback(callback)
end

---RegisterClientGuiLoaderCallback
---@param callback function|table
---@return ListenerID
function Mod:RegisterClientBoundReaderCallback(callback)
end

---@param callback function|table
---@return ListenerID
function Mod:RegisterServerBoundReaderCallback(callback)
end

---@param callback function|table
---@return ListenerID
function Mod:RegisterWorldServerLoader(callback)
end

---@param callback function|table
---@return ListenerID
function Mod:RegisterWorldServerSaver(callback)
end

---通过模组命名空间，返回已加载模组。
---@param modID string 模组的命名空间。
---@return nil|Mod 已加载的模组，如果模组不存在，返回nil。
function Mod.GetByID(modID)
end

return Mod
