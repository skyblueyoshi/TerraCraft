---@class TC.BuffLevitation:TC.BaseBuffProxy
local BuffLevitation = class("BuffLevitation", require("BaseBuffProxy"))

function BuffLevitation.OnUpdatePlayer(player, _)
    if not player.stand then
        if player.speedY > -1 then
            player.speedY = player.speedY - 0.2
        else
            player.speedY = -1
        end
    end
    if player.tickTime % 8 == 0 then
        EffectUtils.Create(Reg.EffectID("smoke"),
                player.randX,
                player.bottomY,
                Utils.RandSym(1),
                Utils.RandDouble(2),
                Utils.RandSym(0.1),
                0.5)
    end
end

return BuffLevitation