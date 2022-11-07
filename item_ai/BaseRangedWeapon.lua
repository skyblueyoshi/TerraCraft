---@class TC.BaseRangedWeapon:TC.BaseTool
local BaseRangedWeapon = class("BaseRangedWeapon", require("BaseTool"))
local GPlayer = require("player.GPlayer")

function BaseRangedWeapon:OnUsedByNpc(npc)
    local item = self.itemStack:GetItem()
    local modNpc = npc:GetModNpc()
    if modNpc.GetHeldItemJoint ~= nil then
        local itemJoint = modNpc:GetHeldItemJoint()
        local projectileID = item.shootProjectileID
        local realShootAngle = npc.watchAngle
        local shootPoint = self:GetShootPoint(itemJoint)
        local speed = item.speed
        local proj = ProjectileUtils.CreateFromNpc(npc, projectileID,
                shootPoint.x, shootPoint.y,
                math.cos(realShootAngle) * speed,
                math.sin(realShootAngle) * speed,
                npc.baseAttack)
        proj.isCheckPlayer = true
    end
end

function BaseRangedWeapon:OnHeld(player)
    local item = self.itemStack:GetItem()
    local globalPlayer = GPlayer.GetInstance(player)
    local lookAngle = globalPlayer:GetLookAngleInFacingDirection() - math.pi / 2

    local body = globalPlayer.bone.joints:getJoint("base.body")
    local head = body:getChild("head")
    local backArm = body:getChild("back_arm")
    local backHand = backArm:getChild("back_hand")
    local frontArm = body:getChild("front_arm")

    backArm.angle = lookAngle
    backHand.angle = 0
    local bodyAngle = lookAngle + math.pi / 2
    head.angle = bodyAngle / 4
    if item.twoHands then
        frontArm.angle = lookAngle
    end

    globalPlayer.bone:update(false)
end

