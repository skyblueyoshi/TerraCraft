--- This is the main world generation code
---
--- 世界生成代码，有些复杂，英文中文注释都补上
---@class TC.ChunkGenerator
local ChunkGenerator = class("ChunkGenerator")
local TerrainProxies = require("TerrainProxies")
local SpecialTerrainProxies = require("SpecialTerrainProxies")
local TransitionProxies = require("TransitionProxies")
local ModChunkGenerator = require("ModChunkGenerator")
local Algorithm = require("util.Algorithm")
local WorldGenDefine = require("WorldGenDefine")

local BiomeType_Surface = Reg.BiomeTypeID("Surface")
local BiomeType_Underground = Reg.BiomeTypeID("Underground")
local BiomeType_Nether = Reg.BiomeTypeID("Nether")

local DEFAULT_SURFACE_BIOME_ID = Reg.BiomeID("forest")
local DEFAULT_UNDERGROUND_BIOME_ID = Reg.BiomeID("normal_cave")
local UNDERGROUND_PERLIN_GEN_RATE = 0.36

local DEFAULT_UNDERGROUND_BIOME_AREAS = {
    { 0, 1024, Reg.BiomeID("normal_cave") },
    { 1024, 1536, Reg.BiomeID("mud_cave") },
    { 1536, 2048, Reg.BiomeID("stone_cave") },
    { 2048, 2176, Reg.BiomeID("lava_cave") },
    { 2176, 2560, Reg.BiomeID("magma_cave") },
}

-- ========================================
-- AIR                        空气层
-- ========================================
-- SURFACE                    地表层
-- ========================================
-- UNDERGROUND                地下层
-- ----------------------------------------
-- DIRT/MUD                   (地下泥土层)
-- ----------------------------------------
-- STONE                      (地下岩石层)
-- ----------------------------------------
-- LAVA ZONE                  (地下熔岩层)
-- ========================================
-- NETHER                     地狱层
-- ========================================
-- TWILIGHT FOREST            暮色森林层
-- ========================================

local SURFACE_LINE = WorldGenDefine.SURFACE_LINE
local UNDERGROUND_LINE = WorldGenDefine.UNDERGROUND_LINE
local NETHER_LINE = WorldGenDefine.NETHER_LINE
local NETHER_LAVA_LINE = WorldGenDefine.NETHER_LAVA_LINE
local NETHER_LAVE_CAVE_HEIGHT = WorldGenDefine.NETHER_LAVE_CAVE_HEIGHT
local UNDERGROUND_LAKE_LINE = WorldGenDefine.UNDERGROUND_LAKE_LINE
local BEDROCK_CHUNK_YI = WorldGenDefine.BEDROCK_CHUNK_YI

---__init
---@param chunkXi int
---@param chunkYi int
---@param noise WorldGenNoise
---@param buffer WorldGenChunkBuffer
function ChunkGenerator:__init(chunkXi, chunkYi, noise, buffer)
    self.chunkXi = chunkXi
    self.chunkYi = chunkYi
    self.chunkXiInMap = self.chunkXi * 1024
    self.chunkYiInMap = self.chunkYi * 1024
    self.noise = noise
    self.buffer = buffer

    self.isBedrockOnly = false

    self.isGenSurface = false
    self.isGenUnderground = false
    self.isGenNether = false
    self.isGenTwilightForest = false

    -- surface cache
    self.surfaceBiomeID = 0
    self.surfaceBiomeID_Left = 0
    self.surfaceBiomeID_Right = 0

    local function _initMatrix(size, value)
        local temp = {}
        for i = 1, size * size do
            temp[i] = value
        end
        return temp
    end

    -- underground cache
    -- 34x34 matrix, 1-32: in current chunk, 0,33: adjust chunk
    self.undergroundBiomeIDMatrix = _initMatrix(34)

    local function _initBoundary(precise)
        local temp = {}
        if precise then
            for i = 1, 1024 do
                temp[i] = 0.0
            end
        else
            for i = 1, 1024 do
                temp[i] = 0
            end
        end
        return temp
    end

    -- All boundary array are using world coordinate system,
    -- you need to sub chunkYiInMap to get position in chunk coordinate system.
    --
    -- 分界线数组都使用世界坐标系，你需要减掉chunkYiInMap来得到区间坐标系
    self.surfacePreciseBoundary = _initBoundary(true)
    self.surfaceBoundary = _initBoundary(false)
    self.undergroundBoundary = _initBoundary(false)
    self.netherBoundary = _initBoundary(false)

    self.surfaceBiomeIDArray = _initBoundary(false)

    self.surfaceBoundaryID = 0
    self.undergroundBoundaryID = 0

    self.terrainProxies = TerrainProxies.new()
    self.specialTerrainProxies = SpecialTerrainProxies.new(buffer, noise, self.chunkYiInMap)
    self.transitionProxies = TransitionProxies.new(chunkXi, chunkYi, noise, buffer)

    self._pendingSortableBuildingList = {}

    self._modChunkGenerators = {} ---@type TC.ModChunkGenerator[]
    for _, c in ipairs(ModChunkGenerator.getProxy()) do
        local instance = c.new(self)
        table.insert(self._modChunkGenerators, instance)
    end

end

function ChunkGenerator:start()
    local timeDiff = TimeDiff.new()

    print("==> Init Layer")
    self:initLayer()

    print("==> Calculate Layer Boundary")
    self:calculateLayerBoundary()

    print("==> Process Layer")
    self:processLayer()

    print("==> Put Sub Blocks")
    self:putSubBlocks()

    print("==> Generate Sub Biomes")
    self:generateSubBiomes()

    print("==> Generate Caves")
    self:generateCaves()

    print("==> Generate Special Group")
    self:generateSpecialGroup()

    print("==> Generate Special Terrains")
    self:generateSpecialTerrains()

    print("==> Generate Underground Lake")
    self:generateUnderLake()

    self:generateSurfaceGrassCover()

    print("==> Settle All Element By Biomes")
    self.buffer:SettleAllElementByBiomes()

    print("==> Generate Ores")
    self:generateOres()

    print("==> Generate Trees")
    self:generateTrees()

    print("==> Generate Mushrooms")
    self:generateMushrooms()

    print("==> Generate Placeable")
    self:generatePlaceable()

    print("==> Generate Cobwebs")
    self:generateCobwebs()

    print("==> Generate Buildings")
    self:generateBuildings()

    if self.isBedrockOnly then
        return
    end

    print("==> Finish Chunk Generating in", timeDiff:diff(), "ms")

end

function ChunkGenerator:destroy()

end

--- decide what base layer will be generated (surface, underground, nether ...)
---
--- 决定哪些层会被生成。（比如地表、地下、地狱）
function ChunkGenerator:initLayer()
    if self.chunkYi >= BEDROCK_CHUNK_YI then
        self.isBedrockOnly = true
        return
    end
    if self.chunkYi == 0 then
        self.isGenSurface = true
        self.isGenUnderground = true
    elseif self.chunkYi == 1 then
        self.isGenUnderground = true
    elseif self.chunkYi == 2 then
        self.isGenUnderground = true
        self.isGenNether = true
    end

    for _, modChunkGenerator in ipairs(self._modChunkGenerators) do
        modChunkGenerator:onInitLayer()
    end
end

function ChunkGenerator:_getUndergroundYiAreaInChunk()
    if not self.isGenUnderground then
        return 0, 0
    end
    local yi = 0
    local yi2 = 1024
    if self.isGenSurface then
        yi = UNDERGROUND_LINE - self.chunkYiInMap
    end
    if self.isGenNether then
        yi2 = NETHER_LINE - self.chunkYiInMap
    end
    yi = math.min(1024, math.max(0, yi))
    yi2 = math.min(1024, math.max(yi, yi2))

    return yi, yi2 - yi
end

