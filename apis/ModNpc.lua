---@class ModNpc
---@field npc Npc
---@field syncData table
local ModNpc = {}

--- This function is called once when the NPC is spawned.
---
--- NPC生成时调用一次该函数。
function ModNpc:Init()
end

---
---
--- NPC每帧运行Update()函数前调用，如果返回true则执行所有Update逻辑，返回false则不执行所有Update逻辑。可在该函数写入新的逻辑，并屏蔽原有逻辑。默认返回true。
---@return boolean
function ModNpc:CanUpdate()
    return true
end

--- Called when NPC runs every update tick, usually write logic in this function.
---
--- NPC每帧运行时调用，通常在该函数内编写运动等逻辑。
function ModNpc:Update()
end

--- Called before the NPC runs the `Update()` function every update tick.
--- It is usually used to insert new logic before the original logic.
---
--- NPC每帧运行`Update()`函数前调用。通常用于在原逻辑前插入新逻辑。
function ModNpc:PreUpdate()
end

--- Called after the NPC runs the `Update()` function every update tick.
--- It is usually used to insert new logic after the original logic.
---
--- NPC每帧运行`Update()`函数后调用。通常用于追加逻辑。
function ModNpc:PostUpdate()
end

---
---
--- NPC每帧绘制前调用，如果返回true则执行所有Draw逻辑，返回false则不执行所有Draw逻辑。可在该函数写入新的逻辑，并屏蔽原有逻辑。默认返回true。
---@return boolean
function ModNpc:CanDraw()
    return true
end

--- Called before each tick of NPC drawing,
--- just write custom drawing behavior in this function.
---
--- NPC每帧绘制前调用，在该函数内编写自定义绘制属性。
function ModNpc:OnDraw()
end

function ModNpc:OnRender()
end

--- Called when NPC was killed.
---
--- NPC死亡时调用一次该函数。
function ModNpc:OnKilled()
end

---ModifyHit
---@param attack Attack
---@return boolean
function ModNpc:ModifyHit(attack)
end

--- Called when NPC collides the tiles.
---
--- NPC与图块碰撞时调用该函数。
--- @param oldSpeedX double The X speed before colliding tiles. (击中图块前一帧的横向速度)
--- @param oldSpeedY double The Y speed before colliding tiles. (击中图块前一帧的纵向速度)
function ModNpc:OnTileCollide(oldSpeedX, oldSpeedY)
end

function ModNpc:OnLoot()
end

---@return table
function ModNpc:Save()
end

---Load
---@param tagTable table
function ModNpc:Load(tagTable)
end

return ModNpc