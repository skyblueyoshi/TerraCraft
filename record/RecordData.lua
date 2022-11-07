---@class TC.RecordData
local RecordData = class("RecordData")


local SNOW_QUEEN_ID = Reg.NpcID("snow_queen")
local HELL_DESTROYER_ID = Reg.NpcID("worm_head")
local CRISON_EYE_ID = Reg.NpcID("crison_eye")
local DUNGEON_EATER_ID = Reg.NpcID("dungeon_eater_head")

local s_RecordData = nil
---@return TC.RecordData
function RecordData.getInstance()
    if s_RecordData == nil then
        s_RecordData = RecordData.new()
    end
    return s_RecordData
end

function RecordData:__init()
    self.hasSnowQueen = false
    self.hasNetherDestroyer = false
    self.hasCrisonEye = false
    self.hasDungeonEater = false
    self.curBossID = -1
end

function RecordData:_updateNpc()
    self.hasSnowQueen = false
    self.hasNetherDestroyer = false
    self.hasCrisonEye = false
    self.hasDungeonEater = false
    self.curBossID = -1

    local npcs = NpcUtils.GetAllEntities()
    ---@param npc Npc
    for _, npc in each(npcs) do
        local id = npc.id
        if id == SNOW_QUEEN_ID then
            self.hasSnowQueen = true
            self.curBossID = id
        elseif id == HELL_DESTROYER_ID then
            self.hasNetherDestroyer = true
            self.curBossID = id
        elseif id == CRISON_EYE_ID then
            self.hasCrisonEye = true
            self.curBossID = id
        elseif id == DUNGEON_EATER_ID then
            self.hasDungeonEater = true
            self.curBossID = id
        end
    end

end

function RecordData:update()
    self:_updateNpc()
end

return RecordData