--- Save boundary data between every layers.
---
--- 计算层与层之间的边界。
function ChunkGenerator:calculateLayerBoundary()
    local max = math.max
    local min = math.min

    local defaultSurfaceBiomeID = DEFAULT_SURFACE_BIOME_ID
    local defaultUndergroundBiomeID = DEFAULT_UNDERGROUND_BIOME_ID

    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local surfacePreciseBoundary = self.surfacePreciseBoundary
    local surfaceBoundary = self.surfaceBoundary
    local undergroundBoundary = self.undergroundBoundary
    local netherBoundary = self.netherBoundary
    local noise = self.noise
    local buffer = self.buffer
    local mapXi = 0
    local perlinRes = 0
    noise:SetData(0.5, 8)

    if self.isGenSurface and self.isGenUnderground then
        -- Current chunk has boundary between surface and underground.
        -- 当前区块有地表层和地下层的分界线。
        for xi = 0, 1023 do
            mapXi = chunkXiInMap + xi
            -- surface line
            perlinRes = noise:Perlin1D(mapXi * 0.02)
            surfacePreciseBoundary[xi + 1] = SURFACE_LINE + perlinRes * 10.0
            -- underground line
            perlinRes = noise:Perlin1D(mapXi * 0.33)
            undergroundBoundary[xi + 1] = UNDERGROUND_LINE + perlinRes * 8.0
        end

        self:_fixSurfaceBoundary()

        self:_genSurfaceBiomeIDInfo()
        self:_genSurfaceTerrains()

        self:_fixSurfaceBoundary()

        self.surfaceBoundaryID = buffer:AddBoundaryArray(self.surfaceBoundary)
        self.undergroundBoundaryID = buffer:AddBoundaryArray(self.undergroundBoundary)

        -- Apply boundary to buffer.
        -- 应用分界。
        for xi = 0, 1023 do
            local top = max(surfaceBoundary[xi + 1] - chunkYiInMap, 0)
            local bottom = min(undergroundBoundary[xi + 1] - chunkYiInMap, 1024)

            -- Surface layer
            buffer:SetBiomeArea(xi, top, 1, bottom - top,
                    BiomeType_Surface, defaultSurfaceBiomeID,
                    true, true)

            -- Underground layer
            buffer:SetBiomeArea(xi, bottom, 1, 1024 - bottom,
                    BiomeType_Underground, defaultUndergroundBiomeID,
                    true, true)
        end
    elseif self.isGenUnderground and self.isGenNether then
        -- Current chunk has boundary between underground and nether.
        -- 当前区块有地下层和地狱的分界线。
        local netherBiomeID = Reg.BiomeID("nether")

        for xi = 0, 1023 do
            mapXi = chunkXiInMap + xi
            perlinRes = noise:Perlin1D(mapXi * 0.125)
            netherBoundary[xi + 1] = math.floor(NETHER_LINE + perlinRes * 20.0)
        end

        for xi = 0, 1023 do
            local bottom = min(netherBoundary[xi + 1] - chunkYiInMap, 1024)

            -- Underground layer
            buffer:SetBiomeArea(xi, 0, 1, bottom,
                    BiomeType_Underground, defaultUndergroundBiomeID,
                    true, true
            )

            -- Nether layer
            buffer:SetBiomeArea(xi, bottom, 1, 1024 - bottom,
                    BiomeType_Nether, netherBiomeID,
                    true, true
            )
        end

    elseif self.isGenUnderground then
        -- Underground layer only, there is no boundary in current chunk.
        -- 只有地下层，没有分界线。
        buffer:SetBiomeArea(0, 0, 1024, 1024,
                BiomeType_Underground, defaultUndergroundBiomeID,
                true, true)
    end
end

function ChunkGenerator:_fixSurfaceBoundary()
    local surfacePreciseBoundary = self.surfacePreciseBoundary
    local surfaceBoundary = self.surfaceBoundary
    local floor = math.floor
    -- Transform to real surface boundary data. (double -> int)
    for xi = 0, 1023 do
        -- floor(a + 0.5) => round(a)
        surfaceBoundary[xi + 1] = floor(surfacePreciseBoundary[xi + 1] + 0.5)
    end
end

function ChunkGenerator:_genSurfaceBiomeIDInfo()
    local noise = self.noise
    noise:SetData(0.5, 8)
    for i = -1, 1 do
        local checkChunkXi = self.chunkXi + i
        local biomeID = self:getSurfaceMainBiomeID(checkChunkXi)
        if i == 0 then
            self.surfaceBiomeID = biomeID
        elseif i == -1 then
            self.surfaceBiomeID_Left = biomeID
        else
            self.surfaceBiomeID_Right = biomeID
        end
    end
    local surfaceBiomeID = self.surfaceBiomeID
    for xi = 0, 1023 do
        self.surfaceBiomeIDArray[xi + 1] = surfaceBiomeID
    end
end

function ChunkGenerator:_genSurfaceTerrains()
    local abs = math.abs
    local floor = math.floor
    local ceil = math.ceil
    local noise = self.noise
    local chunkXi = self.chunkXi
    local chunkYi = self.chunkYi
    local terrainProxies = self.terrainProxies
    local surfacePreciseBoundary = self.surfacePreciseBoundary

    noise:SetData(0.5, 8)

    local biomeData = BiomeUtils.GetData(self.surfaceBiomeID)
    local terrains = biomeData.terrains.terrains

    -- add terrains, just modify boundary array.
    -- 添加地形，只是修改边界数组的数据。
    for i = 1, terrains.count do
        local terrain = terrains[i]
        local terrainTimes = terrain.times

        local times = 0
        if terrainTimes < 1 then
            -- less than 1, use possibility
            -- 小于1就使用概率
            local ranRate = noise:GetDoubleFromInt1D(chunkXi * 7 + terrain.size * 13 + terrain.height * 7)
            if abs(ranRate) < terrainTimes then
                times = 1
            end
        else
            times = ceil(terrainTimes)
        end

        if times > 0 then
            for j = 1, times do
                local terrainName = terrain.name
                local locateRateX = abs(noise:GetDoubleFromInt2D(terrain.size + j, chunkYi * 7 + j + terrain.height))
                local xi = floor(locateRateX * 1024)
                terrainProxies:calculateBoundaryFromTerrain(terrainName, surfacePreciseBoundary, xi, terrain.size, terrain.height)
            end
        end
    end
end

--- Write biome data into buffer for every layer.
---
--- 根据不同层，初步填入群系数据。
function ChunkGenerator:processLayer()
    if self.isBedrockOnly then
        self:_genBedrockLayer()
        return
    end
    if self.isGenSurface then
        self:_genSurfaceBiomes()
    end
    if self.isGenUnderground then
        self:_genUndergroundBiomes()
    end
    if self.isGenNether then
        self:_genNetherBiomes()
    end
end

function ChunkGenerator:_genBedrockLayer()
end

--- Write surface biome data into buffer.
---
--- 保存地表群落数据到缓冲区。
function ChunkGenerator:_genSurfaceBiomes()
    local leftTransition
    local rightTransition
    local currentTransition = BiomeUtils.GetData(self.surfaceBiomeID).terrains.transition
    if self.surfaceBiomeID > self.surfaceBiomeID_Left then
        leftTransition = currentTransition
    end
    if self.surfaceBiomeID > self.surfaceBiomeID_Right then
        rightTransition = currentTransition
    end
    if leftTransition ~= nil or rightTransition ~= nil then
        self.transitionProxies:doTransition(leftTransition, rightTransition,
                0, 1024, self.surfaceBoundary, self.undergroundBoundary,
                {
                    { BiomeType_Surface, self.surfaceBiomeID_Left },
                    { BiomeType_Surface, self.surfaceBiomeID },
                    { BiomeType_Surface, self.surfaceBiomeID_Right },
                }, false, false)
    else
        local surfaceBoundary = self.surfaceBoundary
        local undergroundBoundary = self.undergroundBoundary
        local buffer = self.buffer
        local chunkYiInMap = self.chunkYiInMap
        local max = math.max
        local min = math.min
        for xi = 0, 1023 do
            local top = max(surfaceBoundary[xi + 1] - chunkYiInMap, 0)
            local bottom = min(undergroundBoundary[xi + 1] - chunkYiInMap, 1024)

            -- Surface layer
            buffer:SetBiomeArea(xi, top, 1, bottom - top,
                    BiomeType_Surface, self.surfaceBiomeID,
                    true, true)

        end
    end

end

function ChunkGenerator:generateSurfaceGrassCover()
    local buffer = self.buffer
    for xi = 0, 1023 do
        local yi = self.surfaceBoundary[xi + 1]
        if yi >= 0 and yi < 1023 then
            local bu = buffer:GetUnit(xi, yi)
            bu.isGrassCoverPreset = true
        end
    end
end