function BaseRangedWeapon:OnUsed(player)
    local item = self.itemStack:GetItem()
    local globalPlayer = GPlayer.GetInstance(player)
    if globalPlayer.currentActionMaxTicks <= 0 then
        -- avoid divide by zero
        return
    end
    if item.consumeMana > 0 and player.mana < item.consumeMana then
        return
    end
    if item.maxDurable > 0 and self.itemStack.durable <= 0 then
        return
    end
    local lookAngle = globalPlayer:GetLookAngleInFacingDirection() - math.pi / 2
    local itemJoint = globalPlayer:GetHeldItemJoint()
    ---@type Joint2D
    local body = globalPlayer.bone.joints:getJoint("base.body")
    local head = body:getChild("head")
    local backArm = body:getChild("back_arm")
    local backHand = backArm:getChild("back_hand")
    local frontArm = body:getChild("front_arm")
    backArm.angle = lookAngle
    backHand.angle = 0
    local bodyAngle = lookAngle + math.pi / 2
    head.angle = bodyAngle / 4
    local realShootAngle = player.lookAngle
    if item.twoHands then
        if item.usePosture == 1 then
            local rate = globalPlayer.currentActionTick * 1.0 / globalPlayer.currentActionMaxTicks
            if rate < 0.5 then
                frontArm.angle = lookAngle - math.sin(rate * math.pi / 0.5)
            else
                frontArm.angle = lookAngle
            end
        else
            frontArm.angle = lookAngle
        end
    end
    self:OnSolveUsingAnimation(player)

    -- Let's shoot the projectile from current bow!
    local triggerShooting = globalPlayer.currentActionTick == 0
    if triggerShooting then
        local needConsume = true
        local ammoIndex = -1
        local projectileID = 0
        local checkConsume = self:IsCheckingConsume(player)
        local isMorePower = false
        if checkConsume then
            if item.ammoID > 0 then
                local searchBest = item.ammoLevel == 0
                ammoIndex = globalPlayer:GetAmmoIndexInBackpack(item.ammoID, item.ammoLevel, searchBest)
                if ammoIndex >= 0 then
                    local slot = player.backpackInventory:GetSlot(ammoIndex)
                    if slot.hasStack then
                        local ammoItem = slot:GetStack():GetItem()

                        if item.ammoLevel > 0 and ammoItem.ammoLevel == 0 then
                            projectileID = item.shootProjectileID
                        else
                            projectileID = ammoItem.projectileID
                        end

                        if item.ammoLevel > 0 and item.ammoLevel == ammoItem.ammoLevel then
                            isMorePower = true
                        end
                    end
                end
            end
        else
            needConsume = false
            projectileID = item.shootProjectileID
        end
        if checkConsume and ammoIndex < 0 then
            return
        end
        projectileID = self:GetActualProjectileID(player, projectileID)
        if projectileID > 0 then
            local collided = MapUtils.WeaponCollideWithMap(itemJoint:getWorldObb(), false)
            -- TODO: FIX THIS
            local ignoreOverlapWithSolid = true
            if not collided or (collided and ignoreOverlapWithSolid) then
                local killAmmo = false
                local attachItemID = -1
                if NetMode.current == NetMode.Server then
                    if needConsume and ammoIndex >= 0 and player.backpackInventory:GetSlot(ammoIndex).hasStack then
                        if Utils.RandDouble(1) >= item.noConsumeChance then
                            killAmmo = true
                            if self:NeedAttachItemToProjectile(player) then
                                attachItemID = player.backpackInventory:GetSlot(ammoIndex):GetStack():GetItem().id
                            end
                        end
                    end
                end

                local shootPoint = self:GetShootPoint(itemJoint)
                local speed = self:GetShootSpeed(player, projectileID, nil)
                local attack = self:GetAttackValue(player, projectileID, nil)
                realShootAngle = self:GetRealShootAngle(realShootAngle, player, projectileID, nil)
                attack = attack or Attack.new(0, 0, 0)
                if isMorePower then
                    attack.attack = math.floor(attack.attack * 1.3)
                    attack.knockBack = math.floor(attack.knockBack * 1.3)
                end
                local angleDt = self:GetMultiProjectileDeltaAngle(player, projectileID)
                local angleTotalDt = 0
                local shootTimes = math.max(1, item.shootTimes)
                for i = 0, shootTimes - 1 do
                    local angle = realShootAngle + angleTotalDt
                    angleTotalDt = -angleTotalDt
                    if i % 2 == 0 then
                        angleTotalDt = angleTotalDt + angleDt
                    end
                    local realAttack = self:GetRealAttackValue(shootTimes, attack)
                    local proj = ProjectileUtils.CreateFromPlayer(player, projectileID,
                            shootPoint.x, shootPoint.y,
                            math.cos(angle) * speed,
                            math.sin(angle) * speed,
                            realAttack)
                    proj.isCheckNpc = true
                    if attachItemID > 0 and NetMode.current == NetMode.Server then
                        local mp = proj:GetModProjectile()
                        if mp then
                            mp.attachItemID = attachItemID
                            attachItemID = -1
                        end
                    end
                end

                if item.consumeMana > 0 then
                    player.mana = math.max(player.mana - item.consumeMana, 0)
                end

                local ammoStack = nil
                if needConsume and ammoIndex >= 0 and player.backpackInventory:GetSlot(ammoIndex).hasStack then
                    ammoStack = player.backpackInventory:GetSlot(ammoIndex):GetStack()
                end
                self:OnAfterShoot(player, projectileID, ammoStack, itemJoint, realShootAngle)

                if killAmmo then
                    player.backpackInventory:GetSlot(ammoIndex):DecrStackSize(1)
                end

                if item.maxDurable > 0 then
                    self.itemStack:LoseDurable(1)
                end
            end
        end


    end

    -- test
    --if NetMode.current == NetMode.Client then
    --    local tp = itemJoint.transform.worldMatrix:transformVector2(self.itemStack:GetItem():GetFirePoint(0))
    --    local spx, spy = math.cos(realShootAngle) * 8, math.sin(realShootAngle) * 8
    --    EffectUtils.Create(Reg.EffectID("circle"), tp.x, tp.y,
    --            spx, spy,
    --            0, 0.2, 0.2)
    --
    --end
