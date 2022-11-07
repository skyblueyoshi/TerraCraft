---@class ModBlockEntity
---@field blockEntity BlockEntity
local ModBlockEntity = {}

function ModBlockEntity:OnPlaced()
end

function ModBlockEntity:Init()
end

function ModBlockEntity:CanUpdate()
end

function ModBlockEntity:Update()
end

---OnKilled
---@param parameterDestroy ParameterDestroy
function ModBlockEntity:OnKilled(parameterDestroy)
end

---OnClicked
---@param parameterClick ParameterClick
function ModBlockEntity:OnClicked(parameterClick)
end

function ModBlockEntity:OnActivated(isActive)
end

---@return table
function ModBlockEntity:Save()
end

---Load
---@param tagTable table
function ModBlockEntity:Load(tagTable)
end

return ModBlockEntity