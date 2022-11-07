---@class TC.EnchantmentThorns:TC.BaseEnchantmentProxy
local EnchantmentThorns = class("EnchantmentThorns")

function EnchantmentThorns.OnEquippedHitByNpc(equipmentIndex, level, player, itemStack, npc)
    local hitAngle = player:GetAngleTo(npc.centerX, npc.centerY)

    npc:Strike(Attack.new(1 + level, 1 + level, 0), hitAngle)
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("thorns_hit"), player.centerXi, player.centerYi)
    local initAngle = Utils.RandDouble(math.pi)
    local times = Utils.RandIntArea(4, 4)

    for i = 0, times do
        local angle = initAngle + i * math.pi * 2 / times
        EffectUtils.SendFromServer(Reg.EffectID("heal"),
                player.centerX,
                player.centerY,
                math.cos(angle) * 3,
                math.sin(angle) * 3,
                Utils.RandSym(0.1),
                Utils.RandDoubleArea(1, 0.5),
                1.0,
                Color.Red
        )
    end
end

return EnchantmentThorns