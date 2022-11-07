---@class WorldData
---@field worldName string
---@field worldSeed int
---@field gameTime int
---@field dayTime int
---@field realDayTime double
---@field daySpeed double
---@field spawnXi int
---@field spawnYi int
---@field weatherTime int
---@field gameMode int
---@field windSpeed double
---@field windAcc double
---@field weatherRate double
---@field isOnWeather boolean
---@field noPvp boolean
---@field noBlowTiles boolean
---@field useLoginSystem boolean
---@field noAllowWrongFormatPlayerName boolean
---@field clientSideCharacters boolean
local WorldData = {}

---@return WorldData
function WorldData.new()
end

return WorldData