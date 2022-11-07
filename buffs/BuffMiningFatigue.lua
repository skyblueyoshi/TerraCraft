---@class TC.BuffMiningFatigue:TC.BaseBuffProxy
local BuffMiningFatigue = class("BuffMiningFatigue", require("BaseBuffProxy"))

function BuffMiningFatigue.OnUpdatePlayer(player, _)
    player.digSpeedRate = player.digSpeedRate + 0.5
    if player.tickTime % 32 == 0 then
        EffectUtils.Create(Reg.EffectID("heal"),
                player.randX,
                player.randY,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 2),
                0, 1.0, 1.0, Color.Yellow)
    end
end

return BuffMiningFatigue