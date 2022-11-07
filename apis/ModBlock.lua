---@class ModBlock
local ModBlock = {}

---OnPlayerCollide
---@param xi int
---@param yi int
---@param player Player
---@param collisionDirection int
function ModBlock.OnPlayerCollide(xi, yi, player, collisionDirection)
end

---OnPlayerOverlap
---@param xi int
---@param yi int
---@param player Player
function ModBlock.OnPlayerOverlap(xi, yi, player)
end

---UpdateScreen
---@param xi int
---@param yi int
---@param tickTime int
function ModBlock.UpdateScreen(xi, yi, tickTime)
end

---RenderFurniture
---@param xi int
---@param yi int
---@param tickTime int
function ModBlock.RenderFurniture(xi, yi, tickTime)
end

---PreRenderFurniture
---@param xi int
---@param yi int
---@param tickTime int
function ModBlock.PreRenderFurniture(xi, yi, tickTime)
end

---PostRenderFurniture
---@param xi int
---@param yi int
---@param tickTime int
function ModBlock.PostRenderFurniture(xi, yi, tickTime)
end

---OnRandomTick
---@param xi int
---@param yi int
function ModBlock.OnRandomTick(xi, yi)
end

---OnPlaced
---@param xi int
---@param yi int
function ModBlock.OnPlaced(xi, yi)
end

---OnClicked
---@param xi int
---@param yi int
---@param parameterClick ParameterClick
function ModBlock.OnClicked(xi, yi, parameterClick)
end

---OnSignal
---@param xi int
---@param yi int
---@param isActivated boolean
function ModBlock.OnSignal(xi, yi, isActivated)
end

---OnDestroy
---@param xi int
---@param yi int
---@param parameterDestroy ParameterDestroy
function ModBlock.OnDestroy(xi, yi, parameterDestroy)
end

return ModBlock