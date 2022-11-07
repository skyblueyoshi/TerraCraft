---@class TC.BuffHappiness:TC.BaseBuffProxy
local BuffHappiness = class("BuffHappiness", require("BaseBuffProxy"))

function BuffHappiness.OnUpdatePlayer(player, _)
    if player.tickTime % 64 == 0 then
        EffectUtils.Create(Reg.EffectID("heal"),
                player.randX,
                player.randY,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 2),
                0.0, 1.0, 1.0, Color.Red
        )
        player:Heal(1, false)
    end
end

return BuffHappiness