---@class TC.BossCaller:ModItem
local BossCaller = class("BossCaller", ModItem)

function BossCaller:Init()
    self.isBossCaller = true
end

function BossCaller:CanUse(player)
    return true
end

function BossCaller:OnUsed(player)
    self:GenBoss(player)
    SoundUtils.PlaySound(Reg.SoundID("monster"), player.centerXi, player.centerYi)
end

function BossCaller:GenBoss(player)
end

function BossCaller:IsKilledAfterUsed()
    return true
end

return BossCaller