---@API

---@class Advancement 描述一项成就。
---@field itemID int 成就使用的物品ID，用于在成就树界面显示物品图标。
---@field parentID int 成就在成就树的父成就ID。
---@field showTip boolean 玩家完成该成就时，是否在界面右上角弹出完成成就提示。
---@field broadcast boolean 玩家完成成就时，是否广播给所有人。
local Advancement = {}

return Advancement
