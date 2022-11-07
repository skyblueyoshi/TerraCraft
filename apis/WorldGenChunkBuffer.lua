---@class WorldGenChunkBufferElement
---@field biomeType int
---@field biomeID int
---@field isFrontPreset boolean
---@field isWallPreset boolean
---@field isLiquidPreset boolean
---@field isFrontSettled boolean
---@field isWallSettled boolean
---@field isLiquidSettled boolean
---@field isGrassCoverPreset boolean
local WorldGenChunkBufferElement = {}

---@class WorldGenChunkBufferElementMask
---@field biomeType boolean
---@field biomeID boolean
---@field isFrontPreset boolean
---@field isWallPreset boolean
---@field isLiquidPreset boolean
---@field isFrontSettled boolean
---@field isWallSettled boolean
---@field isLiquidSettled boolean
---@field isGrassCoverPreset boolean
local WorldGenChunkBufferElementMask = {}

---@class WorldGenChunkBuffer
local WorldGenChunkBuffer = {}

---GetUnit
---@param xi int
---@param yi int
---@return WorldGenChunkBufferElement
function WorldGenChunkBuffer:GetUnit(xi, yi)
end

---GetSample
---@param id int
---@return WorldGenChunkBufferElement
function WorldGenChunkBuffer:GetSample(id)
end

---ClearSample
---@param id int
function WorldGenChunkBuffer:ClearSample(id)
end

---GetMask
---@param id int
---@return WorldGenChunkBufferElementMask
function WorldGenChunkBuffer:GetMask(id)
end

---ClearMask
---@param id int
function WorldGenChunkBuffer:ClearMask(id)
end

---ApplySampleByMask
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param sampleID int
---@param maskID int
function WorldGenChunkBuffer:ApplySampleByMask(xi, yi, wi, hi, sampleID, maskID)
end