function ChunkGenerator:_genNetherBiomes()
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local netherBoundary = self.netherBoundary
    local min = math.min
    local max = math.max
    local buffer = self.buffer

    local sampleIf = buffer:GetSample(1)
    local maskIf = buffer:GetMask(1)
    sampleIf.biomeType = BiomeType_Underground
    maskIf.biomeType = true

    local sampleApply = buffer:GetSample(2)
    local maskApply = buffer:GetMask(2)
    sampleApply.biomeType = BiomeType_Nether
    maskApply.biomeType = true

    for xi = 0, 1023 do
        local netherYi = min(1023, max(0, netherBoundary[xi + 1] - chunkYiInMap))
        local topCaveYi = min(1023, max(0, netherYi - 120))
        buffer:ApplySampleByMaskByCondition(xi, topCaveYi, 1, 120,
                2, 2, 1, 1)
    end

    buffer:ClearSample(1)
    buffer:ClearMask(1)
    buffer:ClearSample(2)
    buffer:ClearMask(2)
end

--- Write underground biome data into buffer.
---
--- 保存地下群落数据到缓冲区。
function ChunkGenerator:_genUndergroundBiomes()
    self:_genUndergroundBiomeMatrix()

    for _, modChunkGenerator in ipairs(self._modChunkGenerators) do
        modChunkGenerator:onGenerateUndergroundMatrix()
    end

    self.buffer:SetBiomeIDFromMatrixByBiomeType(BiomeType_Underground, self.undergroundBiomeIDMatrix)
end

function ChunkGenerator:_genUndergroundBiomeMatrix()
    local defaultUndergroundBiomeID = DEFAULT_UNDERGROUND_BIOME_ID
    local defaultUndergroundBiomeAreas = DEFAULT_UNDERGROUND_BIOME_AREAS
    local noise = self.noise
    local matrix = self.undergroundBiomeIDMatrix
    local chunkYiInMap = self.chunkYiInMap
    noise:SetData(0.6, 2)

    for i = 0, 33 do
        local ii = i * 34
        for j = 0, 33 do
            local biomeID = defaultUndergroundBiomeID
            local sourceY = chunkYiInMap + (j - 1) * 32 - 16
            for _, data in ipairs(defaultUndergroundBiomeAreas) do
                if sourceY >= data[1] and sourceY < data[2] then
                    biomeID = data[3]
                    break
                end
            end
            matrix[ii + j + 1] = biomeID
        end
    end
    self:_randomUndergroundBiome()

    self:_specialGenUndergroundBiome()
end

function ChunkGenerator:_testInMatrixArea(globalXi, globalYi, width, height)
    return Algorithm.isRectTouch(globalXi, globalYi, width, height,
            self.chunkXiInMap - 32, self.chunkYiInMap - 32, 1024 + 64, 1024 + 64)
end

function ChunkGenerator:_getPolyArea(poly)
    local minX = 99999999
    local maxX = -99999999
    local minY = 99999999
    local maxY = -99999999
    local min = math.min
    local max = math.max

    local len = #poly
    for idx = 1, len, 2 do
        local x, y = poly[idx], poly[idx + 1]
        minX = min(x, minX)
        minY = min(y, minY)
        maxX = max(x, maxX)
        maxY = max(y, maxY)
    end

    return minX, minY, maxX, maxY
end

function ChunkGenerator:writeBiomeMatrixRect(globalXi, globalYi, width, height, matrixData, biomeID)
    if not self:_testInMatrixArea(globalXi, globalYi, width, height) then
        return
    end

    local globalXi2 = globalXi + width
    local globalYi2 = globalYi + height
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap

    local matrix = matrixData
    for i = 0, 33 do
        local ii = i * 34
        local sourceX = chunkXiInMap + (i - 1) * 32 - 16
        if sourceX >= globalXi and sourceX < globalXi2 then
            for j = 0, 33 do
                local sourceY = chunkYiInMap + (j - 1) * 32 - 16
                if sourceY >= globalYi and sourceY < globalYi2 then
                    matrix[ii + j + 1] = biomeID
                end
            end
        end
    end
end

function ChunkGenerator:writeBiomeMatrixPolygon(poly, matrixData, biomeID)
    local minX, minY, maxX, maxY = self:_getPolyArea(poly)

    if not self:_testInMatrixArea(minX, minY, maxX - minX, maxY - minY) then
        return
    end

    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local matrix = matrixData
    local isPointInPolygon = Algorithm.isPointInPolygon

    for i = 0, 33 do
        local ii = i * 34
        local sourceX = chunkXiInMap + (i - 1) * 32 - 16
        if sourceX >= minX and sourceX < maxX then
            for j = 0, 33 do
                local sourceY = chunkYiInMap + (j - 1) * 32 - 16
                if sourceY >= minY and sourceY < maxY then
                    if isPointInPolygon(sourceX, sourceY, poly) then
                        matrix[ii + j + 1] = biomeID
                    end
                end
            end
        end
    end
end

function ChunkGenerator:_randomUndergroundBiome()
    local noise = self.noise
    local matrix = self.undergroundBiomeIDMatrix
    noise:SetData(0.6, 2)
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap

    local allBiomeIDs = {
        Reg.BiomeID("andesite_cave"),
        Reg.BiomeID("blue_mushroom_cave"),
        Reg.BiomeID("desert_cave"),
        Reg.BiomeID("flesh_cave"),
        Reg.BiomeID("granite_cave"),
        Reg.BiomeID("tainted_cave"),
        Reg.BiomeID("waste_cave"),
        Reg.BiomeID("diorite_cave"),
        Reg.BiomeID("jungle_cave"),
    }

    -- use perlin noise to decide every underground biome areas (old generate algorithm)
    -- 使用柏林噪声来决定每一个群系位置
    for _, biomeID in ipairs(allBiomeIDs) do
        local biomeData = BiomeUtils.GetData(biomeID)
        local limitRate = UNDERGROUND_PERLIN_GEN_RATE * biomeData.scale

        local ddx = (biomeID) * 13217
        local ddy = (biomeID) * 14537

        for i = 0, 33 do
            local ii = i * 34
            local perlinOffsetX = (chunkXiInMap + (i - 1) * 32 + ddx) * 0.0015625
            for j = 0, 33 do
                local perlinOffsetY = (chunkYiInMap + (j - 1) * 32 + ddy) * 0.0015625
                local rate = noise:Perlin2D(
                        perlinOffsetX,
                        perlinOffsetY
                ) * 0.5 + 0.5
                if rate < limitRate then
                    matrix[ii + j + 1] = biomeID
                end
            end
        end
    end
end

--- Set sub blocks to buffer.
---
--- 把子方块写入到缓冲区。
function ChunkGenerator:putSubBlocks()
    local buffer = self.buffer
    local noise = self.noise
    noise:SetData(0.6, 2)

    buffer:PushAllSubBlocks()
end

---
function ChunkGenerator:generateCaves()
    self:_makeCaveHorizontal()
    self:_makeCaveRandomDirection()
    self:_makeCavePerlin()
    self:_specialMakeCave()

    for _, modChunkGenerator in ipairs(self._modChunkGenerators) do
        modChunkGenerator:onPostGenerateCaves()
    end
end

function ChunkGenerator:makeCaveHorizontalPoly(
        poly, randomKey, elementWidthMin, elementWidthMax, elementHeightMin, elementHeightMax, density,
        scaleX, persistence, octaves, amplitude,
        scaleXTop, persistenceTop, octavesTop, amplitudeTop,
        scaleXBottom, persistenceBottom, octavesBottom, amplitudeBottom)

    local minX, minY, maxX, maxY = self:_getPolyArea(poly)
    if not Algorithm.isRectTouch(minX, minY, maxX - minX, maxY - minY,
            self.chunkXiInMap, self.chunkYiInMap, 1024, 1024) then
        return
    end

    local buffer = self.buffer
    local wga = WorldGenArea.new(self.chunkXiInMap, self.chunkYiInMap, 1024, 1024)
    local areas = buffer:GetRandomAreas(randomKey, wga,
            elementWidthMin, elementWidthMax,
            elementHeightMin, elementHeightMax,
            density
    )

    ---@param area WorldGenArea
    for _, area in ipairs(areas) do
        local x, y = area.xi + area.wi / 2, area.yi + area.hi / 2
        if Algorithm.isPointInPolygon(x, y, poly) then
            buffer:PerlinMakeCaveHorizontal(
                    area.xi - self.chunkXiInMap, area.yi - self.chunkYiInMap, area.wi, area.hi,
                    scaleX, persistence, octaves, amplitude,
                    scaleXTop, persistenceTop, octavesTop, amplitudeTop,
                    scaleXBottom, persistenceBottom, octavesBottom, amplitudeBottom
            )
        end
    end
end

