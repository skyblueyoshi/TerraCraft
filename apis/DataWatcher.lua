---@API

---@class DataWatcher 数据同步类，内部封装了网络同步逻辑。
local DataWatcher = {}

---
---@overload fun(value:int):int
---@param value boolean
---@param canRemote boolean
---@return int
function DataWatcher:AddBool(value, canRemote)
end

---由指定通道，向
---@param channel int
---@param value boolean
function DataWatcher:UpdateBool(channel, value)
end

---由指定通道，从远端获取数据。
---@param channel int 通道。
---@return boolean 布尔型数据。
function DataWatcher:GetBool(channel)
end

---
---@overload fun(value:int):int
---@param value int
---@param canRemote boolean
---@return int
function DataWatcher:AddByte(value, canRemote)
end

---
---@param channel int
---@param value int
function DataWatcher:UpdateByte(channel, value)
end

---
---@param channel int
---@return int
function DataWatcher:GetByte(channel)
end

---
---@overload fun(value:int):int
---@param value int
---@param canRemote boolean
---@return int
function DataWatcher:AddShort(value, canRemote)
end

---
---@param channel int
---@param value int
function DataWatcher:UpdateShort(channel, value)
end

---
---@param channel int
---@return int
function DataWatcher:GetShort(channel)
end

---
---@overload fun(value:int):int
---@param value int
---@param canRemote boolean
---@return int
function DataWatcher:AddInteger(value, canRemote)
end

---
---@param channel int
---@param value int
function DataWatcher:UpdateInteger(channel, value)
end

---
---@param channel int
---@return int
function DataWatcher:GetInteger(channel)
end

---
---@overload fun(value:boolean):int
---@param value double
---@param canRemote boolean
---@return int
function DataWatcher:AddDouble(value, canRemote)
end

---
---@param channel int
---@param value double
function DataWatcher:UpdateDouble(channel, value)
end

---
---@param channel int
---@return double
function DataWatcher:GetDouble(channel)
end

---
---@overload fun(value:string):int
---@param value string
---@param canRemote boolean
---@return int
function DataWatcher:AddString(value, canRemote)
end

---
---@param channel int
---@param value string
function DataWatcher:UpdateString(channel, value)
end

---
---@param channel int
---@return string
function DataWatcher:GetString(channel)
end

---
---@param value Inventory
---@return int
function DataWatcher:AddInventory(value)
end

---
---@param channel int
---@param value Inventory
function DataWatcher:UpdateInventory(channel, value)
end

---
---@param channel int
---@return Inventory
function DataWatcher:GetInventory(channel)
end

return DataWatcher
