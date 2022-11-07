---@type ModNpc
local MagmaSlime = class("MagmaSlime", require("Slime"))

function MagmaSlime:Update()
    MagmaSlime.super.Update(self)
    local npc = self.npc
    if npc.tickTime % 32 == 0 then
        EffectUtils.Create(Reg.EffectID("fire_flame"), npc.randX, npc.y,
                Utils.RandSym(1), -Utils.RandDouble(2),
                0, Utils.RandDoubleArea(0.75, 0.25))
    end
    LightingUtils.Add(npc.centerXi, npc.centerYi, 24, 12, 0, 0)
end

return MagmaSlime