function ChunkGenerator:_makeCaveHorizontal()
    local buffer = self.buffer
    local noise = self.noise
    noise:SetData(0.3, 4)

    -- generate horizontal cave
    -- 生成横向洞穴
    local wga = WorldGenArea.new(self.chunkXiInMap, self.chunkYiInMap, 1024, 1024)
    local areas = buffer:GetRandomAreas(123, wga,
            30, 250,
            10, 13,
            120.0
    )

    ---@param area WorldGenArea
    for _, area in ipairs(areas) do
        buffer:PerlinMakeCaveHorizontal(
                area.xi - self.chunkXiInMap, area.yi - self.chunkYiInMap, area.wi, area.hi,
                0.01, 0.5, 8, 60.0,
                0.15, 0.3, 4, 10.0,
                0.3, 0.3, 4, 2.0
        )
    end

    local largeAreas = buffer:GetRandomAreas(777, wga,
            100, 250,
            13, 15,
            26.0
    )

    ---@param area WorldGenArea
    for _, area in ipairs(largeAreas) do
        buffer:PerlinMakeCaveHorizontal(
                area.xi - self.chunkXiInMap, area.yi - self.chunkYiInMap, area.wi, area.hi,
                0.022, 0.5, 8, 30.0,
                0.15, 0.3, 4, 18.0,
                0.25, 0.3, 4, 3.0
        )
    end
end

function ChunkGenerator:_makeCaveRandomDirection()
    local chunkYiInMap = self.chunkYiInMap
    local buffer = self.buffer
    local noise = self.noise
    noise:SetData(0.3, 4)

    local pc = 4
    local cc = 1024 / pc

    for i = 0, pc - 1 do
        for j = 0, pc - 1 do
            local xi = i * cc + noise:GetByteFromInt2D(i, j, cc)
            local yi = j * cc + noise:GetByteFromInt2D(j + i, i, cc)
            local sourceY = chunkYiInMap + yi
            if sourceY > SURFACE_LINE + 30 then
                buffer:MakeCaveRandomDirection(xi, yi)
            end
        end
    end
end

function ChunkGenerator:_makeCavePerlin()
    local chunkYiInMap = self.chunkYiInMap
    local buffer = self.buffer
    local noise = self.noise
    noise:SetData(0.3, 4)

    buffer:PerlinMakeCave(0, 0, 1024, 1024, 0.03125, 0.041,
            0.18, 1.0,
            SURFACE_LINE - chunkYiInMap + 100, 100,
            NETHER_LINE - chunkYiInMap, 50
    )
end

function ChunkGenerator:_testCode()
    local buffer = self.buffer
    local noise = self.noise
    noise:SetData(0.3, 4)

    local code = buffer:GetCode()

    --int testInt = (xi + 123) * 0.456 + 7 / 8.0 > 77 and true and 3 > 2 or false;
    --double testDouble = 0.333;
    local rawCode = [[
    double testDouble = (xi+123*xi*(yi*0.6+666));
    if testDouble<2 then
        int a = 1;
    elseif true then
        int aa = 2233;
        aa = aa + 1;
    elseif xi < 20 then
        testDouble = 2;
    else
        int b = 2;
    endif
    ]]
    code:CompileCode(rawCode)
end

function ChunkGenerator:_testMakeCave()
    local buffer = self.buffer
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local noise = self.noise
    noise:SetData(0.3, 4)

    local timeDiff = TimeDiff.new()

    for xi = 0, 1023 do
        local mapXi = chunkXiInMap + xi
        for yi = 0, 1023 do
            local bu = buffer:GetUnit(xi, yi)
            if bu.isFrontPreset then
                local mapYi = chunkYiInMap + yi
                local res = noise:Perlin2D(mapXi * 0.03125, mapYi * 0.041) * 0.5 + 0.5
                if res < 0.41 then
                    buffer:ClearFrontAndWall(xi, yi)
                end
            end
        end
    end

    print("LUA GEN CAVE TIME:", timeDiff:diff(), "ms")
end

--- Generate underground lake.
---
--- 生成地下湖泊。
function ChunkGenerator:generateUnderLake()
    local buffer = self.buffer
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local noise = self.noise
    local surfaceLine = SURFACE_LINE
    local undergroundLakeLine = UNDERGROUND_LAKE_LINE
    local netherLine = NETHER_LINE
    noise:SetData(0.3, 4)

    local SAMPLE_TIMES = 1

    local LIQUID_ID_LAVA = Reg.LiquidID("lava")

    for i = 0, 31 do
        for j = 0, 31 do
            for t = 0, SAMPLE_TIMES - 1 do
                local xi = i * 32 + noise:GetByteFromInt2D(i * 2 + t * 233, j, 32)
                local yi = j * 32 + noise:GetByteFromInt2D(j + i, i - j + t * 233, 32)
                if xi >= 0 and xi < 1024 and yi >= 0 and yi < 1024 then
                    local mapYi = chunkYiInMap + yi
                    if mapYi > surfaceLine and mapYi < undergroundLakeLine then
                        local bu = buffer:GetUnit(xi, yi)
                        local biomeData = BiomeUtils.GetData(bu.biomeID)
                        local liquidInfo = biomeData.liquidInfo
                        if liquidInfo.liquidID > 0 and liquidInfo.maxAllowCount > 0 then
                            buffer:GenerateLake(xi, yi, liquidInfo.liquidID, liquidInfo.maxAllowCount)
                        end
                    elseif mapYi >= undergroundLakeLine and mapYi < netherLine then
                        buffer:GenerateLake(xi, yi, LIQUID_ID_LAVA, 250)
                    end
                end
            end
        end
    end

    -- nether lava
    if self.isGenNether then
        local lavaID = Reg.LiquidID("tc:lava")
        local lavaYi = NETHER_LAVA_LINE - chunkYiInMap
        local sampleIf = buffer:GetSample(1)
        local maskIf = buffer:GetMask(1)
        sampleIf.isFrontPreset = false
        maskIf.isFrontPreset = true

        buffer:SetLiquidAreaByCondition(0, lavaYi, 1024, 1024 - lavaYi, lavaID, 63,
                1, 1)

        buffer:ClearSample(1)
        buffer:ClearMask(1)

        -- fill lava to make many levels
        for i = 0, 63 do
            local xi = 16 * i
            local yi = lavaYi - math.floor(math.abs(noise:GetDoubleFromInt1D(chunkXiInMap + chunkYiInMap + i)) * 48)
            buffer:GenerateLake(xi, yi, lavaID, 1000)
        end
    end
end

function ChunkGenerator:generateOres()
    local buffer = self.buffer
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local oreGroups = BlockUtils.oreGroups
    for i = 1, oreGroups.count do
        local oreGroup = oreGroups[i]
        local groupName = oreGroup.name
        local dataList = oreGroup.dataList
        for j = 1, dataList.count do
            local data = dataList[j]
            --print(groupName, data.oreID, data.radius, data.density)

            local oreID = data.oreID
            local r = data.radius
            local r2 = r * 2
            local density = data.density

            local areaYi = math.max(chunkYiInMap, data.startYi)
            local areaYi2 = math.min(chunkYiInMap + 1024, data.endYi)

            if areaYi < areaYi2 then
                local mainArea = WorldGenArea.new(chunkXiInMap, areaYi, 1024, areaYi2 - areaYi)
                local areas = buffer:GetRandomAreas(data.oreID, mainArea, r2, r2, r2, r2, density)

                local lastBiomeID = -1
                local canPlace = false

                ---@param area WorldGenArea
                for _, area in ipairs(areas) do
                    local xi = area.xi - chunkXiInMap + r
                    local yi = area.yi - chunkYiInMap + r

                    if xi >= 0 and xi < 1024 and yi >= 0 and yi < 1024 then
                        local bu = buffer:GetUnit(xi, yi)
                        local biomeID = bu.biomeID

                        if biomeID ~= lastBiomeID then
                            local biomeData = BiomeUtils.GetData(biomeID)
                            canPlace = (biomeData.oreGroupName == groupName)
                        end

                        if canPlace then
                            buffer:AddBlockRandomOval(
                                    oreID, xi - r, yi - r, r2, r2,
                                    true,
                                    false,
                                    false
                            )
                        end
                    end
                end
            end

        end
    end
end

