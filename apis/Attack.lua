-- Document
-- Attack Class: https://blueyoshi.gitbook.io/terracraft/en/mod/api/type#attack
--
-- Attack类: https://blueyoshi.gitbook.io/terracraft/cn/mod/api/type#attack
--
-- Copyright (c) 2021. BlueYoshi(blueyoshi@foxmail.com)

---@class Attack Represents a attack property. (表示一个攻击属性)
---@field public attack int The damge value. (伤害值)
---@field public knockBack int The value of knock back. (击退值)
---@field public crit int Percent crit rate of the attack. 1-100 means that there is a 1-100% probability of double crit damage, greater than 100 means always double crit damage, and less than 1 means no crit damage. (攻击的百分暴击率。1-100表示1-100%的概率产生双倍暴击伤害，大于100表示总是产生双倍暴击伤害，小于1表示不产生暴击伤害。)
local Attack = {}


--- Creates and returns a Attack class.
---
--- 创建一个Attack类。
---@param attack int
---@param knockBack int
---@param attack int
---@return Attack
function Attack.new(attack, knockBack, crit)
end

function Attack:Restore()
end

return Attack