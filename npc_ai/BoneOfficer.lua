---@class TC.BoneOfficer:TC.Archer
local BoneOfficer = class("BoneOfficer", require("Archer"))

function BoneOfficer:Init()
    BoneOfficer.super.Init(self)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("soul_laserer")))
end

return BoneOfficer