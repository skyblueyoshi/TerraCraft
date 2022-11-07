---@class TC.BuffVision:TC.BaseBuffProxy
local BuffVision = class("BuffVision", require("BaseBuffProxy"))

function BuffVision.OnUpdatePlayer(player, _)
    if player.isCurrentClientPlayer then
        LightingUtils.SetState(LightingUtils.LIGHTING_STATE_NIGHT_VISION)
    end
end

return BuffVision