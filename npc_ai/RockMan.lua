---@class TC.RockMan:TC.Archer
local RockMan = class("RockMan", require("Archer"))

function RockMan:Init()
    RockMan.super.Init(self)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("soul_laserer")))
end

return RockMan