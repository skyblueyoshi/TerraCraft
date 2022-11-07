---@class TC.RedstonePlate:ModBlock
local RedstonePlate = class("RedstonePlate", ModBlock)

function RedstonePlate.OnPlayerOverlap(xi, yi, player)
	if player.stand and math.abs(player.bottomY - (yi + 1) * 16) < 4 then
		MapUtils.TriggerSignal(xi, yi, true)
		MapUtils.DelayTriggerSignal(xi, yi, false, 32)
	end
end

return RedstonePlate