---@class TC.ModChunkGenerator
local ModChunkGenerator = class("ModChunkGenerator")

local s_proxy = {}

---__init
---@param generator TC.ChunkGenerator
function ModChunkGenerator:__init(generator)
    ---@type TC.ChunkGenerator
    self._generator = generator
end

function ModChunkGenerator.getProxy()
    return s_proxy
end

function ModChunkGenerator.register(modChunkGeneratorClass)
    table.insert(s_proxy, modChunkGeneratorClass)
end

function ModChunkGenerator.destroy()
    s_proxy = {}
end

function ModChunkGenerator:onInitLayer()
end

function ModChunkGenerator:onGenerateUndergroundMatrix()
end

function ModChunkGenerator:onGenerateBuildings()
end

function ModChunkGenerator:onPostGenerateCaves()
end

return ModChunkGenerator