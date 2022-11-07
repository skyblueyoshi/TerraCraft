---@class Mod
---@field modId string
---@field displayName string
---@field version string
---@field gameVersion string
---@field assetRootPath string
---@field current Mod
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

---GetByID
---@param modID string
---@return nil|Mod
function Mod.GetByID(modID)
end

return Mod