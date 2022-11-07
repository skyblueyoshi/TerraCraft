---@class TC.FlySkeleton:TC.HumanFighter
local FlySkeleton = class("FlySkeleton", require("HumanFighter"))

function FlySkeleton:Init()
    FlySkeleton.super.Init(self)

end

function FlySkeleton:Update()
    local npc = self.npc
    npc:Fly()
    if npc.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("flash2"), npc.randX, npc.randY, Utils.RandSym(0.2), Utils.RandSym(0.2), 0,
            Utils.RandDoubleArea(0.5, 0.5))
    end
    self.isFrontLegOverwrite = true
    self.isBackLegOverwrite = true
    self.frontLegOverwriteAngle = math.cos(npc.tickTime / 16) * 0.2 + 0.4
    self.backLegOverwriteAngle = math.sin(npc.tickTime / 16) * 0.2 + 0.4


end

return FlySkeleton