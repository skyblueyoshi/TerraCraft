---@class TC.BuffSlowness:TC.BaseBuffProxy
local BuffSlowness = class("BuffSlowness", require("BaseBuffProxy"))

function BuffSlowness.OnUpdatePlayer(player, _)
	player.speedRate = player.speedRate - 0.4
end

return BuffSlowness