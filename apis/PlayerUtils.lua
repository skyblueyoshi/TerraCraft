---@class PlayerUtils
local PlayerUtils = {}

---@return Player
function PlayerUtils.GetCurrentClientPlayer()
end

---Get
---@param entityIndex EntityIndex
---@return Player
function PlayerUtils.Get(entityIndex)
end

---IsAlive
---@param entityIndex EntityIndex
---@return boolean
function PlayerUtils.IsAlive(entityIndex)
end

--WeaponCollide
---@overload fun(itemStack:ItemStack,hitAngle:double,obb:ObbDouble,attackInAndOut:Attack,outPlayerIndex:EntityIndex):boolean
---@param itemStack ItemStack
---@param hitAngle double
---@param obb ObbDouble
---@param attackInAndOut Attack
---@param ignorePlayerIndex EntityIndex
---@param outPlayerIndex EntityIndex
---@return boolean
function PlayerUtils.WeaponCollide(itemStack, hitAngle, obb, attackInAndOut, ignorePlayerIndex, outPlayerIndex)
end

---SearchByRect
---@param x double
---@param y double
---@param width int
---@param height int
---@return Player[]
function PlayerUtils.SearchByRect(x, y, width, height)
end

---SearchByCircle
---@param x double
---@param y double
---@param radius int
---@return Player[]
function PlayerUtils.SearchByCircle(x, y, radius)
end

---SearchNearestPlayer
---@param x double
---@param y double
---@param radius int
---@param noCrossTiles boolean
---@return Player
function PlayerUtils.SearchNearestPlayer(x, y, radius, noCrossTiles)
end

return PlayerUtils