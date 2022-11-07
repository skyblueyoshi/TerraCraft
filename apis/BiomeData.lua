---@class BiomeTerrain 描述一个地形信息
---@field name string 地形名称
---@field times double 生成次数（小于1表示概率）
---@field size int 地形大小（生成器参数）
---@field height int 地形高度（生成器参数）
local BiomeTerrain = {}

---@class BiomeTerrains 描述地形信息
---@field terrains BiomeTerrain[] 允许出现的所有地形
---@field specialTerrains BiomeTerrain[] 允许出现的特殊地形
---@field transition string 过渡方式（生成器参数）
---@field transitionTag int 过渡附加值（生成器参数）
local BiomeTerrains = {}

---@class BiomeLiquidInfo 描述湖泊信息
---@field liquidID int 液体ID
---@field maxAllowCount int 湖泊最多有多少格子的当前液体
local BiomeLiquidInfo = {}

---@class BiomeTreeInfo 描述树信息
---@field styles int[] 不同数目的方块id
---@field density double 种植密度（生成器参数）
local BiomeTreeInfo = {}

---@class BiomeMushroomInfo 描述巨型蘑菇信息
---@field styles int[] 不同数目的方块id
---@field density double 种植密度（生成器参数）
local BiomeMushroomInfo = {}

---@class BiomeData 描述一个群系信息
---@field biomeType int 群系类型
---@field scale double 群系大小（生成器参数，相对于perlin参考值）
---@field terrains BiomeTerrains 地形信息
---@field treeInfo BiomeTreeInfo 树信息
---@field mushroomInfo BiomeMushroomInfo 巨型蘑菇信息
---@field oreGroupName string 当前群系指定矿物名称批量生成矿物
local BiomeData = {}

return BiomeData