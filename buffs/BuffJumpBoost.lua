---@class TC.BuffJumpBoost:TC.BaseBuffProxy
local BuffJumpBoost = class("BuffJumpBoost", require("BaseBuffProxy"))

function BuffJumpBoost.OnUpdatePlayer(player, _)
	player.jumpRate = player.jumpRate + 0.5
end

return BuffJumpBoost