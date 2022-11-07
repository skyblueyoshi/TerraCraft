---@class TC.DungeonSkeleton:TC.SwordHumanFighter
local DungeonSkeleton = class("DungeonSkeleton", require("SwordHumanFighter"))

function DungeonSkeleton:Init()
    DungeonSkeleton.super.Init(self)
    if self.style == 0 then
        self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("stone_sword")))
    elseif self.style == 1 then
        self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("lead_sword")))
    elseif self.style == 2 then
        self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("super_lead_sword")))
    elseif self.style == 3 then
        self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("super_copper_sword")))
    end

    if self.style == 0 then
        self.isFrontHandLook = false
        self.isBackHandLook = false
    end
end

function DungeonSkeleton:Update()
    DungeonSkeleton.super.Update(self)

    local npc = self.npc
    if Utils.RandTry(128) and npc.stand then
        npc.speedY = -6
        npc.speedX = npc.speedX * 1.5
    end

    if npc.inLiquid then
        npc.speedY = - 8
    end
end

function DungeonSkeleton:OnWaitSwing()
    local npc = self.npc
    if self.style == 1 then
        self.frontHandLookAngle = math.cos(npc.tickTime / 16) / 4
        self.backHandLookAngle = math.sin(npc.tickTime / 16) / 4
    elseif self.style == 2 then
        self.frontHandLookAngle = math.pi / 3 + math.cos(npc.tickTime / 8) / 8
        self.backHandLookAngle = math.pi / 3 + math.cos(npc.tickTime / 8) / 8
    elseif self.style == 3 then
        self.frontHandLookAngle = -math.pi / 3 + math.cos(npc.tickTime / 12) / 4
        self.backHandLookAngle = -math.pi / 3 + math.cos(npc.tickTime / 12) / 4
    end
end

return DungeonSkeleton