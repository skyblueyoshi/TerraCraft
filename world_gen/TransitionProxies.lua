---@class TC.SurfaceTransitionProxies
---Store all algorithms of how to transition between surface biomes.
---
---维护地表结构的群系过渡算法。
local SurfaceTransitionProxies = class("TransitionProxies")

---__init
---@param chunkXi int
---@param chunkYi int
---@param noise WorldGenNoise
---@param buffer WorldGenChunkBuffer
function SurfaceTransitionProxies:__init(chunkXi, chunkYi, noise, buffer)
    -- TODO:DiscreteTransition
    self._noise = noise
    self._buffer = buffer
    self._chunkXi = chunkXi
    self._chunkYi = chunkYi
    self._levelProxies = {
        LinerTransition = SurfaceTransitionProxies.getTransitionLevel_Liner,
        ParabolaTransition = SurfaceTransitionProxies.getTransitionLevel_Parabola,
        DiscreteTransition = SurfaceTransitionProxies.getTransitionLevel_Discrete,
    }
end

---doTransition
---@param leftTransitionName string
---@param rightTransitionName string
---@param x1 int
---@param x2 int
---@param topBoundary int[]
---@param bottomBoundary int[]
---@param biomeInfo table
---@param checkFromChunkTop boolean
---@param checkFromChunkBottom boolean
function SurfaceTransitionProxies:doTransition(leftTransitionName, rightTransitionName, x1, x2, topBoundary, bottomBoundary,
                                               biomeInfo, checkFromChunkTop, checkFromChunkBottom)
    if not (x1 >= 0 and x2 <= 1024 and x2 > x1) then
        return
    end
    local isLeftTransiting = (leftTransitionName ~= nil)
    local isRightTransiting = (rightTransitionName ~= nil)

    if not isLeftTransiting and not isRightTransiting then
        return
    end

    local leftFunc
    local rightFunc
    if isLeftTransiting then
        leftFunc = self._levelProxies[leftTransitionName]
        if leftFunc == nil then
            return
        end
    end
    if isRightTransiting then
        rightFunc = self._levelProxies[rightTransitionName]
        if rightFunc == nil then
            return
        end
    end
    local max = math.max
    local min = math.min
    local floor = math.floor
    local buffer = self._buffer
    local noise = self._noise

    local chunkXiInMap = self._chunkXi * 1024
    local chunkYiInMap = self._chunkYi * 1024
    local leftBiomeType = biomeInfo[1][1]
    local leftBiomeID = biomeInfo[1][2]
    local rightBiomeType = biomeInfo[3][1]
    local rightBiomeID = biomeInfo[3][2]
    local currentBiomeType = biomeInfo[2][1]
    local currentBiomeID = biomeInfo[2][2]
    local centerXi = floor((x1 + x2) / 2)

    if currentBiomeType ~= leftBiomeType or currentBiomeType ~= rightBiomeType then
        return
    end

    for xi = x1, x2 - 1 do
        local mapXi = chunkXiInMap + xi
        local usingLevelFlag = 0
        local level = 0
        local adjBiomeID = currentBiomeID
        local inLeftSide = xi < centerXi

        if inLeftSide then
            if isLeftTransiting then
                usingLevelFlag = 1
                level = leftFunc(noise, mapXi, xi - x1)
                adjBiomeID = leftBiomeID
            end
        else
            if isRightTransiting then
                usingLevelFlag = 2
                level = rightFunc(noise, mapXi, x2 - xi)
                adjBiomeID = rightBiomeID
            end
        end
        local top = 0
        local bottom = 1024
        local topBoundaryValue = topBoundary[xi + 1]
        local bottomBoundaryValue = bottomBoundary[xi + 1]
        if not checkFromChunkTop then
            top = max(topBoundaryValue - chunkYiInMap, 0)
        end
        if not checkFromChunkBottom then
            bottom = min(bottomBoundaryValue - chunkYiInMap, 1024)
        end
        if usingLevelFlag ~= 0 then
            local splitYi = math.max(0, topBoundaryValue - chunkYiInMap + level)
            buffer:SetBiomeIDAreaByBiomeType(xi, top, 1, splitYi, currentBiomeType, currentBiomeID)
            buffer:SetBiomeIDAreaByBiomeType(xi, splitYi, 1, bottom - splitYi, currentBiomeType, adjBiomeID)
        else
            buffer:SetBiomeIDAreaByBiomeType(xi, top, 1, bottom - top, currentBiomeType, currentBiomeID)
        end
    end
end

---y=x
function SurfaceTransitionProxies.getTransitionLevel_Liner(noise, mapXi, d)
    return noise:GetDoubleFromInt1D(mapXi) * 2 + d
end

---y=x^2
function SurfaceTransitionProxies.getTransitionLevel_Parabola(noise, mapXi, d)
    return noise:GetDoubleFromInt1D(mapXi) * 2 + d * d * 0.01
end

---y=x
function SurfaceTransitionProxies.getTransitionLevel_Discrete(noise, mapXi, d)
    return SurfaceTransitionProxies.getTransitionLevel_Liner(noise, mapXi, d)
end

return SurfaceTransitionProxies