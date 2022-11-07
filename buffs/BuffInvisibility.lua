---@class TC.BuffInvisibility:TC.BaseBuffProxy
local BuffInvisibility = class("BuffInvisibility", require("BaseBuffProxy"))

function BuffInvisibility.OnUpdatePlayer(player, _)
    player.isInvisibility = true
    if player.tickTime % 16 == 0 then
        EffectUtils.Create(Reg.EffectID("chip"),
                player.randX,
                player.randY,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-3, 3),
                Utils.RandSym(0.1),
                2,
                1.0,
                Color.new(100, 100, 200)
        )
    end
end

return BuffInvisibility