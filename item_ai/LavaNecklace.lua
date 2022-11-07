---@class TC.LavaNecklace:TC.BaseAccessory
local LavaNecklace = class("LavaNecklace", require("BaseAccessory"))

---OnAccessory
---@param player Player
function LavaNecklace:OnAccessoryUpdate(player)
    if NetMode.current == NetMode.Client then
        local cnt = 3
        for i = 1, cnt do
            local angle = player.tickTime / 10 + math.pi * 2 / cnt * i
            local d = 45
            local x = player.centerX + math.cos(angle) * d
            local y = player.centerY + math.sin(angle) * d
            local effect = EffectUtils.Create(
                    Reg.EffectID("circle"),
                    x,
                    y,
                    Utils.RandSym(0.5),
                    Utils.RandSym(0.5),
                    0,
                    Utils.RandDoubleArea(0.25, 0.15),
                    Utils.RandDoubleArea(0.25, 0.15),
                    Color.new(255, 255, 0)
            )
            effect:SetDisappearTime(6)

            local effect = EffectUtils.Create(
                    Reg.EffectID("chip"),
                    x,
                    y,
                    Utils.RandSym(1.5),
                    Utils.RandSym(1.5),
                    0,
                    Utils.RandDoubleArea(0.75, 0.5),
                    Utils.RandDoubleArea(0.5, 0.5),
                    Color.new(255, 255, 0)
            )
            effect:SetDisappearTime(12)

        end

        --if player.tickTime % 8 == 0 then
        --    local effect = EffectUtils.Create(Reg.EffectID("heal"),
        --            player.randX, player.randY,
        --            Utils.RandSym(1), Utils.RandDoubleArea(-2, 2)
        --    )
        --    effect:SetDisappearTime(10)
        --
        --end
    else
        if player.tickTime % 64 == 0 then
            player:AddBuff(Reg.BuffID("fire_defense"), 100)
        end
    end
end

return LavaNecklace