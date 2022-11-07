---@class TC.BuffHunger:TC.BaseBuffProxy
local BuffHunger = class("BuffHunger", require("BaseBuffProxy"))

function BuffHunger.OnUpdatePlayer(player, _)
    if player.tickTime % 128 == 0 then
        player:DecFood(1)
    end
    if player.tickTime % 64 == 0 then
        EffectUtils.Create(Reg.EffectID("chip"),
                player.randX,
                player.y,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 2),
                Utils.RandSym(0.1),
                2,
                0.6,
                Color.new(32, 32, 32)
        )
    end
end

return BuffHunger