---@class TC.BoneSniper:TC.Archer
local BoneSniper = class("BoneSniper", require("Archer"))

function BoneSniper:Init()
    BoneSniper.super.Init(self)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("sword_fish_gun")))
end

return BoneSniper