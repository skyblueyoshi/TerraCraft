---@class TC.BuffFire:TC.BaseBuffProxy
local BuffFire = class("BuffFire", require("BaseBuffProxy"))

function BuffFire.OnUpdatePlayer(player, _)
    if not player:HasBuff(Reg.BuffID("fire_defense")) then
        local fireDefense = player.baseDefense.flameDefense
        local interval = 16 * (1 + fireDefense)
        if interval > 0 then
            if player.tickTime % interval == 0 then
                player:Strike(DeathReason.BURN,
                        Attack.new(1, 0, 0),
                        0, false, false)
            end
        end
    end
    if NetMode.current == NetMode.Client then
        if player.tickTime % 8 == 0 then
            EffectUtils.Create(Reg.EffectID("flame_star"),
                    player.randX,
                    player.randY,
                    Utils.RandSym(1),
                    Utils.RandSym(1),
                    0,
                    Utils.RandDoubleArea(1, 1)
            )
            EffectUtils.Create(Reg.EffectID("fire_flame"),
                    player.randX,
                    player.randY,
                    Utils.RandSym(1),
                    -Utils.RandDouble(2),
                    0,
                    Utils.RandDoubleArea(0.5, 0.5)
            )
        end
    end
end

return BuffFire