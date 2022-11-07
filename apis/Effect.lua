---@class Effect:Entity
---@field decSpeed double
---@field decScale double
---@field decAlpha double
---@field decRotateSpeed double
---@field scale double
---@field alpha double
---@field rotateSpeed double
---@field gravity boolean
---@field lightAlpha int
---@field lightRed int
---@field lightGreen int
---@field lightBlue int
---@field disappearTime int
local Effect = {}

---SetDisappearTime
---@param disappearTime int
function Effect:SetDisappearTime(disappearTime)
end

--- Destroy the current effect object.
---
--- 清除当前抛射物对象。
function Effect:Kill()
end

--- If the player owner exists and is alive, return the player, otherwise return nil.
---
--- 若玩家拥有者存在且存活，返回该玩家，否则返回nil。
---@return Player|nil
function Effect:GetPlayerOwner()
end

--- If the npc owner exists and is alive, return the npc, otherwise return nil.
---
--- 若NPC拥有者存在且存活，返回该NPC，否则返回nil。
---@return Npc|nil
function Effect:GetNpcOwner()
end

--- If the player target exists and is alive, return the player, otherwise return nil.
---
--- 若当前抛射物的玩家锁定目标存在且存活，返回该玩家，否则返回nil。
---@return Player|nil
function Effect:GetPlayerTarget()
end

--- If the npc target exists and is alive, return the npc, otherwise return nil.
---
--- 若当前抛射物的NPC锁定目标存在且存活，返回该NPC，否则返回nil。
---@return Npc|nil
function Effect:GetNpcTarget()
end

--- Set the locked player target of the current effect.
---
--- 设定当前抛射物的锁定玩家目标。
---@return Player|nil
function Effect:SetPlayerTarget(player)
end

--- Set the locked NPC target of the current effect.
---
--- 设定当前抛射物的锁定NPC目标。
---@return Npc|nil
function Effect:SetNpcTarget(npc)
end

return Effect