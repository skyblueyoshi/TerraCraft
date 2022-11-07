---@class ProjectileUtils
local ProjectileUtils = {}

---Get
---@param entityIndex EntityIndex
---@return Projectile
function ProjectileUtils.Get(entityIndex)
end

---IsAlive
---@param entityIndex EntityIndex
---@return boolean
function ProjectileUtils.IsAlive(entityIndex)
end

---@overload fun(id:int,x:double,y:double):Projectile
---@overload fun(id:int,x:double,y:double,speedX:double):Projectile
---@overload fun(id:int,x:double,y:double,speedX:double,speedY:double):Projectile
---@param id int
---@param x double
---@param y double
---@param speedX double
---@param speedY double
---@param attack Attack
---@return Projectile
function ProjectileUtils.Create(id, x, y, speedX, speedY, attack)
end

---@overload fun(player:Player,id:int,x:double,y:double):Projectile
---@overload fun(player:Player,id:int,x:double,y:double,speedX:double):Projectile
---@overload fun(player:Player,id:int,x:double,y:double,speedX:double,speedY:double):Projectile
---@param player Player
---@param id int
---@param x double
---@param y double
---@param speedX double
---@param speedY double
---@param attack Attack
---@return Projectile
function ProjectileUtils.CreateFromPlayer(player, id, x, y, speedX, speedY, attack)
end

---@overload fun(npc:Npc,id:int,x:double,y:double):Projectile
---@overload fun(npc:Npc,id:int,x:double,y:double,speedX:double):Projectile
---@overload fun(npc:Npc,id:int,x:double,y:double,speedX:double,speedY:double):Projectile
---@param npc Npc
---@param id int
---@param x double
---@param y double
---@param speedX double
---@param speedY double
---@param attack Attack
---@return Projectile
function ProjectileUtils.CreateFromNpc(npc, id, x, y, speedX, speedY, attack)
end

return ProjectileUtils