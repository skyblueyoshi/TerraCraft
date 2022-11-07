---@class TC.TerrainProxies
---Store all calculation about how to modify a boundary array.
---
---维护所有可以改变边界数组的算法。
local TerrainProxies = class("TerrainProxies")

function TerrainProxies:__init()
    self._proxies = {
        FlatTerrain = TerrainProxies.calculateBoundary_FlatTerrain,
        MountainTerrain = TerrainProxies.calculateBoundary_MountainTerrain,
        HillTerrain = TerrainProxies.calculateBoundary_HillTerrain,
        BasinTerrain = TerrainProxies.calculateBoundary_BasinTerrain,
        PlateauTerrain = TerrainProxies.calculateBoundary_PlateauTerrain,
    }
end

--- Modify the boundary array by specify terrain function.
---@param terrainName string
---@param boundary double[]
---@param xi int
---@param size int
---@param height int
function TerrainProxies:calculateBoundaryFromTerrain(terrainName, boundary, xi, size, height)
    if size > 1010 then
        -- too big, do nothing.
        return
    end
    local func = self._proxies[terrainName]
    if func == nil then
        return
    end
    local x1, x2 = xi - math.floor(size / 2), xi + math.floor(size / 2)
    if x1 < 0 then
        x1 = 0
        x2 = x1 + size
    end
    if x2 >= 1024 then
        x2 = 1023
        x1 = x2 - size
    end
    if x2 > x1 then
        func(self, boundary, x1, x2, height)
    end
end

--- Flat, do nothing.
---
--- 平坦，什么都不做
function TerrainProxies:calculateBoundary_FlatTerrain(boundary, x1, x2, height)
    return
end

--- Mountain, a SIN function.
---
--- 大山（坟包），长得像三角函数的样子
function TerrainProxies:calculateBoundary_MountainTerrain(boundary, x1, x2, height)
    local sin = math.sin
    local size = x2 - x1
    local c = math.pi / size
    for x = x1, x2 - 1 do
        local res = sin((x - x1) * c) * height
        boundary[x + 1] = boundary[x + 1] - res
    end
end

--- 丘陵
function TerrainProxies:calculateBoundary_HillTerrain(boundary, x1, x2, height)
    local sin = math.sin
    local size = x2 - x1
    local c = math.pi / 64
    local offset = math.floor(size / 4)
    local invOffset = 1.0 / offset
    for x = x1, x2 - 1 do
        local res = sin((x - x1) * c) * height
        if x < x1 + offset then
            res = res * (1 - (x1 + offset - x) * invOffset)
        end
        if x > x2 - offset then
            res = res * (1 - (x - x2 + offset) * invOffset)
        end
        boundary[x + 1] = boundary[x + 1] - res
    end
end

--- 盆地
function TerrainProxies:calculateBoundary_BasinTerrain(boundary, x1, x2, height)
    local sin = math.sin
    local size = x2 - x1
    local c = math.pi / size
    for x = x1, x2 - 1 do
        local res = sin((x - x1) * c) * height
        boundary[x + 1] = boundary[x + 1] + res
    end
end

--- 高原
function TerrainProxies:calculateBoundary_PlateauTerrain(boundary, x1, x2, height)
    local size = x2 - x1
    local d = math.floor(size / 32)
    if d == 0 then
        return
    end
    local sin = math.sin
    local side = math.floor(size / 16)
    local halfSide = math.floor(size / 32)
    local leftSide = x1 + side
    local halfLeftSide = x1 + halfSide
    local rightSide = x2 - side
    local halfRightSide = x2 - halfSide
    local halfHeight = height * 0.5
    local c = math.pi * 0.5 / d
    for x = x1, leftSide - 1 do
        local res = sin((x - halfLeftSide) * c) * halfHeight + halfHeight
        boundary[x + 1] = boundary[x + 1] - res
    end
    for x = leftSide, rightSide - 1 do
        boundary[x + 1] = boundary[x + 1] - height
    end
    for x = rightSide, x2 - 1 do
        local res = sin((halfRightSide - x) * c) * halfHeight + halfHeight
        boundary[x + 1] = boundary[x + 1] - res
    end
end

return TerrainProxies