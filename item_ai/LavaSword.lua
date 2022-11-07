---@class TC.LavaSword:TC.Sword
local LavaSword = class("LavaSword", require("Sword"))

function LavaSword:ModifyHitNpc(npc, baseAttack)
    npc:AddBuff(Reg.BuffID("fire"), 128)
    return true
end

return LavaSword