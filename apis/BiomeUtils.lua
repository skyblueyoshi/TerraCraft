---@class BiomeUtils 生物群系通用类。
local BiomeUtils = {}

---由指定生物群系类型和在该生物群系类型的索引，返回生物群系数据。
---@param biomeTypeID int 生物群系类型。
---@param index int 在该生物群系类型的索引。
---@return int 生物群系数据。
function BiomeUtils.GetBiomeIDByType(biomeTypeID, index)
end

---返回指定生物群系类型的生物群系数量。
---@param biomeTypeID int 生物群系类型。
---@return int 指定生物群系类型的生物群系数量。
function BiomeUtils.GetBiomeCountByType(biomeTypeID)
end

---由生物群系ID，返回生物群系数据。
---@param biomeID int 生物群系ID。
---@return BiomeData 生物群系数据。
function BiomeUtils.GetData(biomeID)
end

return BiomeUtils