---ApplySampleByMaskByCondition
---@overload fun(xi:int,yi:int,wi:int,hi:int,sampleID:int,maskID:int,conditionMaskID:int,conditionMaskID:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param sampleID int
---@param maskID int
---@param conditionSampleID int
---@param conditionMaskID int
---@param logicOR boolean
function WorldGenChunkBuffer:ApplySampleByMaskByCondition(xi, yi, wi, hi, sampleID, maskID, conditionSampleID, conditionMaskID, logicOR)
end

---HasAreaSameSampleByMask
---@overload fun(xi:int,yi:int,wi:int,hi:int,sampleID:int,maskID:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param sampleID int
---@param maskID int
---@param logicOR boolean
function WorldGenChunkBuffer:HasAreaSameSampleByMask(xi, yi, wi, hi, sampleID, maskID, logicOR)
end

---CreateAllPlaceableByBiomeType
---@overload fun(xi:int,yi:int,wi:int,hi:int,biomeType:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param biomeType int
---@param boundaryArrayID int
function WorldGenChunkBuffer:CreateAllPlaceableByBiomeType(xi, yi, wi, hi, biomeType, boundaryArrayID)
end

---IsAreaHasSolid
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@return boolean
function WorldGenChunkBuffer:IsAreaHasSolid(xi, yi, wi, hi)
end

---AddBoundaryArray
---@param boundaryArray int[]
---@return int
function WorldGenChunkBuffer:AddBoundaryArray(boundaryArray)
end

---UpdateBoundaryArray
---@param boundaryArrayID int
---@param boundaryArray int[]
function WorldGenChunkBuffer:UpdateBoundaryArray(boundaryArrayID, boundaryArray)
end

---@return WorldGenCode
function WorldGenChunkBuffer:GetCode()
end

---RunCodeArea
---@param xi int
---@param yi int
---@param wi int
---@param hi int
function WorldGenChunkBuffer:RunCodeArea(xi, yi, wi, hi)
end

---SetBiomeArea
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param biomeType int
---@param biomeID int
---@param isApplyFront boolean
---@param isApplyWall boolean
function WorldGenChunkBuffer:SetBiomeArea(xi, yi, wi, hi, biomeType, biomeID, isApplyFront, isApplyWall)
end

---SetBiomeIDAreaByBiomeType
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param biomeType int
---@param biomeID int
function WorldGenChunkBuffer:SetBiomeIDAreaByBiomeType(xi, yi, wi, hi, biomeType, biomeID)
end

---SetBiomeIDFromMatrixByBiomeType
---@param biomeType int
---@param matrixTable int[]
function WorldGenChunkBuffer:SetBiomeIDFromMatrixByBiomeType(biomeType, matrixTable)
end

function WorldGenChunkBuffer:PushAllSubBlocks()
end

---SetTile
---@overload fun(xi:int,yi:int,tileID:int,tag:int)
---@param xi int
---@param yi int
---@param tileID int
---@param tag int
---@param isAllowSlope boolean
function WorldGenChunkBuffer:SetTile(xi, yi, tileID, tag, isAllowSlope)
end

---SetTileArea
---@overload fun(xi:int,yi:int,wi:int,hi:int,tileID:int,tag:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param tileID int
---@param tag int
---@param isAllowSlope boolean
function WorldGenChunkBuffer:SetTileArea(xi, yi, wi, hi, tileID, tag, isAllowSlope)
end

---SetTileAreaByCondition
---@overload fun(xi:int,yi:int,wi:int,hi:int,tileID:int,tag:int,isAllowSlope:boolean,conditionSampleID:int,conditionMaskID:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param tileID int
---@param tag int
---@param isAllowSlope boolean
---@param conditionSampleID int
---@param conditionMaskID int
---@param logicOR boolean
function WorldGenChunkBuffer:SetTileAreaByCondition(xi, yi, wi, hi, tileID, tag, isAllowSlope, conditionSampleID, conditionMaskID, logicOR)
end

---SetWall
---@overload fun(xi:int,yi:int,wallID:int)
---@param xi int
---@param yi int
---@param wallID int
---@param isAllowSlope boolean
function WorldGenChunkBuffer:SetWall(xi, yi, wallID, isAllowSlope)
end

---SetWallArea
---@overload fun(xi:int,yi:int,wi:int,hi:int,wallID:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param wallID int
---@param isAllowSlope boolean
function WorldGenChunkBuffer:SetWallArea(xi, yi, wi, hi, wallID, isAllowSlope)
end

---SetWallAreaByCondition
---@overload fun(xi:int,yi:int,wi:int,hi:int,wallID:int,isAllowSlope:boolean,conditionSampleID:int,conditionMaskID:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param wallID int
---@param isAllowSlope boolean
---@param conditionSampleID int
---@param conditionMaskID int
---@param logicOR boolean
function WorldGenChunkBuffer:SetWallAreaByCondition(xi, yi, wi, hi, wallID, isAllowSlope, conditionSampleID, conditionMaskID, logicOR)
end

---SetLiquid
---@param xi int
---@param yi int
---@param liquidID int
---@param amount int
function WorldGenChunkBuffer:SetLiquid(xi, yi, liquidID, amount)
end

---SetLiquidArea
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param liquidID int
---@param amount int
function WorldGenChunkBuffer:SetLiquidArea(xi, yi, wi, hi, liquidID, amount)
end

---SetLiquidAreaByCondition
---@overload fun(xi:int,yi:int,wi:int,hi:int,liquidID:int,amount:int,conditionSampleID:int,conditionMaskID:int)
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param liquidID int
---@param amount int
---@param conditionSampleID int
---@param conditionMaskID int
---@param logicOR boolean
function WorldGenChunkBuffer:SetLiquidAreaByCondition(xi, yi, wi, hi, liquidID, amount, conditionSampleID, conditionMaskID, logicOR)
end

---ClearFront
---@param xi int
---@param yi int
function WorldGenChunkBuffer:ClearFront(xi, yi)
end

---ClearFrontArea
---@param xi int
---@param yi int
---@param wi int
---@param hi int
function WorldGenChunkBuffer:ClearFrontArea(xi, yi, wi, hi)
end

---
---@param xi int
---@param yi int
function WorldGenChunkBuffer:ClearWall(xi, yi)
end

---
---@param xi int
---@param yi int
---@param wi int
---@param hi int
function WorldGenChunkBuffer:ClearWallArea(xi, yi, wi, hi)
end

---
---@param xi int
---@param yi int
function WorldGenChunkBuffer:ClearFrontAndWall(xi, yi)
end

---
---@param xi int
---@param yi int
---@param wi int
---@param hi int
function WorldGenChunkBuffer:ClearFrontAndWallArea(xi, yi, wi, hi)
end

---ClearLiquid
---@param xi int
---@param yi int
function WorldGenChunkBuffer:ClearLiquid(xi, yi)
end

---ClearLiquidArea
---@param xi int
---@param yi int
---@param wi int
---@param hi int
function WorldGenChunkBuffer:ClearLiquidArea(xi, yi, wi, hi)
end

---PerlinMakeCaveHorizontal
---@param xi int
---@param yi int
---@param size int
---@param height int
---@param scaleX double
---@param persistence double
---@param octaves int
---@param amplitude double
---@param scaleXTop double
---@param persistenceTop double
---@param octavesTop int
---@param amplitudeTop double
---@param scaleXBottom double
---@param persistenceBottom double
---@param octavesBottom int
---@param amplitudeBottom double
function WorldGenChunkBuffer:PerlinMakeCaveHorizontal(xi, yi, size, height, scaleX, persistence, octaves, amplitude, scaleXTop, persistenceTop, octavesTop, amplitudeTop, scaleXBottom, persistenceBottom, octavesBottom, amplitudeBottom)
end

---PerlinMakeCave
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param scaleX double
---@param scaleY double
---@param caveRateBegin double
---@param caveRateEnd double
---@param mapYiFadeIn int
---@param fadeInSize int
---@param mapYiFadeOut int
---@param fadeOutSize int
function WorldGenChunkBuffer:PerlinMakeCave(xi, yi, wi, hi, scaleX, scaleY, caveRateBegin, caveRateEnd, mapYiFadeIn, fadeInSize, mapYiFadeOut, fadeOutSize)
end

---MakeCaveRandomDirection
---@param xi int
---@param yi int
function WorldGenChunkBuffer:MakeCaveRandomDirection(xi, yi)
end

---GetRandomAreas
---@param randomKey int
---@param originalWorldGenArea WorldGenArea
---@param elementWidthMin int
---@param elementWidthMax int
---@param elementHeightMin int
---@param elementHeightMax int
---@param density double
function WorldGenChunkBuffer:GetRandomAreas(randomKey, originalWorldGenArea, elementWidthMin, elementWidthMax, elementHeightMin, elementHeightMax, density)
end

---AddBlockRandomOval
---@overload fun(blockID:int,xi:int,yi:int,wi:int,hi:int)
---@overload fun(blockID:int,xi:int,yi:int,wi:int,hi:int,replaceFront:boolean)
---@overload fun(blockID:int,xi:int,yi:int,wi:int,hi:int,replaceFront:boolean,replaceLiquid:boolean)
---@overload fun(blockID:int,xi:int,yi:int,wi:int,hi:int,replaceFront:boolean,replaceLiquid:boolean,placeFrontAir:boolean)
---@overload fun(blockID:int,xi:int,yi:int,wi:int,hi:int,replaceFront:boolean,replaceLiquid:boolean,placeFrontAir:boolean,replaceWall:boolean)
---@param blockID int
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@param replaceFront boolean
---@param replaceLiquid boolean
---@param placeFrontAir boolean
---@param replaceWall boolean
---@param placeWallAir boolean
function WorldGenChunkBuffer:AddBlockRandomOval(blockID, xi, yi, wi, hi, replaceFront, replaceLiquid, placeFrontAir, replaceWall, placeWallAir)
end

---GenerateLake
---@overload fun(xi:int, yi:int, liquidID:int)
---@param xi int
---@param yi int
---@param liquidID int
---@param maxAllowCount int
---@return boolean
function WorldGenChunkBuffer:GenerateLake(xi, yi, liquidID, maxAllowCount)
end

---写入所有元素。
---
---（1）对于所有预设的前景，根据群系、主次方块信息加入方块，并标记已经放置前景。
---（2）对于所有预设的后景，根据群系、主次方块信息加入方块，并标记已经放置后景。
---（3）对于所有预设的流体，按流体ID加入流体，并标记已经放置流体。
function WorldGenChunkBuffer:SettleAllElementByBiomes()
end

---GetAllFloors
---@param xi int
---@param yi int
---@param wi int
---@param hi int
---@return MapPos[]
function WorldGenChunkBuffer:GetAllFloors(xi, yi, wi, hi)
end

---GenerateTree
---@param xi int
---@param yi int
---@param treeBlockID int
---@return boolean
function WorldGenChunkBuffer:GenerateTree(xi, yi, treeBlockID)
end

---GenerateLargeMushroom
---@param xi int
---@param yi int
---@param capID int
---@param stemID int
---@return boolean
function WorldGenChunkBuffer:GenerateLargeMushroom(xi, yi, capID, stemID)
end

---CreateBuilding
---@overload fun(buildingID:int, xi:int, yi:int)
---@overload fun(buildingID:int, xi:int, yi:int, maxTryTimes:int)
---@overload fun(buildingID:int, xi:int, yi:int, limitXi:int, limitYi:int, limitWi:int, limitHi:int)
---@param buildingID int
---@param xi int
---@param yi int
---@param limitXi int
---@param limitYi int
---@param limitWi int
---@param limitHi int
---@param maxTryTimes int
function WorldGenChunkBuffer:CreateBuilding(buildingID, xi, yi, limitXi, limitYi, limitWi, limitHi, maxTryTimes)
end

function WorldGenChunkBuffer:ApplyBuildings()
end

return WorldGenChunkBuffer