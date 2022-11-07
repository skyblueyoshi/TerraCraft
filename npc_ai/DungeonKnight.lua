---@class TC.DungeonKnight:TC.HumanFighter
local DungeonKnight = class("DungeonKnight", require("HumanFighter"))

function DungeonKnight:Init()
    self.boneSizeIndex = 1
    DungeonKnight.super.Init(self)

    self.inventory = Inventory.new(1)
    self.npc.dataWatcher:AddInventory(self.inventory)

    self.itemSlotHeld = self.inventory:GetSlot(0)
    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("iron_sword")))

    self.isBackHandLook = true
    self.isFrontHandLook = true
    self.isBackHandLookAngleSameDirection = true
    self.isFrontHandLookAngleSameDirection = true
end

function DungeonKnight:Update()
    DungeonKnight.super.Update(self)
    local npc = self.npc

    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
    end

    if math.fmod(npc.tickTime, 8) == 0 then
        self.isUsingItemForAnimation = true
    end

    self.isHeadLook = true
    self.headLookAngle = npc.watchAngle
    self.headLookDenominator = 2.0

    self.backHandLookAngle = math.pi / 3
    self.frontHandLookAngle = math.pi / 3

    if npc.state == 0 then
        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 100 then
            npc.stateTimer = 0
            npc.state = 1
        end
    elseif npc.state == 1 then
        npc.stateTimer = npc.stateTimer + 1
        local TIME = 30
        local angle = npc.stateTimer / TIME * math.pi * 1.0 - math.pi / 3 * 2
        self.backHandLookAngle = angle
        self.frontHandLookAngle = angle
        if npc.stateTimer > TIME then
            npc.stateTimer = 0
            npc.state = 0

            local ba = npc.watchAngle
            local step = math.pi / 8
            local cnt = 3
            local speed = 3
            local cx = npc.centerX + (npc.direction and 32 or -32)
            local cy = npc.centerY
            for i = 0, cnt - 1 do
                local angle = ba - step * cnt / 2 + step * i
                local proj = ProjectileUtils.CreateFromNpc(npc,
                        Reg.ProjectileID("lighting_bullet_blue"),
                        cx, cy,
                        speed * math.cos(angle), speed * math.sin(angle),
                        npc.baseAttack)
                proj.isCheckPlayer = true
            end

        end
    end
end

return DungeonKnight