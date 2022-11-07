---@class TC.BuffSpeed:TC.BaseBuffProxy
local BuffSpeed = class("BuffSpeed", require("BaseBuffProxy"))

function BuffSpeed.OnUpdatePlayer(player, _)
    player.speedRate = player.speedRate + 0.6
    if math.abs(player.speedX) > 2 then
        if player.tickTime % 4 == 0 then
            if player.stand then
                EffectUtils.Create(Reg.EffectID("smoke"),
                        player.randX,
                        player.bottomY,
                        Utils.RandSym(0.25),
                        Utils.RandSym(0.25),
                        Utils.RandSym(0.1), 0.25)
            else
                EffectUtils.Create(Reg.EffectID("smoke"),
                        player.randX,
                        player.randY,
                        -player.speedX / 8 + Utils.RandSym(0.5),
                        -player.speedY / 8 + Utils.RandSym(0.5),
                        Utils.RandSym(0.1), 0.5)
            end
        end
    end
end

return BuffSpeed