function ChunkGenerator:generateCobwebs()
    if not self.isGenUnderground then
        return
    end

    local buffer = self.buffer
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap

    local cobwebID = Reg.BlockID("tc:cobweb")

    local r = 6
    local r2 = r * 2
    local r_half = math.ceil(r / 2)
    local density = 1000

    local mainArea = WorldGenArea.new(chunkXiInMap, chunkYiInMap, 1024, 1024)

    local areas = buffer:GetRandomAreas(chunkXiInMap + chunkYiInMap + 233,
            mainArea, r2, r2, r2, r2, density
    )

    ---@param area WorldGenArea
    for _, area in ipairs(areas) do
        local mapYi = area.yi
        if mapYi > UNDERGROUND_LINE and mapYi < NETHER_LINE then
            local mapXi = area.xi
            local xi = mapXi - chunkXiInMap
            local yi = mapYi - chunkYiInMap
            local hasSolid = buffer:IsAreaHasSolid(xi, yi, r, r_half)
            if hasSolid then
                buffer:AddBlockRandomOval(
                        cobwebID, xi, yi, r2, r2,
                        false, false, true)
            end
        end
    end

end

function ChunkGenerator:generateBuildings()
    for _, modChunkGenerator in ipairs(self._modChunkGenerators) do
        modChunkGenerator:onGenerateBuildings()
    end

    self:_onGenerateBuildings()

    -- sort by key and add all pending building to map.
    table.sort(self._pendingSortableBuildingList, function(a, b)
        return a.sizeAsSortKey > b.sizeAsSortKey
    end)
    for _, pendingBuilding in ipairs(self._pendingSortableBuildingList) do
        self.buffer:CreateBuilding(pendingBuilding.buildingID, pendingBuilding.xi, pendingBuilding.yi)
    end

    self.buffer:ApplyBuildings()
end

function ChunkGenerator:generateTrees()
    if self.isGenSurface then
        self:_genSurfaceTrees()
    end
    if self.isGenUnderground then
        self:_genUndergroundTrees()
    end
end

function ChunkGenerator:generateMushrooms()
    if self.isGenSurface then
        self:_genSurfaceMushrooms()
    end
end

function ChunkGenerator:_genSurfaceTrees()
    local abs = math.abs
    local buffer = self.buffer
    local lastBiomeID = 0
    local biomeData  ---@type BiomeData
    local noise = self.noise

    local rate = 0
    local styles = 0
    local totalStyles = 0

    for xi = 4, 1019 do
        local biomeID = self.surfaceBiomeIDArray[xi + 1]
        if biomeData == nil or biomeID ~= lastBiomeID then
            lastBiomeID = biomeID
            biomeData = BiomeUtils.GetData(biomeID)
            rate = biomeData.treeInfo.density
            styles = biomeData.treeInfo.styles
            totalStyles = styles.count
        end

        if totalStyles > 0 and abs(noise:GetDoubleFromInt1D(xi * 32)) < rate then
            -- random pick a tree block to generate
            local yi = self.surfaceBoundary[xi + 1]
            local index = noise:GetByteFromInt2D(xi, xi * 32, totalStyles) + 1
            local blockID = styles[index]
            local ok = buffer:GenerateTree(xi, yi, blockID)
            if ok then
                -- two trees must has at least 7 distance
                -- 两棵树必须距离至少7个格子
                xi = xi + 6
            end
        end
    end
end

function ChunkGenerator:_genSurfaceMushrooms()
    local abs = math.abs
    local buffer = self.buffer
    local lastBiomeID = 0
    local biomeData  ---@type BiomeData
    local noise = self.noise

    local rate = 0
    local styles = 0
    local totalStyles = 0

    local stemID = Reg.BlockID("tc:mushroom_stem")

    for xi = 4, 1019 do
        local biomeID = self.surfaceBiomeIDArray[xi + 1]
        if biomeData == nil or biomeID ~= lastBiomeID then
            lastBiomeID = biomeID
            biomeData = BiomeUtils.GetData(biomeID)
            rate = biomeData.mushroomInfo.density
            styles = biomeData.mushroomInfo.styles
            totalStyles = styles.count
        end

        if totalStyles > 0 and abs(noise:GetDoubleFromInt1D(xi * 32)) < rate then
            -- random pick a tree block to generate
            local yi = self.surfaceBoundary[xi + 1]
            local index = noise:GetByteFromInt2D(xi, xi * 3, totalStyles) + 1
            local blockID = styles[index]
            local ok = buffer:GenerateLargeMushroom(xi, yi, blockID, stemID)
            if ok then
                xi = xi + 6
            end
        end
    end
end

function ChunkGenerator:_genUndergroundTrees()
    local abs = math.abs
    local buffer = self.buffer
    local noise = self.noise

    local SAMPLE_TIMES = 1024 * 8

    local startYi, yiSize = self:_getUndergroundYiAreaInChunk()
    local posList = buffer:GetAllFloors(0, startYi, 1024, yiSize)

    local totalPos = posList.count
    local sampleStep = math.floor(totalPos / SAMPLE_TIMES)

    if sampleStep <= 0 then
        return
    end

    local lastBiomeID = -1
    local treeInfo
    local styles
    local styleCount
    for step = 0, SAMPLE_TIMES - 1 do
        local index = step * sampleStep + 1
        if index <= totalPos then
            local pos = posList[index]
            local xi = pos.xi
            local yi = pos.yi

            local bu = buffer:GetUnit(xi, yi)

            if bu.biomeID ~= lastBiomeID then
                lastBiomeID = bu.biomeID
                local biomeData = BiomeUtils.GetData(lastBiomeID)
                treeInfo = biomeData.treeInfo
                styles = treeInfo.styles
                styleCount = styles.count
            end

            if treeInfo ~= nil and styles.count > 0 then
                local rate = treeInfo.density * sampleStep
                local curRate = abs(noise:GetDoubleFromInt1D(xi * 32 + yi * 128))
                if curRate < rate then
                    local styleIndex = noise:GetByteFromInt2D(xi, xi * 32, styleCount) + 1
                    local blockID = styles[styleIndex]
                    buffer:GenerateTree(xi, yi, blockID)
                end
            end
        end
    end
end

function ChunkGenerator:generatePlaceable()
    local buffer = self.buffer
    if self.isGenSurface then
        buffer:CreateAllPlaceableByBiomeType(
                0, 0, 1024, 1024,
                BiomeType_Surface, self.surfaceBoundaryID)
    end
    if self.isGenUnderground then
        buffer:CreateAllPlaceableByBiomeType(
                0, 0, 1024, 1024,
                BiomeType_Underground)
    end
    if self.isGenNether then
        buffer:CreateAllPlaceableByBiomeType(
                0, 0, 1024, 1024,
                BiomeType_Nether
        )
    end
end

function ChunkGenerator:getRandomTimes(rawTimes, randomKey)
    local times = 0
    if rawTimes < 1 then
        if self:inChance(rawTimes, randomKey) then
            times = 1
        end
    else
        times = math.ceil(rawTimes)
    end
    return times
end

function ChunkGenerator:inChance(rate, randomKey)
    return math.abs(self.noise:GetDoubleFromInt1D(randomKey)) < rate
end

function ChunkGenerator:_ranGenSurfaceSpecialTerrains(randomKey, rawTimes, size, height, cb, ignoreAreas, notAllowPaintSubBiome, currentBiomeID, biomeIDArray)
    if notAllowPaintSubBiome == nil then
        notAllowPaintSubBiome = false
    end

    local times = self:getRandomTimes(rawTimes, self.chunkXi * 223 + size + height * 7 + randomKey, 77)
    for t = 1, times do
        for k = 1, 5 do
            local xi = math.floor(1024 * math.abs(self.noise:GetDoubleFromInt2D(self.chunkXi * 19 + size + t + 123 + k, self.chunkXi * 223 + t * 2 + randomKey + k * 53)))
            local x1 = math.max(0, xi - size / 2)
            local x2 = math.min(1024, xi + size / 2)

            local ignore = false
            if ignoreAreas ~= nil then
                for _, area in ipairs(ignoreAreas) do
                    if x1 >= area[1] and x2 <= area[2] then
                        ignore = true
                        break
                    end
                end
            end
            if not ignore and notAllowPaintSubBiome and biomeIDArray ~= nil then
                for _xi = x1, x2 - 1 do
                    if biomeIDArray[_xi + 1] ~= currentBiomeID then
                        ignore = true
                        break
                    end
                end
            end
            if not ignore then
                cb(x1, x2)
                break
            end
        end
    end
end

function ChunkGenerator:_randGenSurfaceLake(rawTimes, size, height, liquidID, ignoreAreas)
    local function cb(x1, x2)
        self.specialTerrainProxies:createSurfaceLake(x1, x2, liquidID, height)
    end
    self:_ranGenSurfaceSpecialTerrains(self.chunkXi * 3 + 114, rawTimes, size, height, cb, ignoreAreas, true, self.surfaceBiomeID, self.surfaceBiomeIDArray)
