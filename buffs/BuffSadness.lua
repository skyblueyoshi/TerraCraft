---@class TC.BuffSadness:TC.BaseBuffProxy
local BuffSadness = class("BuffSadness", require("BaseBuffProxy"))

function BuffSadness.OnUpdatePlayer(player, _)
    player.baseDefense.defense = math.max(player.baseDefense.defense - 2, 0)
end

return BuffSadness