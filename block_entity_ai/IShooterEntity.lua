---@class TC.IShooterEntity:TC.IChestEntity
local IShooterEntity = class("IShooterEntity", require("IChestEntity"))

function IShooterEntity:Init(slotCount)
    IShooterEntity.super.Init(self, slotCount)
    self.direction = 0  -- 0 left 1 right 2 up 3 down
    self.wi = 2
    self.hi = 2
    self.active = false
    -- TODO ANIMATION!!!!!!!!
end

function IShooterEntity:OnActivated(isActive)
    if not isActive then
        self.active = false
    elseif not self.active then
        self.active = true
        local indices = {}
        local size = self.inventorySize
        for i = 0, size - 1 do
            local slot = self.inventory:GetSlot(i)
            if slot.hasStack then
                indices[#indices + 1] = i
            end
        end
        if #indices == 0 then
            return
        end
        local pickIndex = indices[math.random(1, #indices)]
        local slot = self.inventory:GetSlot(pickIndex)
        if not slot.hasStack then
            return
        end
        local shootX = self.blockEntity.xi - math.floor(self.wi / 2) * 16
        local shootX2 = shootX + self.wi * 16
        local shootY2 = self.blockEntity.yi * 16 + 16
        local shootY = shootY2 - self.hi * 16
        local centerX = (shootX + shootX2) / 2
        local centerY = (shootY + shootY2) / 2
        local dirX = 0
        local dirY = 0
        local shootWidth = 16
        local shootHeight = 16
        local stack = slot:GetStack()
        local item = stack:GetItem()
        if item.shootable and item.projectileID > 0 then
            -- TODO: ProjectileNS::Data &dp = projectileData->GetData(di.projectileId);
            shootWidth = 32
            shootHeight = 32
            shootWidth = math.max(shootWidth, shootHeight)
            shootHeight = shootWidth
        end
        if self.direction == 0 then
            shootX = shootX - shootWidth / 2
            shootY = centerY
            dirX = -1
            dirY = 0
        elseif self.direction == 1 then
            shootX = shootX2 + shootWidth / 2
            shootY = centerY
            dirX = 1
            dirY = 0
        elseif self.direction == 2 then
            shootX = centerX
            shootY = shootY - shootHeight / 2
            dirX = 0
            dirY = -1
        elseif self.direction == 3 then
            shootX = centerX
            shootY = shootY2 + shootHeight / 2
            dirX = 0
            dirY = 1
        end
        if item.shootable then
            local speed = 15
            -- TODO: Projectile Shoot!
            --ProjectileUtils
        else
            local speed = 4
            ItemUtils.CreateDrop(stack:Clone(1), shootX, shootY,
                    speed * dirX + Utils.RandSym(0.25), speed * dirY + Utils.RandSym(0.25))
            slot:DecrStackSize(1)
        end
        SoundUtils.PlaySound(Reg.SoundID("bow"), self.blockEntity.xi, self.blockEntity.yi)
    end
end

return IShooterEntity