---@class TC.SwordHumanFighter:TC.HumanFighter
local SwordHumanFighter = class("SwordHumanFighter", require("HumanFighter"))

local SwingState = {
    Waiting = 0,
    Swinging = 1,
}

function SwordHumanFighter:Init()
    self.boneSizeIndex = 0
    self.style = 0
    if self.npc.data and self.npc.data.tc then
        local dataTable = self.npc.data.tc
        if dataTable.boneSizeIndex ~= nil then
            self.boneSizeIndex = dataTable.boneSizeIndex
        end
        if dataTable.style ~= nil then
            self.style = dataTable.style
        end
    end
    SwordHumanFighter.super.Init(self)

    self.inventory = Inventory.new(1)
    self.npc.dataWatcher:AddInventory(self.inventory)

    self.itemSlotHeld = self.inventory:GetSlot(0)

    self.isFrontHandLook = true
    self.isBackHandLook = true
    self.isFrontHandLookAngleSameDirection = true
    self.isBackHandLookAngleSameDirection = true

    self.totalSwingTime = 30
    self.totalSwingIntervalTime = 120
    self.swingDistance = 120
    self.alwaysTrySwing = true

    self.swingState = 0
    self.swingTime = 0
    self.SWING_STATE = self.npc.dataWatcher:AddInteger(0)
end

function SwordHumanFighter:Update()
    SwordHumanFighter.super.Update(self)
    self:UpdateSwordSwingLogic()
end

function SwordHumanFighter:UpdateSwordSwingLogic()
    if self.alwaysTrySwing and self:HasHeldSword() then
        local npc = self.npc
        local isServer = NetMode.current == NetMode.Server
        if not isServer then
            local newSwingState = npc.dataWatcher:GetInteger(self.SWING_STATE)
            if self.swingState ~= newSwingState then
                self.swingState = newSwingState
                self.swingTime = 0
            end
        end

        if self.swingState == SwingState.Waiting then
            self:OnWaitSwing()
            local inDistance = false
            local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
            if playerTarget ~= nil then
                local d = Utils.GetDistance(playerTarget.centerX - npc.centerX, playerTarget.centerY - npc.centerY)
                if d < self.swingDistance then
                    inDistance = true
                end
            end

            if inDistance then
                self.swingTime = self.swingTime + 1
                if isServer and self.swingTime >= self.totalSwingIntervalTime then
                    self.swingState = SwingState.Swinging
                    self.swingTime = 0
                end
            end
        elseif self.swingState == SwingState.Swinging then
            self.isUsingItemForAnimation = true
            self:OnSwing()
            self.swingTime = self.swingTime + 1
            if self.swingTime >= self.totalSwingTime then
                self.swingState = SwingState.Waiting
                self.swingTime = 0
            end
        end

        if isServer then
            npc.dataWatcher:UpdateInteger(self.SWING_STATE, self.swingState)
        end
    end
end

function SwordHumanFighter:HasHeldSword()
    if self.itemSlotHeld.hasStack then
        local stack = self.itemSlotHeld:GetStack()
        if stack:GetItem().toolType == "SWORD" then
            return true
        end
    end
    return false
end

function SwordHumanFighter:SetHeldItemByIDName(itemIDName)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName(itemIDName)))
end

function SwordHumanFighter:OnWaitSwing()
    self:DoExternArmsAnimation()
end

function SwordHumanFighter:OnSwing()
    local rate = 0
    if self.totalSwingTime > 0 then
        rate = self.swingTime * 1.0 / self.totalSwingTime
    end
    self.frontHandLookAngle = -math.pi / 3 + (rate) * 3
    self.backHandLookAngle = -math.pi / 3 + (rate) * 3
end

return SwordHumanFighter