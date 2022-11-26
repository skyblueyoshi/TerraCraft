---@API

---@class SerializableType 可序列化类型。
local SerializableType = {}

---从json字符串中，反序列化得到数据。
---@param json string json字符串。
function SerializableType:fromJson(json)
end

---将当前数据序列化得到json字符串。
---@return string json字符串。
function SerializableType:toJson()
end

return SerializableType