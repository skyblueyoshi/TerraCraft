---@API

---@class JsonUtil Json通用类。
local JsonUtil = {}

---将一个lua表序列化为json字符串。
---@param t table
---@return string
function JsonUtil.toJson(t)
end

---将一个json字符串反序列化为lua表。
---@param json string
---@return table
function JsonUtil.fromJson(json)
end

return JsonUtil