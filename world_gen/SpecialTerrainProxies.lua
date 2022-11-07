---@class TC.SpecialTerrainProxies
---Store all calculation about how to modify the map.
---
---维护所有通用改变地形的算法。
local SpecialTerrainProxies = class("SpecialTerrainProxies")

---@param buffer WorldGenChunkBuffer
---@param noise WorldGenNoise
---@param chunkYiInMap int
function SpecialTerrainProxies:__init(buffer, noise, chunkYiInMap)
    self._proxies = {
        SurfaceCave = SpecialTerrainProxies.createSurfaceCave,
    }

    self.chunkYiInMap = chunkYiInMap
    self.boundary = nil
    self.boundary2 = nil
    self.boundary3 = nil

    self.biomeType1 = 0
    self.biomeType2 = 0
    self.biomeType3 = 0

    self.biomeID1 = 0
    self.biomeID2 = 0
    self.biomeID3 = 0

    self._buffer = buffer
    self._noise = noise
end

function SpecialTerrainProxies.checkXArea(x1, x2)
    x1 = math.max(0, x1)
    x2 = math.min(1023, x2)
    if x1 >= x2 then
        return x1, x2, false
    end
    return x1, x2, true
end

function SpecialTerrainProxies:createSurfaceCave(x1, x2)
    local valid = true
    x1, x2, valid = SpecialTerrainProxies.checkXArea(x1, x2)
    if not valid then
        return
    end

    local boundary = self.boundary
    local noise = self._noise
    local buffer = self._buffer
    local chunkYiInMap = self.chunkYiInMap

    local sample1 = buffer:GetSample(1)
    sample1.isFrontPreset = true
    sample1.isWallPreset = true
    sample1.biomeType = self.biomeType1
    sample1.biomeID = self.biomeID1

    local mask1 = buffer:GetMask(1)
    mask1.isFrontPreset = true
    mask1.isWallPreset = true
    mask1.biomeType = true
    mask1.biomeID = true

    local sample2 = buffer:GetSample(2)
    sample2.isWallPreset = true
    sample2.biomeType = self.biomeType1
    sample2.biomeID = self.biomeID1

    local mask2 = buffer:GetMask(2)
    mask2.isWallPreset = true
    mask2.biomeType = true
    mask2.biomeID = true

    for xi = x1, x2 - 1 do
        local surfaceYi = boundary[xi + 1] - chunkYiInMap
        local offset = math.floor(10 + math.sin((xi + surfaceYi) * 0.125) * 2)
        local length = 5
        offset = offset + noise:GetByteFromInt2D(xi, offset, 1)

        length = length + noise:GetByteFromInt2D(xi + 2, length, 1)
        if xi < x1 + 6 then
            length = math.floor(length * (1 - (x1 + 6 - xi) / 6.0))
        end
        if xi > x2 - 6 then
            length = math.floor(length * (1 - (xi - (x2 - 6)) / 6.0))
        end
        local backLength = offset
        if xi < x1 + 4 then
            backLength = math.floor(backLength * (1 - (x1 + 4 - xi) / 4.0))
        end
        if xi > x2 - 4 then
            backLength = math.floor(backLength * (1 - (xi - (x2 - 4)) / 4.0))
        end
        local y0 = surfaceYi - offset

        -- fill solid
        buffer:ApplySampleByMask(xi, y0 - length, 1, length, 1, 1)
        -- fill wall
        buffer:ApplySampleByMask(xi, y0, 1, backLength, 2, 2)

        boundary[xi + 1] = y0 - length
    end

    buffer:ClearSample(1)
    buffer:ClearMask(1)

    buffer:ClearSample(2)
    buffer:ClearMask(2)
end

function SpecialTerrainProxies:createSurfaceLake(x1, x2, liquidID, depth)
    local valid = true
    x1, x2, valid = SpecialTerrainProxies.checkXArea(x1, x2)
    if not valid then
        return
    end
    local size = x2 - x1

    local boundary = self.boundary
    local noise = self._noise
    local buffer = self._buffer
    local chunkYiInMap = self.chunkYiInMap

    local sample1 = buffer:GetSample(1)
    sample1.isLiquidPreset = true

    local mask1 = buffer:GetMask(1)
    mask1.isLiquidPreset = true

    local failed = false
    for xi = x1, x2 - 1 do
        local surfaceYi = boundary[xi + 1] - chunkYiInMap
        if buffer:HasAreaSameSampleByMask(xi, surfaceYi - 1, 1, depth + 1, 1, 1) then
            failed = true
            break
        end
    end

    if not failed then
        local maxSurfaceYi = -999999999
        for xi = x1, x2 - 1 do
            local surfaceYi = boundary[xi + 1] - chunkYiInMap
            maxSurfaceYi = math.max(maxSurfaceYi, surfaceYi)
            local offset = math.floor(math.sin((xi - x1) / size * math.pi) * depth)
            buffer:ClearFrontAndWallArea(xi, surfaceYi, 1, offset)
            boundary[xi + 1] = surfaceYi + offset
        end

        buffer:GenerateLake((x1 + x2) / 2, maxSurfaceYi, liquidID, 10000)
    end

    buffer:ClearSample(1)
    buffer:ClearMask(1)

end

return SpecialTerrainProxies