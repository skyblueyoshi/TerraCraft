---@class GlobalPlayer
---@field player Player
local GlobalPlayer = {}

function GlobalPlayer:Awake()
end

--- This function is called once when the player is spawned.
---
--- 玩家生成时调用一次该函数。
function GlobalPlayer:Init()
end

---
---
--- 玩家每帧运行Update()函数前调用，如果返回true则执行所有Update逻辑，返回false则不执行所有Update逻辑。可在该函数写入新的逻辑，并屏蔽原有逻辑。默认返回true。
---@return boolean
function GlobalPlayer:CanUpdate()
    return true
end

function GlobalPlayer:Motion()
end

--- Called when player runs every update tick, usually write logic in this function.
---
--- 玩家每帧运行时调用，通常在该函数内编写运动等逻辑。
function GlobalPlayer:Update()
end

--- Called before the player runs the `Update()` function every update tick.
--- It is usually used to insert new logic before the original logic.
---
--- 玩家每帧运行`Update()`函数前调用。通常用于在原逻辑前插入新逻辑。
function GlobalPlayer:PreUpdate()
end

--- Called after the player runs the `Update()` function every update tick.
--- It is usually used to insert new logic after the original logic.
---
--- 玩家每帧运行`Update()`函数后调用。通常用于追加逻辑。
function GlobalPlayer:PostUpdate()
end

--- If the player has a skeleton model,
--- it is called after `PostUpdate()` to process the logic of the custom skeleton model.
--- After executing this function, all joints of the skeleton model will be recalculated.
---
--- 若玩家拥有骨骼模型，每帧执行完`PostUpdate()`后调用，用于处理自定义骨骼模型逻辑。
--- 执行完该函数后，会对所有骨骼模型关节重新计算。
--- @param skeleton Skeleton Represents the skeleton model of the current 玩家. (当前玩家的骨骼模型)
function GlobalPlayer:UpdateSkeleton(skeleton)
end

--- Called before the player runs the `UpdateSkeleton(skeleton)` function every update tick.
--- It is usually used to insert new logic before the original logic.
---
--- 玩家每帧运行`UpdateSkeleton(skeleton)`函数前调用。通常用于在原逻辑前插入新逻辑。
--- @param skeleton Skeleton Represents the skeleton model of the current 玩家. (当前玩家的骨骼模型)
function GlobalPlayer:PreUpdateSkeleton(skeleton)
end

--- Called after the player runs the `UpdateSkeleton(skeleton)` function every update tick.
--- It is usually used to insert new logic after the original logic.
---
--- 玩家每帧运行`UpdateSkeleton(skeleton)`函数后调用。通常用于在原逻辑后追加新逻辑。
--- @param skeleton Skeleton Represents the skeleton model of the current 玩家. (当前玩家的骨骼模型)
function GlobalPlayer:PostUpdateSkeleton(skeleton)
end

---
---
--- 玩家每帧绘制前调用，如果返回true则执行所有Draw逻辑，返回false则不执行所有Draw逻辑。可在该函数写入新的逻辑，并屏蔽原有逻辑。默认返回true。
---@return boolean
function GlobalPlayer:CanDraw()
    return true
end

--- Called before each tick of player drawing,
--- just write custom drawing behavior in this function.
---
--- 玩家每帧绘制前调用，在该函数内编写自定义绘制属性。
function GlobalPlayer:OnDraw()
end

--- Called when player was killed.
---
--- 玩家死亡时调用一次该函数。
function GlobalPlayer:OnKilled()
end

function GlobalPlayer:OnRespawn()
end

--- Called when player collides the tiles.
---
--- 玩家与图块碰撞时调用该函数。
--- @param oldSpeedX double The X speed before colliding tiles. (击中图块前一帧的横向速度)
--- @param oldSpeedY double The Y speed before colliding tiles. (击中图块前一帧的纵向速度)
function GlobalPlayer:OnTileCollide(oldSpeedX, oldSpeedY)
end

function GlobalPlayer:OnRender()
end

function GlobalPlayer:RecalculateProperties()
end

---OnHitByNpc
---@param npc Npc
function GlobalPlayer:OnHitByNpc(npc)
end

---OnHitByProjectile
---@param projectile Projectile
function GlobalPlayer:OnHitByProjectile(projectile)
end

function GlobalPlayer:OnFirstTimeJoin()
end

function GlobalPlayer:OnInventoryChanged()
end

---OnInventoryItemAdded
---@param itemID int
---@param stackSize int
function GlobalPlayer:OnInventoryItemAdded(itemID, stackSize)
end

---OnInventoryItemRemoved
---@param itemID int
---@param stackSize int
function GlobalPlayer:OnInventoryItemRemoved(itemID, stackSize)
end

---OnAdvancementMade
---@param advancementID int
function GlobalPlayer:OnAdvancementMade(advancementID)
end

---OnAdvancementRemoved
---@param advancementID int
function GlobalPlayer:OnAdvancementRemoved(advancementID)
end

---@return table
function GlobalPlayer:Save()
end

---Load
---@param tagTable table
function GlobalPlayer:Load(tagTable)
end

---@return table
function GlobalPlayer:SaveCSC()
end

---@param tagTable table
function GlobalPlayer:LoadCSC(tagTable)
end

return GlobalPlayer