end

function ChunkGenerator:_randGenSurfaceCave(rawTimes, size, ignoreAreas)
    local function cb(x1, x2)
        self.specialTerrainProxies:createSurfaceCave(x1, x2)
    end
    self:_ranGenSurfaceSpecialTerrains(self.chunkXi * 7 + 514, rawTimes, size, 0, cb, ignoreAreas, true, self.surfaceBiomeID, self.surfaceBiomeIDArray)
end

function ChunkGenerator:createSubBiomes(boundaryTop, x1, x2, depth, subBiomeID, maskedBiomeType, maskedBiomeID, biomeIDArray)
    x1 = math.max(0, x1)
    x2 = math.min(1024, x2)
    local size = (x2 - x1)
    local halfSize = math.floor(size / 2)
    if size <= 0 or halfSize <= 0 then
        return
    end

    local buffer = self.buffer
    local chunkYiInMap = self.chunkYiInMap
    local centerXi = math.ceil((x1 + x2) / 2)

    local sampleIf = buffer:GetSample(1)
    local maskIf = buffer:GetMask(1)
    sampleIf.biomeType = maskedBiomeType
    sampleIf.biomeID = maskedBiomeID
    maskIf.biomeType = true
    maskIf.biomeID = true

    local sampleApply = buffer:GetSample(2)
    local maskApply = buffer:GetMask(2)
    sampleApply.biomeID = subBiomeID
    maskApply.biomeID = true

    for xi = x1, x2 - 1 do
        local offsetX = 0
        if xi < centerXi then
            offsetX = xi - x1
        else
            offsetX = x2 - xi
        end
        local depthRate = offsetX / halfSize
        local currentDepth = math.ceil(depth * depthRate)
        if currentDepth > 0 then
            local topYi = boundaryTop[xi + 1] - chunkYiInMap
            buffer:ApplySampleByMaskByCondition(xi, topYi, 1, currentDepth, 2, 2, 1, 1)
        end
        biomeIDArray[xi + 1] = subBiomeID
    end

    buffer:ClearSample(1)
    buffer:ClearSample(2)
    buffer:ClearMask(1)
    buffer:ClearMask(2)
end

function ChunkGenerator:generateSpecialTerrains()
    if self.isGenSurface then
        self.specialTerrainProxies.biomeType1 = BiomeType_Surface
        self.specialTerrainProxies.biomeID1 = self.surfaceBiomeID
        self.specialTerrainProxies.boundary = self.surfaceBoundary

        local proxy = {}
        proxy[Reg.BiomeID("tc:forest")] = self.genSpecialTerrains_Forest
        proxy[Reg.BiomeID("tc:jungle")] = self.genSpecialTerrains_Jungle
        proxy[Reg.BiomeID("tc:desert")] = self.genSpecialTerrains_Desert
        proxy[Reg.BiomeID("tc:soft_snow_land")] = self.genSpecialTerrains_SoftSnowLand
        proxy[Reg.BiomeID("tc:super_volcano")] = self.genSpecialTerrains_SuperVolcano
        proxy[Reg.BiomeID("tc:mushroom_fields")] = self.genSpecialTerrains_MushroomFields

        local func = proxy[self.surfaceBiomeID]
        if func ~= nil then
            func(self)
        end
    end
end

function ChunkGenerator:genSpecialTerrains_Forest()

    local ignoreAreas = {}
    if self.chunkXi == 0 then
        table.insert(ignoreAreas, { 450, 550 })
    end

    -- lakes
    self:_randGenSurfaceLake(0.5, 60, 10, Reg.LiquidID("water"), ignoreAreas)
    self:_randGenSurfaceLake(1.0, 40, 15, Reg.LiquidID("water"), ignoreAreas)

    -- surface caves
    self:_randGenSurfaceCave(1.0, 60, ignoreAreas)
    self:_randGenSurfaceCave(3.0, 40, ignoreAreas)

end

function ChunkGenerator:genSpecialTerrains_Jungle()
    -- lakes
    --self:_randGenSurfaceLake(1.0, 150, 20, Reg.LiquidID("water"))
    self:_randGenSurfaceLake(3.0, 60, 10, Reg.LiquidID("water"))
    self:_randGenSurfaceLake(2.0, 40, 30, Reg.LiquidID("water"))

    -- surface caves
    --self:_randGenSurfaceCave(3.0, 50)
    --self:_randGenSurfaceCave(2.0, 80)
    --self:_randGenSurfaceCave(2.0, 40)

end

function ChunkGenerator:genSpecialTerrains_SoftSnowLand()
    -- lakes
    self:_randGenSurfaceLake(0.5, 60, 10, Reg.LiquidID("water"))
    self:_randGenSurfaceLake(1.0, 40, 15, Reg.LiquidID("water"))

    -- surface caves
    self:_randGenSurfaceCave(1.0, 60)
    self:_randGenSurfaceCave(2.0, 50)
    self:_randGenSurfaceCave(4.0, 40)

end

function ChunkGenerator:genSpecialTerrains_SuperVolcano()
    -- lakes
    self:_randGenSurfaceLake(0.5, 60, 10, Reg.LiquidID("lava"))
    self:_randGenSurfaceLake(1.0, 40, 15, Reg.LiquidID("lava"))

    -- surface caves
    self:_randGenSurfaceCave(1.0, 60)
    self:_randGenSurfaceCave(2.0, 50)
    self:_randGenSurfaceCave(3.0, 40)

end

function ChunkGenerator:genSpecialTerrains_MushroomFields()

    -- lakes
    self:_randGenSurfaceLake(1.5, 40, 10, Reg.LiquidID("water"))
    self:_randGenSurfaceLake(2.0, 20, 10, Reg.LiquidID("water"))

    -- surface caves
    self:_randGenSurfaceCave(2.0, 60)
    self:_randGenSurfaceCave(3.0, 50)
    self:_randGenSurfaceCave(4.0, 40)

end

function ChunkGenerator:getSurfaceMainIndexAtLoop(chunkXi)
    return math.abs(chunkXi) % WorldGenDefine.SURFACE_CHUNK_XI_LOOP_TOTALS
end

local SURFACE_MAIN_INDEX_TO_BIOME_MAPPINGS = {
    [WorldGenDefine.SURFACE_CHUNK_XI_NEW_GUIDE_FOREST] = Reg.BiomeID("tc:forest"),
    [WorldGenDefine.SURFACE_CHUNK_XI_JUNGLE] = Reg.BiomeID("tc:jungle"),
    [WorldGenDefine.SURFACE_CHUNK_XI_SNOW] = Reg.BiomeID("tc:soft_snow_land"),
    [WorldGenDefine.SURFACE_CHUNK_XI_DUNGEON] = Reg.BiomeID("tc:forest"),
    [WorldGenDefine.SURFACE_CHUNK_XI_DESERT] = Reg.BiomeID("tc:desert"),
    [WorldGenDefine.SURFACE_CHUNK_XI_TAINTED] = Reg.BiomeID("tc:tainted_land"),
    [WorldGenDefine.SURFACE_CHUNK_XI_ICE_DUNGEON] = Reg.BiomeID("tc:flesh"),
    [WorldGenDefine.SURFACE_CHUNK_XI_VOLCANO] = Reg.BiomeID("tc:super_volcano"),
    [WorldGenDefine.SURFACE_CHUNK_XI_MUSHROOM] = Reg.BiomeID("tc:mushroom_fields"),
    [WorldGenDefine.SURFACE_CHUNK_XI_OCEAN] = Reg.BiomeID("tc:ocean"),
}

function ChunkGenerator:getSurfaceMainBiomeID(chunkXi)
    local mainIndex = self:getSurfaceMainIndexAtLoop(chunkXi)
    local resBiome = SURFACE_MAIN_INDEX_TO_BIOME_MAPPINGS[mainIndex]
    if resBiome ~= nil then
        return resBiome
    end

    -- random pick
    local maxSurfaceCount = BiomeUtils.GetBiomeCountByType(BiomeType_Surface)
    local index = self.noise:GetByteFromInt2D(chunkXi * 233, chunkXi * 73, maxSurfaceCount)
    return BiomeUtils.GetBiomeIDByType(BiomeType_Surface, index)
end

function ChunkGenerator:generateSpecialGroup()
    if self.surfaceBiomeID == Reg.BiomeID("ocean") then
        self:createOceanGroup()
    end
end

