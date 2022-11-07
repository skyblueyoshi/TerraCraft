---@class TC.BuffRegeneration:TC.BaseBuffProxy
local BuffRegeneration = class("BuffRegeneration", require("BaseBuffProxy"))

function BuffRegeneration.OnUpdatePlayer(player, _)
    if player.tickTime % 8 == 0 then
        EffectUtils.Create(Reg.EffectID("heal"),
                player.randX,
                player.randY,
                Utils.RandSym(1),
                Utils.RandDoubleArea(-2, 2),
                0, 1, 1, Color.Red)
        player:Heal(1, false)
    end
end

return BuffRegeneration