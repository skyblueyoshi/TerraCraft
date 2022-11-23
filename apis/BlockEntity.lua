---@API

---@class BlockEntity
---@field id int
---@field xi int
---@field yi int
---@field dataWatcher DataWatcher
local BlockEntity = {}

---SetAnimation
---@param animationIndex int
function BlockEntity:SetAnimation(animationIndex)
end

---GetAnimation
---@return int
function BlockEntity:GetAnimation()
end

---GetModBlockEntity
---@return ModBlockEntity
function BlockEntity:GetModBlockEntity()
end

return BlockEntity