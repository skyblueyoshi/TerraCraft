---@class TC.BuffResistance:TC.BaseBuffProxy
local BuffResistance = class("BuffResistance", require("BaseBuffProxy"))

function BuffResistance.OnUpdatePlayer(player, _)
    player.baseDefense.defense = player.baseDefense.defense + 4
end

return BuffResistance