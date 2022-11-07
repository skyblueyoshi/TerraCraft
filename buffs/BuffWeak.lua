---@class TC.BuffWeak:TC.BaseBuffProxy
local BuffWeak = class("BuffWeak", require("BaseBuffProxy"))

function BuffWeak.OnUpdatePlayer(player, _)
    player.baseAttack.attack = math.max(player.baseAttack.attack - 8, 0)
end

return BuffWeak