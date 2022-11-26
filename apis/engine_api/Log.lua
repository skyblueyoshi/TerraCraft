---@API

---@class Log 日志类。
local Log = {}

---输出一条信息日志。
---@param msg string
function Log.info(msg)
end

---输出一条警告日志。
---@param msg string
function Log.warn(msg)
end

---输出一条崩溃日志。
---@param msg string
function Log.fatal(msg)
end

---输出一条错误日志。
---@param msg string
function Log.error(msg)
end

---输出一条调试日志。
---@param msg string
function Log.debug(msg)
end

return Log