---@class TC.BuffStrength:TC.BaseBuffProxy
local BuffStrength = class("BuffStrength", require("BaseBuffProxy"))

function BuffStrength.OnUpdatePlayer(player, _)
    player.baseAttack.attack = player.baseAttack.attack + 3
end

return BuffStrength