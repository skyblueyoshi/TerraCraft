---@class NpcUtils @NPC Util Module (NPC通用模块)
local NpcUtils = {}

---@return Npc[]
function NpcUtils.GetAllEntities()
end

---Get
---@param entityIndex EntityIndex
---@return Npc
function NpcUtils.Get(entityIndex)
end

---IsAlive
---@param entityIndex EntityIndex
---@return boolean
function NpcUtils.IsAlive(entityIndex)
end

---Create an NPC at the specified location and return the created NPC entity.
---
---在指定位置创建一个NPC，返回创建好的NPC实体。
---@overload fun(id:int,x:double,y:double):Npc
---@overload fun(id:int,x:double,y:double,speedX:double):Npc
---@param id int
---@param x double @The x coordinate (x坐标)
---@param y double @The y coordinate (y坐标)
---@param speedX double @[ default '0.0' ] (横向速度，默认0)
---@param speedY double @[ default '0.0' ] (纵向速度，默认0)
---@return Npc @创建好的NPC实体
function NpcUtils.Create(id, x, y, speedX, speedY)
end

---WeaponCollide
---@overload fun(itemStack:ItemStack,hitAngle:double,obb:ObbDouble,attackInAndOut:Attack,outNpcIndex:EntityIndex):boolean
---@param itemStack ItemStack
---@param hitAngle double
---@param obb ObbDouble
---@param attackInAndOut Attack
---@param ignoreNpcIndex EntityIndex
---@param outNpcIndex EntityIndex
---@return boolean
function NpcUtils.WeaponCollide(itemStack, hitAngle, obb, attackInAndOut, ignoreNpcIndex, outNpcIndex)
end

---SearchByRect
---@param x double
---@param y double
---@param width int
---@param height int
---@return Npc[]
function NpcUtils.SearchByRect(x, y, width, height)
end

---SearchByCircle
---@param x double
---@param y double
---@param radius int
---@return Npc[]
function NpcUtils.SearchByCircle(x, y, radius)
end

---SearchNearestNpc
---@param x double
---@param y double
---@param radius int
---@param noCrossTiles boolean
---@return Npc
function NpcUtils.SearchNearestNpc(x, y, radius, noCrossTiles)
end

---SearchNearestEnemy
---@param x double
---@param y double
---@param radius int
---@param noCrossTiles boolean
---@return Npc
function NpcUtils.SearchNearestEnemy(x, y, radius, noCrossTiles)
end

return NpcUtils