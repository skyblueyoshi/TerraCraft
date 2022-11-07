---@type ModNpc
local TaintedSlime = class("TaintedSlime", require("Slime"))

function TaintedSlime:Update()
    TaintedSlime.super.Update(self)
    local npc = self.npc
    if npc.tickTime % 16 == 0 then
        EffectUtils.Create(Reg.EffectID("ender_flash"), npc.randX, npc.randY, Utils.RandSym(1), Utils.RandSym(1))
    end
end

return TaintedSlime