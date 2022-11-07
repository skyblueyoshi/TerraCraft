---@class TC.BuffGlowing:TC.BaseBuffProxy
local BuffGlowing = class("BuffGlowing", require("BaseBuffProxy"))

function BuffGlowing.OnUpdatePlayer(player, _)
    -- Client effect only.
    if NetMode.current == NetMode.Server then
        return
    end
    if player.tickTime % 16 == 0 then
        EffectUtils.Create(Reg.EffectID("chip"),
                player.randX,
                player.randY,
                Utils.RandSym(2),
                Utils.RandDoubleArea(-4, 2),
                0,
                Utils.RandDoubleArea(1, 2),
                1.0,
                Color.Yellow
        )
    end
    LightingUtils.AddDelay(player.centerXi, player.centerYi, 32, 28)
end

return BuffGlowing