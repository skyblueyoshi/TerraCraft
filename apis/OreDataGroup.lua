---@class OreData
---@field oreID int 矿物的方块id
---@field density int 矿脉密度（每区块生成次数）
---@field radius int 矿脉半径
---@field startYi int 矿脉开始分布的Y值
---@field endYi int 矿脉结束分布的Y值
local OreData = {}

---@class OreDataGroup
---@field name string 矿物组名称
---@field dataList OreData[] 矿物列表
local OreDataGroup = {}

return OreDataGroup