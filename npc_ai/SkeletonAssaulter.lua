---@class TC.SkeletonAssaulter:TC.HumanFighter
local SkeletonAssaulter = class("SkeletonAssaulter", require("HumanFighter"))

local State = {
    NORMAL = 0,
    NO_MOVE = 1
}

function SkeletonAssaulter:Init()
    SkeletonAssaulter.super.Init(self)

    self.inventory = Inventory.new(1)
    self.npc.dataWatcher:AddInventory(self.inventory)

    self.itemSlotHeld = self.inventory:GetSlot(0)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("sniper")))

    self.shootTimes = 0
end

function SkeletonAssaulter:Update()
    local npc = self.npc
    npc.noMove = true

    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    npc.state = State.NORMAL
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
    end

    self.isHeadLook = true
    self.headLookAngle = npc.watchAngle
    self.headLookDenominator = 2.0

    self.isBackHandLook = true
    self.isFrontHandLook = true
    self.backHandLookAngle = npc.watchAngle
    self.frontHandLookAngle = npc.watchAngle

    npc.state = State.NORMAL
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 540 and self.shootTimes ~= 0 then
            npc.state = State.NO_MOVE
        end
        if distance < 540 then
            if npc.stand or npc.gravity == 0 then
                if (npc.tickTime % 64 == 0) then
                    self.isUsingItemForAnimation = true
                    self.shootTimes = self.shootTimes + 1
                end
            end
        end
    end
    if npc.state == State.NORMAL then
        npc.noMove = false
    elseif npc.state == State.NO_MOVE then
        npc.noMove = true
    end
    if npc.gravity ~= 0 then
        npc:Walk()
    elseif npc.noMove then
        npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.1)
    else
        npc:Fly()
    end
end

return SkeletonAssaulter