function ChunkGenerator:createOceanGroup()
    local chunkXiInMap = self.chunkXiInMap
    local chunkYiInMap = self.chunkYiInMap
    local floor = math.floor
    local sin = math.sin
    local max = math.max
    local pi = math.pi
    local buffer = self.buffer
    local noise = self.noise
    local surfaceBoundary = self.surfaceBoundary

    local sampleIf = buffer:GetSample(1)
    local maskIf = buffer:GetMask(1)
    sampleIf.isFrontPreset = true
    maskIf.isFrontPreset = true

    local sampleApply = buffer:GetSample(2)
    local maskApply = buffer:GetMask(2)
    sampleApply.isFrontPreset = true
    sampleApply.isWallPreset = true
    maskApply.isFrontPreset = true
    maskApply.isWallPreset = true

    local sandID = Reg.BlockID("tc:sand")

    for xi = 0, 1023 do
        local sands = 15
        if xi < 40 then
            sands = xi
        elseif xi > 1024 - 40 then
            sands = 1024 - xi
        end
        sands = sands + floor(sin(xi / 8.0 * 3.0))
        local surfaceYi = surfaceBoundary[xi + 1] - chunkYiInMap
        buffer:SetTileAreaByCondition(xi, surfaceYi, 1, sands, sandID, 0, true, 1, 1)
        buffer:ApplySampleByMask(xi, surfaceYi + sands, 1, 120 - sands, 2, 2)
    end

    local x1, x2 = 100, 900
    local size, depth = 800, 80
    local maxSurfaceYi = -99999999
    for xi = x1, x2 - 1 do
        local surfaceYi = surfaceBoundary[xi + 1] - chunkYiInMap
        maxSurfaceYi = max(maxSurfaceYi, surfaceYi)
        local offset = floor(sin((xi - x1) / size * pi) * depth)
        buffer:ClearFrontAndWallArea(xi, surfaceYi, 1, offset)
        local deepSands = 10 + floor(sin(xi / 2))
        buffer:SetTileAreaByCondition(xi, surfaceYi + offset, 1, deepSands, sandID, 0, true, 1, 1)
    end

    buffer:ClearSample(1)
    buffer:ClearMask(1)

    buffer:ClearSample(2)
    buffer:ClearMask(2)

    -- fill water
    buffer:GenerateLake((x1 + x2) / 2, maxSurfaceYi, Reg.LiquidID("tc:water"), 9999999)

    for i = 0, 2 do
        self:createSmallIsland(300 + i * 200 + noise:GetByteFromInt2D(chunkXiInMap, chunkYiInMap + i * 3, 50), maxSurfaceYi, 100)
    end
end

function ChunkGenerator:createSmallIsland(x, y, size)
    if size <= 0 then
        return
    end
    local abs = math.abs
    local floor = math.floor
    local max = math.max
    local sin = math.sin
    local buffer = self.buffer
    local noise = self.noise
    local surfaceBoundary = self.surfaceBoundary
    local size_2 = max(1, floor(size / 2))
    local size_4 = max(1, floor(size / 4))
    local size_4_3 = max(1, floor(size / 4 * 3))
    local size_pi = math.pi / size
    local x1 = x - size_2
    local oceanY = y

    local sandID = Reg.BlockID("tc:sand")
    local baseID = Reg.BlockID("tc:prismarine_mud")

    for i = 0, size - 1 do
        local xi = x1 + i
        local offsetY = abs(surfaceBoundary[xi + 1] - oceanY)
        if i < size_4 then
            offsetY = floor(offsetY * i / size_4)
        elseif i > size_4_3 then
            offsetY = floor(offsetY * (size - i) / size_4)
        end
        local surfaceY = oceanY - offsetY
        surfaceBoundary[xi + 1] = surfaceY
        local len = floor(offsetY * 2 + sin(i * size_pi) * 10)
        len = len + floor(sin(i / 4.0) * 2) + noise:GetByteFromInt2D(offsetY + i, offsetY, 2)
        local lineY = surfaceY + floor(len / 2)
        local bottomY = surfaceY + len

        buffer:ClearLiquidArea(xi, surfaceY, 1, len)

        buffer:SetTileArea(xi, surfaceY, 1, lineY - surfaceY, sandID, 0, true)
        buffer:SetWallArea(xi, surfaceY, 1, lineY - surfaceY, sandID, true)

        buffer:SetTileArea(xi, lineY, 1, bottomY - lineY, baseID, 0, true)
        buffer:SetWallArea(xi, lineY, 1, bottomY - lineY, baseID, true)

        local exOffset = floor(-sin(i / 4.0) * 2) + 8
        if i < size_4 then
            exOffset = floor(exOffset * i / size_4)
        elseif i > size_4_3 then
            exOffset = floor(exOffset * (size - i) / size_4)
        end
        buffer:SetWallArea(xi, bottomY, 1, exOffset, baseID, true)
    end
end

function ChunkGenerator:generateSubBiomes()
    if self.chunkYi == 0 then
        local mainIndex = self:getSurfaceMainIndexAtLoop(self.chunkXi)
        if mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_JUNGLE then
            self:createSubBiomes(
                    self.surfaceBoundary,
                    100, 300, 150,
                    Reg.BiomeID("tc:desert"),
                    BiomeType_Surface, self.surfaceBiomeID, self.surfaceBiomeIDArray
            )
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_DUNGEON then
            self:createSubBiomes(
                    self.surfaceBoundary,
                    120, 400, 150,
                    Reg.BiomeID("tc:tainted_land"),
                    BiomeType_Surface, self.surfaceBiomeID, self.surfaceBiomeIDArray
            )
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_DESERT then
            self:createSubBiomes(
                    self.surfaceBoundary,
                    550, 900, 150,
                    Reg.BiomeID("tc:badland"),
                    BiomeType_Surface, self.surfaceBiomeID, self.surfaceBiomeIDArray
            )
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_TAINTED then
            self:createSubBiomes(
                    self.surfaceBoundary,
                    300, 600, 200,
                    Reg.BiomeID("tc:jungle"),
                    BiomeType_Surface, self.surfaceBiomeID, self.surfaceBiomeIDArray
            )
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_ICE_DUNGEON then
            self:createSubBiomes(
                    self.surfaceBoundary,
                    300, 660, 250,
                    Reg.BiomeID("tc:soft_snow_land"),
                    BiomeType_Surface, self.surfaceBiomeID, self.surfaceBiomeIDArray
            )
        end
    end
end

function ChunkGenerator:createPendingBuildings(buildingID, xi, yi, sizeAsSortKey)
    table.insert(self._pendingSortableBuildingList, {
        buildingID = buildingID,
        xi = xi,
        yi = yi,
        sizeAsSortKey = sizeAsSortKey,
    })
end

