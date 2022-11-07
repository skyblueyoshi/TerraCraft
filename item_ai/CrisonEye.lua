---@class TC.CrisonEyeItem:TC.BossCaller
local CrisonEye = class("CrisonEye", require("BossCaller"))
local RecordData = require("record.RecordData")

function CrisonEye:CanUse(player)
    if MiscUtils.isNight then
        if not RecordData.getInstance().hasCrisonEye then
            return true
        end
    end
    return false
end

---@param player Player
function CrisonEye:GenBoss(player)
    NpcUtils.Create(Reg.NpcID("crison_eye"), player.centerX - 700, player.centerY - 400)
end

return CrisonEye