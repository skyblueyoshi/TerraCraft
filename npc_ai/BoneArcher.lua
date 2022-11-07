---@class TC.BoneArcher:TC.Archer
local BoneArcher = class("BoneArcher", require("Archer"))

function BoneArcher:Init()
    BoneArcher.super.Init(self)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("wooden_bow")))
    self.shootOffsetAngle = 0.2
end

return BoneArcher