---@class TC.BuffSlowFalling:TC.BaseBuffProxy
local BuffSlowFalling = class("BuffSlowFalling", require("BaseBuffProxy"))

function BuffSlowFalling.OnUpdatePlayer(player, _)
    player.fallSpeedRate = player.fallSpeedRate - 0.75
    if player.speedY > 1 then
        if player.tickTime % 8 == 0 then
            EffectUtils.Create(Reg.EffectID("chip"),
                    player.randX,
                    player.bottomY,
                    Utils.RandSym(1),
                    Utils.RandDoubleArea(2, 2),
                    Utils.RandSym(0.1),
                    2,
                    0.6,
                    Color.new(200, 200, 200)
            )
        end
    end
end

return BuffSlowFalling