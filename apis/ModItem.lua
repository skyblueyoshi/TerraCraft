---@class ModItem
---@field itemStack ItemStack
local ModItem = {}

function ModItem:Init()
end

---DrawIcon
---@param position Vector2
---@param color Color
---@param spriteExData SpriteExData
function ModItem:DrawIcon(position, color, spriteExData)
end

---OnHeld
---@param player Player
function ModItem:OnHeld(player)
end

---OnHeldRender
---@param player Player
function ModItem:OnHeldRender(player)
end

---OnUsed
---@param player Player
function ModItem:OnUsed(player)
end

---CanUse
---@param player Player
---@return boolean
function ModItem:CanUse(player)
end

---OnHeldByNpc
---@param npc Npc
function ModItem:OnHeldByNpc(npc)
end

---OnUsedByNpc
---@param npc Npc
function ModItem:OnUsedByNpc(npc)
end

---ModifyHitNpc
---@param npc Npc
---@param baseAttack Attack
---@return boolean
function ModItem:ModifyHitNpc(npc, baseAttack)
end

---ModifyHitPlayer
---@param player Player
---@param baseAttack Attack
---@return boolean
function ModItem:ModifyHitPlayer(player, baseAttack)
end

---Load
---@param tagTable table
function ModItem:Load(tagTable)
end

---@return table
function ModItem:Save()
end

return ModItem