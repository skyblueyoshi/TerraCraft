---@API

---@class Attack 表示一个攻击属性。
---@field attack int 伤害值。
---@field knockBack int 击退值。
---@field crit int 攻击的百分暴击率。1-100表示1-100%的概率产生双倍暴击伤害，大于100表示总是产生双倍暴击伤害，小于1表示不产生暴击伤害。
local Attack = {}

--- 创建一个攻击属性对象。
---@param attack int 伤害值。
---@param knockBack int 击退值。
---@param crit int 攻击的百分暴击率。
---@return Attack 新的攻击属性对象。
function Attack.new(attack, knockBack, crit)
end

--- 重置所有攻击属性数值。
function Attack:Restore()
end

return Attack