function ChunkGenerator:_onGenerateBuildings()
    if self.chunkYi == 0 then
        local mainIndex = self:getSurfaceMainIndexAtLoop(self.chunkXi)
        if mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_NEW_GUIDE_FOREST then
            -- new player area

            for ii = 0, 1 do
                -- create house for new player living
                local genRightHouse = ii == 0
                local houseXi = genRightHouse and 700 or 300
                local houseYi = self.surfaceBoundary[houseXi + 1] - self.chunkYiInMap
                self.buffer:CreateBuilding(Reg.BuildingID("tc:mini_house"), houseXi, houseYi)

                -- create underground houses
                local idNames = {
                    "tc:under_dark_oak_cabin",
                    "tc:under_jungle_cabin",
                    "tc:under_oak_cabin",
                    "tc:under_stone_cabin",
                }

                local UNDER_CABINS_START_YI = SURFACE_LINE + 100
                local UNDER_CABINS_SIZE = 500
                local CABINS_PRE_CNT = 8

                for i, idName in ipairs(idNames) do
                    local buildingID = Reg.BuildingID(idName)
                    local mainArea = WorldGenArea.new(self.chunkXiInMap, UNDER_CABINS_START_YI, 1024, UNDER_CABINS_SIZE)

                    local areas = self.buffer:GetRandomAreas(self.chunkXiInMap + self.chunkYiInMap + 11233 + i * 7,
                            mainArea, 1, 1, 1, 1, CABINS_PRE_CNT
                    )
                    ---@param area WorldGenArea
                    for _, area in ipairs(areas) do
                        local xi = area.xi - self.chunkXiInMap
                        local yi = area.yi - self.chunkYiInMap
                        self.buffer:CreateBuilding(buildingID, xi, yi)
                    end
                end
            end
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_JUNGLE then
            -- jungle zone
            --local houseXi = 400
            --local houseYi = self.surfaceBoundary[houseXi + 1] - self.chunkYiInMap
            --self.buffer:CreateBuilding(Reg.BuildingID("tc:jungle_temple"), houseXi, houseYi)
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_SNOW then
            local houseXi = 500
            local houseYi = self.surfaceBoundary[houseXi + 1] - self.chunkYiInMap
            self.buffer:CreateBuilding(Reg.BuildingID("tc:aurora_palace"), houseXi, houseYi)
        elseif mainIndex == WorldGenDefine.SURFACE_CHUNK_XI_OCEAN then
            local houseXi = 500
            local houseYi = self.surfaceBoundary[houseXi + 1] + 80
            self.buffer:CreateBuilding(Reg.BuildingID("tc:monument_ocean"), houseXi, houseYi)
        end
    end

    if self.isGenNether then
        local genYi = NETHER_LAVA_LINE - 50 - self.chunkYiInMap
        self.buffer:CreateBuilding(Reg.BuildingID("tc:nether_fortress"), 500, genYi)
    end

    if self.isGenUnderground then
        -- create underground houses
        local idNames = {
            "tc:under_dark_oak_cabin",
            "tc:under_jungle_cabin",
            "tc:under_oak_cabin",
            "tc:under_stone_cabin",
            "tc:under_spruce_cabin",
            "tc:under_tainted_cabin",
            "tc:under_desert_cabin",
        }

        local UNDER_CABINS_START_YI = UNDERGROUND_LINE
        local UNDER_CABINS_SIZE = NETHER_LINE - UNDERGROUND_LINE
        local CABINS_PRE_CNT = 2

        for i, idName in ipairs(idNames) do
            self:_genTargetBuilding(Reg.BuildingID(idName),
                    UNDER_CABINS_START_YI, UNDER_CABINS_SIZE, CABINS_PRE_CNT,
                    self.chunkXiInMap + self.chunkYiInMap + 657 + i * 7)
        end
    end

    -- health crystals
    self:_genTargetBuilding(Reg.BuildingID("heart"),
            SURFACE_LINE + 100, NETHER_LAVA_LINE - SURFACE_LINE, 30,
            self.chunkXiInMap + self.chunkYiInMap + 1785)
    -- fossils
    self:_genTargetBuilding(Reg.BuildingID("fossils"),
            SURFACE_LINE + 100, NETHER_LINE - SURFACE_LINE, 30,
            self.chunkXiInMap * 2 + self.chunkYiInMap + 131)
end

function ChunkGenerator:_genTargetBuilding(buildingID, startYiInMap, height, density, randomKey)
    local mainArea = WorldGenArea.new(self.chunkXiInMap, startYiInMap, 1024, height)

    local areas = self.buffer:GetRandomAreas(randomKey,
            mainArea, 1, 1, 1, 1, density
    )
    ---@param area WorldGenArea
    for _, area in ipairs(areas) do
        local xi = area.xi - self.chunkXiInMap
        local yi = area.yi - self.chunkYiInMap
        self.buffer:CreateBuilding(buildingID, xi, yi)
    end
end

function ChunkGenerator:_specialMakeCave()
    self:makeCaveHorizontalPoly(self:getUndergroundRealPolygon(self:_getPolyJungle()), 654,
            30, 250, 15, 23, 120.0,
            0.01, 0.5, 8, 60.0,
            0.15, 0.3, 4, 10.0,
            0.3, 0.3, 4, 2.0
    )
    self:makeCaveHorizontalPoly(self:getUndergroundRealPolygon(self:_getPolyBlueMushroom()), 654,
            30, 250, 15, 43, 290.0,
            0.01, 0.5, 8, 60.0,
            0.15, 0.3, 4, 10.0,
            0.3, 0.3, 4, 2.0
    )
    self:makeCaveHorizontalPoly(self:getUndergroundRealPolygon(self:_getPolyBlueMushroom2()), 654,
            30, 250, 15, 43, 290.0,
            0.01, 0.5, 8, 60.0,
            0.15, 0.3, 4, 10.0,
            0.3, 0.3, 4, 2.0
    )
    self:makeCaveHorizontalPoly(self:getUndergroundRealPolygon(self:_getPolyDeepIce()), 654,
            80, 180, 8, 12, 280.0,
            0.01, 0.5, 8, 12.0,
            0.15, 0.3, 4, 10.0,
            0.3, 0.3, 4, 2.0
    )

    -- nether
    if self.isGenNether then
        self:_genNetherCave()
    end

end

function ChunkGenerator:_genNetherCave()
    local buffer = self.buffer
    local wga = WorldGenArea.new(self.chunkXiInMap, NETHER_LAVA_LINE - NETHER_LAVE_CAVE_HEIGHT, 1024, NETHER_LAVE_CAVE_HEIGHT)

    local areas = buffer:GetRandomAreas(155, wga,
            130, 250,
            15, 23, 320.0
    )
    ---@param area WorldGenArea
    for _, area in ipairs(areas) do
        buffer:PerlinMakeCaveHorizontal(
                area.xi - self.chunkXiInMap, area.yi - self.chunkYiInMap, area.wi, area.hi,
                0.01, 0.5, 8, 12.0,
                0.15, 0.3, 4, 10.0,
                0.3, 0.3, 4, 2.0
        )
    end
end

function ChunkGenerator:_getPolyJungle()
    return {
        --400, 500,
        --200, 800,
        --600, 1300,
        --900, 700,
        1024, 500,
        800, 1200,
        1400, 1600,
        2000, 1400,
        2200, 1000,
        2048, 500
    }
end

function ChunkGenerator:_getPolyDeepIce()
    return {
        2048 + 100, 500,
        2048 - 400, 1500,
        3096 + 400, 1500,
        3096 - 100, 500
    }
end

function ChunkGenerator:_getPolyBlueMushroom()
    return {
        400, 600,
        300, 900,
        700, 1000,
        800, 800
    }
end

function ChunkGenerator:_getPolyBlueMushroom2()
    local l, r = 1024 * 7, 1024 * 8
    return {
        l + 400, 600,
        l + 100, 1800,
        l + 700, 1900,
        l + 800, 800
    }
end

function ChunkGenerator:_getPolyTainted()
    local l, r = 1024 * 5, 1024 * 6
    return {
        l, 500,
        r, 1800,
        r + 500, 1800,
        l + 500, 500
    }
end

function ChunkGenerator:_getPolyFlesh()
    local l, r = 1024 * 6, 1024 * 7
    return {
        l + 500, 500,
        l - 500, 1800,
        l, 1800,
        r, 500
    }
end

function ChunkGenerator:getUndergroundRealPolygon(polys)
    local polyDir = 0
    if self.chunkXi > 0 then
        polyDir = 1
    elseif self.chunkXi < 0 then
        polyDir = -1
    end
    local loopIndex = math.floor(math.abs(self.chunkXi) / WorldGenDefine.SURFACE_CHUNK_XI_LOOP_TOTALS)
    local fixSideMove = loopIndex * 1024 * WorldGenDefine.SURFACE_CHUNK_XI_LOOP_TOTALS

    local fixSidePolys = clone(polys)
    for i = 1, #fixSidePolys, 2 do
        fixSidePolys[i] = fixSidePolys[i] + fixSideMove
    end

    if polyDir == -1 then
        for i = 1, #fixSidePolys, 2 do
            fixSidePolys[i] = -fixSidePolys[i]
        end
    end
    return fixSidePolys
end

function ChunkGenerator:writeUndergroundPolygon(polys, biomeID)
    local fixSidePolys = self:getUndergroundRealPolygon(polys)
    self:writeBiomeMatrixPolygon(fixSidePolys, self.undergroundBiomeIDMatrix, biomeID)
end

function ChunkGenerator:_specialGenUndergroundBiome()
    self:writeUndergroundPolygon(self:_getPolyJungle(), Reg.BiomeID("tc:jungle_cave"))
    self:writeUndergroundPolygon(self:_getPolyDeepIce(), Reg.BiomeID("tc:deep_ice_cave"))
    self:writeUndergroundPolygon(self:_getPolyBlueMushroom(), Reg.BiomeID("tc:blue_mushroom_cave"))
    self:writeUndergroundPolygon(self:_getPolyBlueMushroom2(), Reg.BiomeID("tc:blue_mushroom_cave"))
    self:writeUndergroundPolygon(self:_getPolyTainted(), Reg.BiomeID("tc:tainted_cave"))
    self:writeUndergroundPolygon(self:_getPolyFlesh(), Reg.BiomeID("tc:flesh_cave"))
end

return ChunkGenerator