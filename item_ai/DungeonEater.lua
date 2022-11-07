---@class TC.DungeonEaterItem:TC.BossCaller
local DungeonEater = class("DungeonEater", require("BossCaller"))
local RecordData = require("record.RecordData")

function DungeonEater:CanUse(player)
    if not RecordData.getInstance().hasDungeonEater then
        if player.biomeID == Reg.BiomeID("more_dungeons:tr_dungeon") then
            return true
        end
    end
    return false
end

---@param player Player
function DungeonEater:GenBoss(player)
    NpcUtils.Create(Reg.NpcID("dungeon_eater_head"), player.centerX - 700, player.centerY + 300)
end

return DungeonEater