end

---OnSolveUsingAnimation
---@param player Player
function BaseRangedWeapon:OnSolveUsingAnimation(player)
end

---IsCheckingConsume
---@param player Player
---@return boolean
function BaseRangedWeapon:IsCheckingConsume(player)
    return false
end

function BaseRangedWeapon:NeedAttachItemToProjectile(player)
    return false
end

---GetActualProjectileID
---@param player Player
---@param rawProjectileID int
---@return int
function BaseRangedWeapon:GetActualProjectileID(player, rawProjectileID)
    return rawProjectileID
end

---GetMultiProjectileDeltaAngle
---@param player Player
---@param projectileID int
---@return double
function BaseRangedWeapon:GetMultiProjectileDeltaAngle(player, projectileID)
    return 0.1
end

---GetAttackValue
---@param player Player
---@param projectileID int
---@param ammoStack ItemStack|nil
---@return Attack
function BaseRangedWeapon:GetAttackValue(player, projectileID, ammoStack)
    local item = self.itemStack:GetItem()
    local attack = player.baseAttack.attack + item.baseAttack.attack
    local knockBack = player.baseAttack.knockBack + item.baseAttack.knockBack
    local crit = player.baseAttack.crit + item.baseAttack.crit
    return Attack.new(attack, knockBack, crit)
end

function BaseRangedWeapon:GetRealAttackValue(shootTimes, baseAttack)
    local attack = baseAttack.attack
    local knockBack = baseAttack.knockBack
    local crit = baseAttack.crit
    for i = 2, shootTimes do
        attack = attack * 0.8
        knockBack = knockBack * 0.8
        crit = crit * 0.8
    end
    return Attack.new(attack, knockBack, crit)
end

---GetShootSpeed
---@param player Player
---@param projectileID int
---@param ammoStack ItemStack|nil
---@return double
function BaseRangedWeapon:GetShootSpeed(player, projectileID, ammoStack)
    local item = self.itemStack:GetItem()
    return item.speed
end

---GetRealShootAngle
---@param baseAngle double
---@param player Player
---@param projectileID int
---@param ammoStack ItemStack|nil
---@return double
function BaseRangedWeapon:GetRealShootAngle(baseAngle, player, projectileID, ammoStack)
    local item = self.itemStack:GetItem()
    return Utils.FixAngle(baseAngle + Utils.RandSym(item.deviation))
end

---@param player Player
---@param projectileID int
---@param ammoStack ItemStack|nil
---@param itemJoint Joint2D
---@param realShootAngle double
function BaseRangedWeapon:OnAfterShoot(player, projectileID, ammoStack, itemJoint, realShootAngle)
    local item = self.itemStack:GetItem()
    local soundID = item.useSoundID
    if soundID > 0 then
        SoundUtils.PlaySound(soundID, player.centerXi, player.centerYi)
    end
    local soundGroupID = item.useSoundGroupID
    if soundGroupID > 0 then
        SoundUtils.PlaySoundGroup(soundGroupID, player.centerXi, player.centerYi)
    end
    local force = 0
    local backForceX = -force * math.cos(realShootAngle)
    local backForceY = -force * math.sin(realShootAngle)
    player.speedX = player.speedX + backForceX
    player.speedY = player.speedY + backForceY
end

---GetShootPoint
---@param itemJoint Joint2D
---@return Vector2
function BaseRangedWeapon:GetShootPoint(itemJoint)
    return itemJoint.transform.worldMatrix:transformVector2(self.itemStack:GetItem():GetFirePoint(0))
end

return BaseRangedWeapon