---@class TC.GhostGunner:TC.HumanFighter
local GhostGunner = class("GhostGunner", require("HumanFighter"))

function GhostGunner:Init()
    GhostGunner.super.Init(self)

    self.inventory = Inventory.new(1)
    self.npc.dataWatcher:AddInventory(self.inventory)

    self.itemSlotHeld = self.inventory:GetSlot(0)

    self.itemSlotHeld:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName("super_shark_ghost")))

    self.isFrontHandLook = true
    self.isBackHandLook = true

    self.ghostAllowToShoot = false
    self.isGhostGuard = true
    self.GHOST_ALLOW_TO_SHOOT = self.npc.dataWatcher:AddBool(self.ghostAllowToShoot)
end

function GhostGunner:OnHit()
    self.ghostAllowToShoot = true
end

function GhostGunner:Update()
    local npc = self.npc

    if NetMode.current == NetMode.Server then
        npc.dataWatcher:UpdateBool(self.GHOST_ALLOW_TO_SHOOT, self.ghostAllowToShoot)
    else
        self.ghostAllowToShoot = npc.dataWatcher:GetBool(self.GHOST_ALLOW_TO_SHOOT)
    end

    npc:Fly(self.ghostAllowToShoot)
    if npc.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("flash2"), npc.randX, npc.randY, Utils.RandSym(0.2), Utils.RandSym(0.2), 0,
                Utils.RandDoubleArea(0.5, 0.5))
    end

    if self.ghostAllowToShoot then
        local watchAngle = npc.watchAngle

        self.backHandLookAngle = watchAngle
        self.frontHandLookAngle = watchAngle

        if npc.tickTime % 64 == 0 then
            self.isUsingItemForAnimation = true
        end
    else
        self.frontHandLookAngle = math.cos(self.npc.tickTime / 16) / 4
        self.backHandLookAngle = math.sin(self.npc.tickTime / 16) / 4
    end
end

return GhostGunner