---@class Projectile:Entity
---@field id int The dynamic ID of the current projectile. (当前抛射物的动态ID)
---@field entityIndex EntityIndex
---@field common ProjectileCommon The common data of current projectile. (当前抛射物的通用数据)
---@field baseAttack Attack The basic attack property of the current projectile. (当前抛射物的基础攻击属性)
---@field targetTime int The target time of the current projectile. It is generally given when it is created, and is usually used to trigger related logic after reaching the target time. (当前抛射物的目标时间。一般由创建时给定，通常用于实现达到目标时间后触发相关逻辑)
---@field isCheckNpc boolean @[ default `false` ] Whether the current projectile is acting on the NPC. It is generally specified when it is created, and determines whether to collide or damage NPCs. (当前抛射物是否作用于NPC。一般由创建时指定，决定是否碰撞、伤害NPC)
---@field isCheckPlayer boolean @[ default `false` ] Whether the current projectile is acting on the player. It is generally specified when it is created, and determines whether to collide or damage players. (当前抛射物是否作用于玩家。一般由创建时指定，决定是否碰撞、伤害玩家)
---@field state int The current state of the projectile in a simple finite state machine. (抛射物当前在简单有限状态机中的状态)
---@field stateTimer int The timer use for state machine. (抛射物的状态机计时器)
---@field playerTargetIndex EntityIndex
---@field npcTargetIndex EntityIndex
---@field special int
local Projectile = {}

--- Destroy the current projectile object.
---
--- 清除当前抛射物对象。
function Projectile:Kill()
end

return Projectile