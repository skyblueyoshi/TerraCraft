---@class TC.Archer:TC.HumanFighter
local Archer = class("Archer", require("HumanFighter"))

local State = {
    NORMAL = 0,
    NO_MOVE = 1
}

function Archer:Init()
    Archer.super.Init(self)

    self.inventory = Inventory.new(1)
    self.npc.dataWatcher:AddInventory(self.inventory)

    self.itemSlotHeld = self.inventory:GetSlot(0)

    self.shootTimes = 0
    self.shootOffsetAngle = 0
    self.SHOOT_TIMES = self.npc.dataWatcher:AddInteger(0)
end

function Archer:Update()
    self:RecvSync()
    local npc = self.npc
    npc.noMove = true

    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    npc.state = State.NORMAL
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
    end

    local watchAngle = Utils.FixAngle(npc.watchAngle)
    local offsetDir = 1
    if watchAngle >= -math.pi / 2 and watchAngle < math.pi / 2 then
        offsetDir = -1
    end
    watchAngle = watchAngle + self.shootOffsetAngle * offsetDir

    self.isHeadLook = true
    self.headLookAngle = watchAngle
    self.headLookDenominator = 2.0

    self.isBackHandLook = true
    self.isFrontHandLook = true
    self.backHandLookAngle = watchAngle
    self.frontHandLookAngle = watchAngle

    npc.state = State.NORMAL
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 540 and self.shootTimes ~= 0 then
            npc.state = State.NO_MOVE
        end
        if distance < 1200 then
            if npc.stand or npc.gravity == 0 then
                if (npc.tickTime % 200 == 0) then
                    self.isUsingItemForAnimation = true
                    self.shootTimes = self.shootTimes + 1
                end
            end
        end
        if self.shootTimes > 1 and Utils.RandTry(128) then
            self.shootTimes = 0
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

    if npc.inLiquid then
        npc.speedY = - 8
    end
    self:SendSync()
end

function Archer:SendSync()
    if NetMode.current == NetMode.Server then
        self.npc.dataWatcher:UpdateInteger(self.SHOOT_TIMES, self.shootTimes)
    end
end

function Archer:RecvSync()
    if NetMode.current == NetMode.Client then
        self.shootTimes = self.npc.dataWatcher:GetInteger(self.SHOOT_TIMES)
    end
end

return Archer