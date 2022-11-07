---@class TC.BuffBlindness:TC.BaseBuffProxy
local BuffBlindness = class("BuffBlindness", require("BaseBuffProxy"))

function BuffBlindness.OnUpdatePlayer(player, _)
    -- Client effect only.
    if NetMode.current == NetMode.Server then
        return
    end
    if player.isCurrentClientPlayer then
		LightingUtils.SetState(LightingUtils.LIGHTING_STATE_BLINDNESS)
	end
end

return BuffBlindness
