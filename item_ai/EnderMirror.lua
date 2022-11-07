---@class TC.EnderMirror:ModItem
local EnderMirror = class("EnderMirror", ModItem)

function EnderMirror:Init()

end

function EnderMirror:CanUse(player)
    return true
end

function EnderMirror:OnHeld(player)
end

function EnderMirror:OnUsed(player)
    local ok = player:GoHome()
    if not ok then
        player:TeleportToSpawn()
    end
    player:FinishAdvancement(Reg.AdvancementID("mirror"))
    SoundUtils.PlaySound(Reg.SoundID("travel"), player.centerXi, player.centerYi)
end

function EnderMirror:GenBoss(player)
end

function EnderMirror:IsKilledAfterUsed()
    return false
end

return EnderMirror