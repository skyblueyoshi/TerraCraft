---@class TC.SnowGuardian:TC.SwordHumanFighter
local SnowGuardian = class("SnowGuardian", require("SwordHumanFighter"))

function SnowGuardian:Init()
	SnowGuardian.super.Init(self)
    self:SetHeldItemByIDName("stone_sword")
end

function SnowGuardian:Update()
    SnowGuardian.super.Update(self)
    local npc = self.npc
    npc:Fly()
    if npc.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("flash2"), npc.randX, npc.randY, Utils.RandSym(0.2), Utils.RandSym(0.2), 0,
            Utils.RandDoubleArea(0.5, 0.5))
    end
end

return SnowGuardian