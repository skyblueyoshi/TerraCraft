---@class TC.SnowQueenBall:ModBlock
local SnowQueenBall = class("SnowQueenBall", ModBlock)
local RecordData = require("record.RecordData")

function SnowQueenBall.OnClicked(xi, yi, parameterClick)
    if RecordData.getInstance().hasSnowQueen then
        return
    end
    local npc = NpcUtils.Create(Reg.NpcID("snow_queen"), xi * 16, yi * 16 - 160, 0, -8)
    local modNpc = npc:GetModNpc()
    if modNpc ~= nil then
        modNpc.hookXi = xi
        modNpc.hookYi = yi
    end
    SoundUtils.PlaySound(Reg.SoundID("monster"), xi, yi)
end

return SnowQueenBall