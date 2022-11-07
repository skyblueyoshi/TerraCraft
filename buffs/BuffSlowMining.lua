---@class TC.BuffSlowMining:TC.BaseBuffProxy
local BuffSlowMining = class("BuffSlowMining", require("BaseBuffProxy"))

function BuffSlowMining.OnUpdatePlayer(player, _)
    player.digSpeedRate = player.digSpeedRate - 0.5
    if player.tickTime % 32 == 0 then
        EffectUtils.Create(Reg.EffectID("heal"),
                player.randX,
                player.randY,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 2),
                0, 1, 1, Color.new(32, 32, 32))
    end
end

return BuffSlowMining