---@class TC.BuffPoison:TC.BaseBuffProxy
local BuffPoison = class("BuffPoison", require("BaseBuffProxy"))

function BuffPoison.OnUpdatePlayer(player, _)
    if player.tickTime % 16 == 0 then
        EffectUtils.Create(Reg.EffectID("poison"),
                player.randX,
                player.y,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 1),
                0,
                1,
                0.5)
    end
    if player.tickTime % 16 == 0 then
        player:Strike(DeathReason.POISON, Attack.new(1, 0, 0), 0, false, false)
    end
end

return BuffPoison