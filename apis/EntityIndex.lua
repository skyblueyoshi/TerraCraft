---@class EntityIndex
---@field entityID int
---@field uniqueID int
local EntityIndex = {}

---@overload fun():EntityIndex
---@param entityID int
---@param uniqueID int
---@return EntityIndex
function EntityIndex.new(entityID, uniqueID)
end

return EntityIndex