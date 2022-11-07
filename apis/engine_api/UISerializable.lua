---@class UISerializable
local UISerializable = {}

---ToDesignString
---@param uiNode UINode
---@return string
function UISerializable.toDesignString(uiNode)
end

---LoadDesignString
---@param designString string
---@return UINode
function UISerializable.loadDesignString(designString)
end

---ToBinary
---@param uiNode UINode
---@return Bytes
function UISerializable.toBinary(uiNode)
end

---LoadBinary
---@param bytes Bytes
---@param offset number
---@param size number
---@return UINode
function UISerializable.loadBinary(bytes, offset, size)
end

return UISerializable