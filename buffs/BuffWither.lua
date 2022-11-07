---@class TC.BuffWither:TC.BaseBuffProxy
local BuffWither = class("BuffWither", require("BaseBuffProxy"))

function BuffWither.OnUpdatePlayer(player, _)
    if player.tickTime % 16 == 0 then
        EffectUtils.Create(Reg.EffectID("chip"),
                player.randX,
                player.y,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 1),
                0, 1, 0.5, Color.new(32, 32, 32))

        player:Strike(DeathReason.BUFF, Attack.new(1, 0, 0), 0, false, false)
    end
end

return BuffWither