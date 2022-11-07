---@class TC.BoneLee:TC.HumanFighter
local BoneLee = class("BoneLee", require("HumanFighter"))

function BoneLee:Update()
    BoneLee.super.Update(self)
    local npc = self.npc

    if npc.inLiquid then
        npc.speedY = - 8
    end
end

return BoneLee