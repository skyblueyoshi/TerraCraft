---@class TC.HeartCrystal:ModBlock
local HeartCrystal = class("HeartCrystal", ModBlock)
local PlayerConstants = require("player.PlayerConstants")

function HeartCrystal.OnDestroy(xi, yi, parameterDestroy)
    for i = 1, 32 do
        local effectAngle = Utils.RandSym(math.pi)
        local d = 240
        local effectX = xi * 16 + 8 + math.cos(effectAngle) * d
        local effectY = (yi - 1) * 16 + 8 + math.sin(effectAngle) * d

        local effectSpeed = 4 - Utils.RandDouble(1.5)
        local effectSpeedAngle = Utils.FixAngle(effectAngle + math.pi)
        local spx = math.cos(effectSpeedAngle) * effectSpeed
        local spy = math.sin(effectSpeedAngle) * effectSpeed

        local colorChannel = Utils.RandIntArea(200, 50)

        local effect = EffectUtils.SendFromServer(
                Reg.EffectID("flash2"),
                effectX,
                effectY,
                spx,
                spy,
                Utils.RandSym(0.5),
                Utils.RandDoubleArea(1.0, 0.55),
                1,
                Color.new(colorChannel, colorChannel * 0.45, colorChannel * 0.45)
        )
        effect:SetDisappearTime(120)
    end
    SoundUtils.PlaySound(Reg.SoundID("travel"), xi, yi)
    local players = PlayerUtils.SearchByCircle(xi * 16 + 8, yi * 16 + 8, 64 * 16)
    ---@param player Player
    for _, player in each(players) do
        player:AddExperience(35)
        local addValue = 20
        player.maxHealth = math.min(player.maxHealth + addValue, PlayerConstants.MaxHealthA)
        player:Heal(addValue)
    end
end

return HeartCrystal