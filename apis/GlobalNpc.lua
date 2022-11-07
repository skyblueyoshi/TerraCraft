---@class GlobalNpc
---@field npc Npc
local GlobalNpc = {}

--- This function is called once when the NPC is spawned.
---
--- NPC生成时调用一次该函数。
function GlobalNpc:Init()
end

---
---
--- NPC每帧运行Update()函数前调用，如果返回true则执行所有Update逻辑，返回false则不执行所有Update逻辑。可在该函数写入新的逻辑，并屏蔽原有逻辑。默认返回true。
---@return boolean
function GlobalNpc:CanUpdate()
    return true
end

--- Called when NPC runs every update tick, usually write logic in this function.
---
--- NPC每帧运行时调用，通常在该函数内编写运动等逻辑。
function GlobalNpc:Update()
end

--- Called before the NPC runs the `Update()` function every update tick.
--- It is usually used to insert new logic before the original logic.
---
--- NPC每帧运行`Update()`函数前调用。通常用于在原逻辑前插入新逻辑。
function GlobalNpc:PreUpdate()
end

--- Called after the NPC runs the `Update()` function every update tick.
--- It is usually used to insert new logic after the original logic.
---
--- NPC每帧运行`Update()`函数后调用。通常用于追加逻辑。
function GlobalNpc:PostUpdate()
end

--- If the NPC has a skeleton model,
--- it is called after `PostUpdate()` to process the logic of the custom skeleton model.
--- After executing this function, all joints of the skeleton model will be recalculated.
---
--- 若NPC拥有骨骼模型，每帧执行完`PostUpdate()`后调用，用于处理自定义骨骼模型逻辑。
--- 执行完该函数后，会对所有骨骼模型关节重新计算。
--- @param skeleton Skeleton Represents the skeleton model of the current NPC. (当前NPC的骨骼模型)
function GlobalNpc:UpdateSkeleton(skeleton)
end

--- Called before the NPC runs the `UpdateSkeleton(skeleton)` function every update tick.
--- It is usually used to insert new logic before the original logic.
---
--- NPC每帧运行`UpdateSkeleton(skeleton)`函数前调用。通常用于在原逻辑前插入新逻辑。
--- @param skeleton Skeleton Represents the skeleton model of the current NPC. (当前NPC的骨骼模型)
function GlobalNpc:PreUpdateSkeleton(skeleton)
end

--- Called after the NPC runs the `UpdateSkeleton(skeleton)` function every update tick.
--- It is usually used to insert new logic after the original logic.
---
--- NPC每帧运行`UpdateSkeleton(skeleton)`函数后调用。通常用于在原逻辑后追加新逻辑。
--- @param skeleton Skeleton Represents the skeleton model of the current NPC. (当前NPC的骨骼模型)
function GlobalNpc:PostUpdateSkeleton(skeleton)
end

---
---
--- NPC每帧绘制前调用，如果返回true则执行所有Draw逻辑，返回false则不执行所有Draw逻辑。可在该函数写入新的逻辑，并屏蔽原有逻辑。默认返回true。
---@return boolean
function GlobalNpc:CanDraw()
    return true
end

--- Called before each tick of NPC drawing,
--- just write custom drawing behavior in this function.
---
--- NPC每帧绘制前调用，在该函数内编写自定义绘制属性。
function GlobalNpc:OnDraw()
end

--- Called when NPC was killed.
---
--- NPC死亡时调用一次该函数。
function GlobalNpc:OnKilled()
end

--- Called when NPC collides the tiles.
---
--- NPC与图块碰撞时调用该函数。
--- @param oldSpeedX double The X speed before colliding tiles. (击中图块前一帧的横向速度)
--- @param oldSpeedY double The Y speed before colliding tiles. (击中图块前一帧的纵向速度)
function GlobalNpc:OnTileCollide(oldSpeedX, oldSpeedY)
end

function GlobalNpc:OnLoot()
end

---@return table
function GlobalNpc:Save()
end

---Load
---@param tagTable table
function GlobalNpc:Load(tagTable)
end

return GlobalNpc