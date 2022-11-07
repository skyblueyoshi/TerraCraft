local TCWorldGen = class("TCWorldGen")
local ChunkGenerator = require("world_gen.ChunkGenerator")
local ModChunkGenerator = require("world_gen.ModChunkGenerator")

function TCWorldGen:init()
    self.noise = nil ---@type WorldGenNoise
end

function TCWorldGen:exit()
    ModChunkGenerator.destroy()
end

function TCWorldGen:startGenChunk(chunkXi, chunkYi, noise, buffer)
    self.noise = noise
    local chunkGenerator = ChunkGenerator.new(chunkXi, chunkYi, noise, buffer)
    chunkGenerator:start()
    chunkGenerator:destroy()
    collectgarbage()
end

function TCWorldGen:onSetBlockEntityFormat(formatId, data, xi, yi)

    local function _randomIndices(totals)
        local arr = {}
        local out = {}
        for i = 1, totals do
            arr[i] = i
        end
        for i = 1, totals do
            local pickIndex = self.noise:GetByteFromInt2D(xi + 451 * i, yi + 23, #arr) + 1
            table.insert(out, arr[pickIndex])
            table.remove(arr, pickIndex)
        end
        return out
    end

    if formatId == "tc:common_rewards" then
        local res = {}
        local inventoryData = {
            slotCount = 30,
            stacks = {}
        }
        local index = 0

        local function addReward(i, itemID, cnt)
            local out = { index = i, stack = {
                id = itemID, stackSize = cnt
            } }
            return out
        end

        local totalRares = #data.rares
        local ranIndices = _randomIndices(totalRares)
        for i = 1, math.min(#ranIndices, data.rareGenCount) do
            local rare = data.rares[ranIndices[i]]

            local out = addReward(index, rare.itemId, rare.count)
            table.insert(inventoryData.stacks, out)
            index = index + 1
        end
        for i = 1, #data.normals do
            local normal = data.normals[i]
            local testRate = math.abs(self.noise:GetDoubleFromInt2D(xi + 33 * i, yi + 77))
            if testRate < normal.rate then
                local cnt = normal.min + self.noise:GetByteFromInt2D(xi * 13, yi + 57, normal.max - normal.min)
                local itemID = normal.itemIds[
                        self.noise:GetByteFromInt2D(xi + 62, yi + 98, #normal.itemIds) + 1
                ]
                local out = addReward(index, itemID, cnt)
                table.insert(inventoryData.stacks, out)
                index = index + 1
            end
        end
        res = {
            inventory = inventoryData
        }
        return res
    elseif formatId == "tc:rewards" then
        return data
    elseif formatId == "tc:empty_furnace" then
        return {}
    end

    return data
end

return TCWorldGen