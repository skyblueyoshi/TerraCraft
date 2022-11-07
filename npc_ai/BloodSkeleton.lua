---@type ModNpc
local BloodSkeleton = class("BloodSkeleton", require("Archer"))

function BloodSkeleton:Init()
    BloodSkeleton.super.Init(self)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("blood_bow")))
    self.shootOffsetAngle = 0.2
end

return BloodSkeleton
