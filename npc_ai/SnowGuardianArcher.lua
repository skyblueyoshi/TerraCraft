---@class TC.SnowGuardianArcher:TC.Archer
local SnowGuardianArcher = class("SnowGuardianArcher", require("Archer"))

function SnowGuardianArcher:Init()
    SnowGuardianArcher.super.Init(self)

    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("ice_bow")))
end

function SnowGuardianArcher:Update()
    SnowGuardianArcher.super.Update(self)
    local npc = self.npc
    if npc.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("flash2"), npc.randX, npc.randY, Utils.RandSym(0.2), Utils.RandSym(0.2), 0,
                Utils.RandDoubleArea(0.5, 0.5))
    end
end

return SnowGuardianArcher