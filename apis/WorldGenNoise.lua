---@class WorldGenNoise
local WorldGenNoise = {}

---SetData
---@param persistence double
---@param octaves int
function WorldGenNoise:SetData(persistence, octaves)
end

---Perlin2D, return (-1.0, 1.0)
---@param x double
---@param y double
---@return double
function WorldGenNoise:Perlin2D(x, y)
end

---Perlin1D, return (-1.0, 1.0)
---@param x double
---@return double
function WorldGenNoise:Perlin1D(x)
end

---GetDoubleFromInt1D, return (-1.0, 1.0)
---@param xi int
---@return double
function WorldGenNoise:GetDoubleFromInt1D(xi)
end

---GetDoubleFromInt2D, return (-1.0, 1.0)
---@param xi int
---@param yi int
---@return double
function WorldGenNoise:GetDoubleFromInt2D(xi, yi)
end

---GetByteFromInt2D, return [0, maxByte)
---@param xi int
---@param yi int
---@param maxByte int
---@return int
function WorldGenNoise:GetByteFromInt2D(xi, yi, maxByte)
end

return WorldGenNoise