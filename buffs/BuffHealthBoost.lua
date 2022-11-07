---@class TC.BuffHealthBoost:TC.BaseBuffProxy
local BuffHealthBoost = class("BuffHealthBoost", require("BaseBuffProxy"))

function BuffHealthBoost.OnUpdatePlayer(player, _)
    if player.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("heal"),
                player.randX,
                player.randY,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 2),
                0, 1.0, 1.0, Color.Red)
        player:Heal(1, false)
    end
end

return BuffHealthBoost