---@class TC.GPlayer:GlobalPlayer
local GPlayer = class("GPlayer", GlobalPlayer)
local InputControl = require("client.InputControl")
local PlayerBoneInfo = require("bone2d.PlayerBoneInfo")
local ControlAimMode = require("client.ControlAimMode")
local cameraInGameInstance = require("client.CameraInGame").getInstance()
local EnchantmentProxies = require("enchantments.EnchantmentProxies")
local BuffProxies = require("buffs.BuffProxies")
local AdvancementTriggers = require("advancements.AdvancementTriggers")
local MiscHelper = require("util.MiscHelper")
local NetworkProxy = require("network.NetworkProxy")
local RPC_ID = require("network.RPC_ID")
local SettingsData = require("settings.SettingsData")
local DebugHelper = require("DebugHelper")
local PlayerConstants = require("PlayerConstants")

local GRAVITY = PlayerConstants.GRAVITY
local WALK_FORCE = PlayerConstants.WALK_FORCE
local TURN_FORCE = PlayerConstants.TURN_FORCE
local DECELERATE_STOP = PlayerConstants.DECELERATE_STOP
local DECELERATE_STOP_AIR = PlayerConstants.DECELERATE_STOP_AIR
local MAX_SPEED_WALK = PlayerConstants.MAX_SPEED_WALK
local MAX_SPEED_UP = PlayerConstants.MAX_SPEED_UP
local MAX_SPEED_DOWN = PlayerConstants.MAX_SPEED_DOWN
local JUMP_SPEED = PlayerConstants.JUMP_SPEED
local JUMP_UP_TIME = PlayerConstants.JUMP_UP_TIME
local INTERACTION_DISTANCE = PlayerConstants.INTERACTION_DISTANCE
local MOVE_RATE_DISTANCE = PlayerConstants.MOVE_RATE_DISTANCE

local Behavior = {
    None = 0,
    Placing = 1,
    Digging = 2,
    SwordAttacking = 3,
    BowShooting = 4,
    StaffShooting = 5,
    GunShooting = 6,
    Eating = 7,
    LoadingLiquid = 8,
    PullingLiquid = 9,
    LoadingBottle = 10,
    Throwing = 11,
    PlacingWire = 12,
    RemovingWire = 13,
    LoadingBowl = 14,
    Shearing = 15,
    Seeding = 16,
    Ripening = 17,
    Farming = 18,
}

local ToolBehaviorProxies = {
    AXE = Behavior.Digging,
    PICKAXE = Behavior.Digging,
    DRILL = Behavior.Digging,
    SAW = Behavior.Digging,
    SWORD = Behavior.SwordAttacking,
    BOW = Behavior.BowShooting,
    CROSS_BOW = Behavior.GunShooting,
    GUN = Behavior.GunShooting,
    STAFF = Behavior.StaffShooting,
    WIRE_CUTTER = Behavior.RemovingWire,
    SHEARS = Behavior.Shearing,
    HOE = Behavior.Farming,
    BOOMERANG = Behavior.Throwing,
    ENDER_MIRROR = Behavior.Eating,
}

local BoneAction = {
    None = 0,
    Placing = 1,
    Digging = 2,
    SwordAttacking = 3,
    BowShooting = 4,
    StaffShooting = 5,
    GunShooting = 6,
    HoldLooking = 7,
    Eating = 8,
}

local MapOpType = {
    None = 0,
    LoadingLiquid = 1,
    PullingLiquid = 2,
    LoadingBottle = 3,
    LoadingBowl = 4,
    Farming = 5,
    Seeding = 6,
    Ripening = 7,
}

local FullDress = {
    diamond = {
        items = {
            Reg.ItemID("diamond_helmet"),
            Reg.ItemID("diamond_chestplate"),
            Reg.ItemID("diamond_leggings"),
        },
        advancementID = Reg.AdvancementID("diamond_wear"),
    },
    netherite = {
        items = {
            Reg.ItemID("nether_helmet"),
            Reg.ItemID("nether_chestplate"),
            Reg.ItemID("nether_leggings"),
        },
        advancementID = Reg.AdvancementID("netherite_full_wear"),
    },
    gold = {
        items = {
            Reg.ItemID("golden_helmet"),
            Reg.ItemID("golden_chestplate"),
            Reg.ItemID("golden_leggings"),
        },
        advancementID = Reg.AdvancementID("gold_wear"),
    },
    super_diamond = {
        items = {
            Reg.ItemID("super_diamond_helmet"),
            Reg.ItemID("super_diamond_chestplate"),
            Reg.ItemID("super_diamond_leggings"),
        },
        defense = 8,
        advancementID = Reg.AdvancementID("super_diamond_wear"),
    },
    lava = {
        items = {
            Reg.ItemID("lava_helmet"),
            Reg.ItemID("lava_chestplate"),
            Reg.ItemID("lava_leggings"),
        },
        fireDefense = true,
        lighting = true,
    },
    ancient = {
        items = {
            Reg.ItemID("ancient_helmet"),
            Reg.ItemID("ancient_chestplate"),
            Reg.ItemID("ancient_leggings"),
        },
        defense = 12,
        attack = 7,
        fireDefense = true,
        lighting = true,
        speed = 0.3,
        advancementID = Reg.AdvancementID("ancient_wear"),
    },
    knight = {
        items = {
            Reg.ItemID("knight_helmet"),
            Reg.ItemID("knight_chestplate"),
            Reg.ItemID("knight_leggings"),
        },
        defense = 6,
        attack = 5,
        advancementID = Reg.AdvancementID("knight_wear"),
    },
    magic_gold = {
        items = {
            Reg.ItemID("magic_gold_helmet"),
            Reg.ItemID("magic_gold_chestplate"),
            Reg.ItemID("magic_gold_leggings"),
        },
        defense = 2,
        manaAddSpeed = 0.8,
        advancementID = Reg.AdvancementID("magic_gold_wear"),
    },
    magic_silver = {
        items = {
            Reg.ItemID("magic_silver_helmet"),
            Reg.ItemID("magic_silver_chestplate"),
            Reg.ItemID("magic_silver_leggings"),
        },
        defense = 2,
        manaAddSpeed = 0.8,
    },
    magic_shadow = {
        items = {
            Reg.ItemID("magic_shadow_helmet"),
            Reg.ItemID("magic_shadow_chestplate"),
            Reg.ItemID("magic_shadow_leggings"),
        },
        defense = 3,
        speed = 0.3,
        manaAddSpeed = 0.8,
    },
    star = {
        items = {
            Reg.ItemID("star_helmet"),
            Reg.ItemID("star_chestplate"),
            Reg.ItemID("star_leggings"),
        },
        defense = 4,
        attack = 5,
        lighting = true,
        manaAddSpeed = 0.9,
        advancementID = Reg.AdvancementID("star_wear"),
    },
    flesh = {
        items = {
            Reg.ItemID("flesh_helmet"),
            Reg.ItemID("flesh_chestplate"),
            Reg.ItemID("flesh_leggings"),
        },
        attack = 7,
        advancementID = Reg.AdvancementID("flesh_wear"),
    },
    fine_tin = {
        items = {
            Reg.ItemID("fine_tin_helmet"),
            Reg.ItemID("fine_tin_chestplate"),
            Reg.ItemID("fine_tin_leggings"),
        },
        attack = 3,
        speed = 0.2,
    },
    shadow = {
        items = {
            Reg.ItemID("shadow_helmet"),
            Reg.ItemID("shadow_chestplate"),
            Reg.ItemID("shadow_leggings"),
        },
        manaAddSpeed = 0.5,
    },
}

local DressMappings = { {}, {}, {} }
for k, v in pairs(FullDress) do
    for i, id in ipairs(v.items) do
        DressMappings[i][id] = k
    end
end

function GPlayer:Awake()
    -- player bone data
    --- @type JointBody2D
    self.bone = PlayerBoneInfo.createBySkinID(self.player.skinID)
    self.frontItemJoint = PlayerBoneInfo.getItemJoint(self.bone, false)
    self.backItemJoint = PlayerBoneInfo.getItemJoint(self.bone, true)
    self.frontItemCache = {}
    self.backItemCache = {}
    self.currentAction = BoneAction.None
    self.lastTickAction = BoneAction.None
    self.currentActionTick = 0
    self.currentActionMaxTicks = 0
    self.throwingBoomerang = false
    self.throwingBoomerangTime = 0
    self.manaAddSpeed = 128

    -- 先做3个饰品格子，以后谁有模组开发需求再加格子
    self.accessoryInventory = Inventory.new(3)
    self.player.dataWatcher:AddInventory(self.accessoryInventory)

    self.trashInventory = Inventory.new(1)
    self.player.dataWatcher:AddInventory(self.trashInventory)

    self.BONE_ACTION = self.player.remoteDataWatcher:AddInteger(BoneAction.None, true)

    if NetMode.current == NetMode.Client then

        -- control and movement data
        self.left = false
        self.right = false
        self.up = false
        self.down = false
        self.jump = false
        self.justJump = false
        self.moving = false
        self.jumpUpTime = 0
        self.swimTime = 0
        self.walkingSoundTime = 0
        self.lastAimOffsetX = 0
        self.lastAimOffsetY = 0
        self.aimOffsetX = 0
        self.aimOffsetY = 0
        self.showingAimPoint = false
        self.placeColdTime = 0
        self.equipmentSkinCacheData = nil
        self.observeMode = false
        self.doorOpenColdTime = 0
        self.doorCloseColdTime = 0
        self.recipeBookHookUI = nil
        self.deathUI = nil

        self._clientInteractProxies = {
            [Behavior.Placing] = GPlayer.ClientPlacing,
            [Behavior.PlacingWire] = GPlayer.ClientPlacingWire,
            [Behavior.RemovingWire] = GPlayer.ClientRemovingWire,
            [Behavior.Eating] = GPlayer.ClientEating,
            [Behavior.LoadingLiquid] = GPlayer.ClientLoadingLiquid,
            [Behavior.LoadingBowl] = GPlayer.ClientLoadingBowl,
            [Behavior.PullingLiquid] = GPlayer.ClientPullingLiquid,
            [Behavior.LoadingBottle] = GPlayer.ClientLoadingBottle,
            [Behavior.Shearing] = GPlayer.ClientShearing,
            [Behavior.Seeding] = GPlayer.ClientSeeding,
            [Behavior.Ripening] = GPlayer.ClientRipening,
            [Behavior.Throwing] = GPlayer.ClientThrowing,
            [Behavior.Digging] = GPlayer.ClientDigging,
            [Behavior.Farming] = GPlayer.ClientFarming,
            [Behavior.SwordAttacking] = GPlayer.ClientSwordAttacking,
            [Behavior.BowShooting] = GPlayer.ClientBowShooting,
            [Behavior.GunShooting] = GPlayer.ClientGunShooting,
            [Behavior.StaffShooting] = GPlayer.ClientStaffShooting,
        }

        Input.mouse:addScrollListener({ GPlayer._onMouseScroll, self })

        Input.keyboard:getHotKeys(Keys.F6):addListener({ function(self)
            PlayerBoneInfo.getInstance():reload()
            self.bone = PlayerBoneInfo.createBySkinID(skinID)
        end, self })

    else
        self.player.health = PlayerConstants.StartHealth
        self.player.maxHealth = PlayerConstants.StartMaxHealth
        self.player.mana = PlayerConstants.StartMana
        self.player.maxMana = PlayerConstants.StartMaxMana

        self.player.foodLevel = PlayerConstants.StartFoodLevel
        self.player.foodSaturationLevel = PlayerConstants.StartSaturationLevel

        self._mapOpFunc = {
            [MapOpType.LoadingLiquid] = self.ServerLoadingLiquid,
            [MapOpType.PullingLiquid] = self.ServerPullingLiquid,
            [MapOpType.LoadingBottle] = self.ServerLoadingBottle,
            [MapOpType.LoadingBowl] = self.ServerLoadingBowl,
            [MapOpType.Farming] = self.ServerFarming,
            [MapOpType.Seeding] = self.ServerSeeding,
            [MapOpType.Ripening] = self.ServerRipen,
        }
    end

    -- animation event
    self._animationBeginFunc = {
        [BoneAction.Placing] = self.OnPlacingAnimationBegin,
        [BoneAction.Eating] = self.OnEatingAnimationBegin,
        [BoneAction.Digging] = self.OnDiggingAnimationBegin,
        [BoneAction.SwordAttacking] = self.OnSwordAttackingAnimationBegin,
        [BoneAction.BowShooting] = self.OnBowShootingAnimationBegin,
        [BoneAction.StaffShooting] = self.OnStaffShootingAnimationBegin,
        [BoneAction.GunShooting] = self.OnGunShootingAnimationBegin,
        [BoneAction.HoldLooking] = self.OnHoldLookingAnimationBegin,
    }
    self._animationUpdateFunc = {
        [BoneAction.Digging] = self.OnDiggingAnimationUpdate,
        [BoneAction.SwordAttacking] = self.OnSwordAttackingAnimationUpdate,
        [BoneAction.BowShooting] = self.OnBowShootingAnimationUpdate,
        [BoneAction.StaffShooting] = self.OnStaffShootingAnimationUpdate,
        [BoneAction.GunShooting] = self.OnGunShootingAnimationUpdate,
        [BoneAction.HoldLooking] = self.OnHoldLookingAnimationUpdate,
    }
    self._animationEndFunc = {
        [BoneAction.Placing] = self.OnPlacingAnimationEnd,
        [BoneAction.Eating] = self.OnEatingAnimationEnd,
        [BoneAction.Digging] = self.OnDiggingAnimationEnd,
        [BoneAction.SwordAttacking] = self.OnSwordAttackingAnimationEnd,
        [BoneAction.BowShooting] = self.OnBowShootingAnimationEnd,
        [BoneAction.StaffShooting] = self.OnStaffShootingAnimationEnd,
        [BoneAction.GunShooting] = self.OnGunShootingAnimationEnd,
        [BoneAction.HoldLooking] = self.OnHoldLookingAnimationEnd,
    }
    self.bone.animator:createEventAtTimePoint("Placing", 1.0):addListener(
            { self.OnPlacingAnimationEnd, self }
    )
    self.bone.animator:createEventAtTimePoint("Eating", 1.0):addListener(
            { self.OnEatingAnimationEnd, self }
    )
    self.bone.animator:createEventAtTimePoint("SwordAttacking", 1.0):addListener(
            { self.OnSwordAttackingAnimationEnd, self }
    )


end

function GPlayer:Init()
    self.player:FinishAdvancement(Reg.AdvancementID("inventory"))
    DebugHelper.RunDebugStart(self.player)
end

function GPlayer:OnFirstTimeJoin()
    self:BackpackAddItemByIDName("grass_sword")
    self:BackpackAddItemByIDName("grass_axe")
    self:BackpackAddItemByIDName("grass_pickaxe")
    self:BackpackAddItemByIDName("torch", 16)
end

function GPlayer:BackpackAddItemByIDName(idName, count)
    if count == nil then
        count = 1
    end
    self.player.backpackInventory:AddItemStack(ItemStack.new(ItemRegistry.GetItemByIDName(idName), count))
end

function GPlayer:Motion()
    -- only control current client player
    if not self.player.isCurrentClientPlayer then
        return
    end

    local player = self.player
    local lastJump = self.jump
    player.defaultMaxSpeed = MAX_SPEED_WALK
    player.defaultJumpTime = JUMP_UP_TIME
    player.defaultFallSpeed = MAX_SPEED_DOWN
    player.defaultJumpSpeed = JUMP_SPEED

    local inputControl = InputControl.getInstance()

    if not player.dying then
        self.left = InputControl.isPressing("left")
        self.right = InputControl.isPressing("right")
        self.up = InputControl.isPressing("up")
        self.down = InputControl.isPressing("down")
        self.jump = InputControl.isPressing("jump")
    else
        -- do not move when dying
        self.left = false
        self.right = false
        self.up = false
        self.down = false
        self.jump = false
    end

    self.justJump = not lastJump and self.jump

    -- ignore if pressing two reverse direction buttons at the same time
    if self.left and self.right then
        self.left, self.right = false, false
    end
    if self.up and self.down then
        self.up, self.down = false, false
    end
    self.moving = self.left or self.right
    player.isDownPlatform = player.stand and self.down

    local stickyRate = 1.0
    if player.inLiquid then
        --TODO:LiquidNS::Data &ld = liquidData->GetData(e.touchLiquidID); stickyRate = ld.stickyRate;
        stickyRate = 0.5
    end

    local maxSpeed = player.defaultMaxSpeed * player.speedRate * stickyRate
    if self.moving then
        -- change direction
        player.direction = self.right
        -- walking
        local walkForce = WALK_FORCE * stickyRate
        -- TODO:walkForce *= blockData->GetData(hostBlockId).slipperiness
        local turnForce = TURN_FORCE
        local speedFlag = player.speedX > 0
        player.speedX = player.speedX +
                (((self.right and speedFlag) or (self.left and not speedFlag))
                        and walkForce or turnForce) *
                        (self.right and 1.0 or -1.0)
    else
        -- slowing down
        local decelerateForce = player.stand and DECELERATE_STOP or DECELERATE_STOP_AIR
        -- TODO:if (e.stand && hostBlockId > 0) decelerateForce *= hostSlipperiness;
        player.speedX = Utils.SlowSpeed1D(player.speedX, decelerateForce)
    end
    if player.speedX > maxSpeed then
        player.speedX = Utils.SlowSpeed1D(player.speedX, DECELERATE_STOP)
        if player.speedX < maxSpeed then
            player.speedX = maxSpeed
        end
    elseif player.speedX < -maxSpeed then
        player.speedX = Utils.SlowSpeed1D(player.speedX, DECELERATE_STOP)
        if player.speedX > -maxSpeed then
            player.speedX = -maxSpeed
        end
    end

    local gravity = GRAVITY
    local maxFallSpeed = player.defaultFallSpeed * player.fallSpeedRate
    local maxUpSpeed = MAX_SPEED_UP * player.jumpSpeedRate
    if player.inLiquid then
        maxFallSpeed = maxFallSpeed * stickyRate * 0.5
        maxUpSpeed = maxFallSpeed
    end
    if not (self.jump and self.jumpUpTime > 0) then
        -- no press jump
        if player.inLiquid then
            player.speedY = player.speedY + gravity * stickyRate
            if self.jump then
                player.speedY = player.speedY - gravity
                self.swimTime = self.swimTime + 1
            end
        else
            player.speedY = player.speedY + gravity
            self.swimTime = 0
        end
    end
    if not player.inLiquid then
        self.swimTime = 0
    end
    local maxJumpTime = math.ceil(player.defaultJumpTime * player.jumpRate)
    if player.stand and self.justJump then
        self.jumpUpTime = maxJumpTime
    elseif self.jump and not player.isCollisionTop then
        -- Jump from water
        if player.speedY < 0 and player.oldInLiquid and not player.inLiquid then
            self.jumpUpTime = math.ceil(maxJumpTime * 0.8)
            player.speedY = math.max(player.speedY, -maxUpSpeed)
        end
        self.jumpUpTime = math.max(self.jumpUpTime - 1, 0)
    else
        self.jumpUpTime = 0
    end
    if self.jumpUpTime > 0 then
        player.speedY = -player.defaultJumpSpeed * player.jumpSpeedRate
    end
    player.speedY = math.min(math.max(player.speedY, -maxUpSpeed), maxFallSpeed)

    if self.observeMode then
        local s = 24
        if self.left then
            player.speedX = -s
        elseif self.right then
            player.speedX = s
        else
            player.speedX = 0
        end
        if self.up then
            player.speedY = -s
        elseif self.down then
            player.speedY = s
        else
            player.speedY = 0
        end
    end
    player.ignoreCollisionWithTiles = self.observeMode

    if player.stand and math.abs(player.speedX) > 1.0 then
        self.walkingSoundTime = self.walkingSoundTime + 1
    else
        self.walkingSoundTime = 0
    end

    if player.stand then
        local blockID = MapUtils.GetFrontID(player.hostXi, player.hostYi)
        if blockID then
            local data = BlockUtils.GetData(blockID)

            if self.walkingSoundTime > 24 then
                self.walkingSoundTime = 0
                if data.stepSoundId then
                    SoundUtils.PlaySound(data.stepSoundId)
                end
                if data.stepSoundGroupId then
                    SoundUtils.PlaySoundGroup(data.stepSoundGroupId)
                end
            end
        end
    end

    self.showingAimPoint = true

    -- aim by joystick
    if inputControl.aimMode == ControlAimMode.PressOnly then
        self.aimOffsetX = 0
        self.aimOffsetY = 0
        self.lastAimOffsetX = 0
        self.lastAimOffsetY = 0
    elseif inputControl.aimMode == ControlAimMode.LookDirectionOrShoot then
        self.lastAimOffsetX = 0
        self.lastAimOffsetY = 0
        if SettingsData.isMobileOperation then
            if inputControl.aimDistance > 0 then
                self.aimOffsetX = math.cos(inputControl.aimAngle) * INTERACTION_DISTANCE * 1.6
                self.aimOffsetY = math.sin(inputControl.aimAngle) * INTERACTION_DISTANCE * 1.3
            end
        else
            -- PC
            self.aimOffsetX = inputControl.pcMouseAtMapX - player.centerX
            self.aimOffsetY = inputControl.pcMouseAtMapY - player.centerY
        end
    elseif inputControl.aimMode == ControlAimMode.LookPositionOrUse then
        if SettingsData.isMobileOperation then
            if inputControl.aimInstanceClicked then
                self.lastAimOffsetX = self.aimOffsetX
                self.lastAimOffsetY = self.aimOffsetY
            end
            if inputControl.aimPressing then
                local angle = inputControl.aimAngle
                self.aimOffsetX = self.lastAimOffsetX + math.cos(angle) * MOVE_RATE_DISTANCE * inputControl.aimDistance
                self.aimOffsetY = self.lastAimOffsetY + math.sin(angle) * MOVE_RATE_DISTANCE * inputControl.aimDistance
                local tempVec2 = Vector2.new(self.aimOffsetX, self.aimOffsetY)
                inputControl.aimAngle = tempVec2.angle
                if tempVec2.length > INTERACTION_DISTANCE then
                    self.aimOffsetX = math.cos(inputControl.aimAngle) * INTERACTION_DISTANCE
                    self.aimOffsetY = math.sin(inputControl.aimAngle) * INTERACTION_DISTANCE
                end
            end
        else
            -- PC
            self.lastAimOffsetX = 0
            self.lastAimOffsetY = 0

            self.aimOffsetX = inputControl.pcMouseAtMapX - player.centerX
            self.aimOffsetY = inputControl.pcMouseAtMapY - player.centerY
        end
    end

    -- Drop items
    if InputControl.isInstantPressing("Drop") then
        local dropOne = true
        if InputControl.isPressing("Shift") then
            dropOne = false
        end
        NetworkProxy.RPCSendServerBound(Mod.current, RPC_ID.SB_DROP_ITEM_HELD, dropOne)
    end
end

function GPlayer:Update()
    local player = self.player

    PlayerBoneInfo.checkHandItem(self.backItemJoint, self:GetHeldSlot(), self.backItemCache)

    self.bone.joints.position = Vector2.new(player.centerX, player.bottomY)
    local animator = self.bone.animator
    animator:setBool("OnGround", player.stand)
    local speedRate = 0
    local speed = math.abs(player.speedX)
    local lastSpeed = animator:getFloat("Speed")
    if speed > 3 then
        speedRate = 0.5
    elseif player.isCollisionLeft or player.isCollisionRight then
        speedRate = 0
    else
        speedRate = speed / 3.0 * 0.5
    end
    if speedRate == 0 and lastSpeed ~= 0 then
        speedRate = Utils.SlowSpeed1D(lastSpeed, 0.1)
    end

    local heldSlot = self:GetHeldSlot()
    self.player.holdColdTime = 0
    if heldSlot.hasStack then
        local itemStack = heldSlot:GetStack()
        local item = itemStack:GetItem()
        if item.isBlock then
        elseif item.isTool then
            self.player.holdColdTime = math.max(8, item.coldTime)
        end
    end

    if NetMode.current == NetMode.Server then

        -- drop item
        local trashSlot = self.trashInventory:GetSlot(0)
        if trashSlot.hasStack then
            player:DropItem(trashSlot:GetStack())
            trashSlot:ClearStack()
        end

        local biomeID = player.biomeID
        AdvancementTriggers.getInstance():TriggerEnterBiome(player, biomeID)

        if self.throwingBoomerang then
            self.throwingBoomerangTime = self.throwingBoomerangTime - 1
            if self.throwingBoomerangTime <= 0 then
                self.throwingBoomerangTime = 0
                self.throwingBoomerang = false
            end
        end

    end

    DebugHelper.RunDebug(player)

    if NetMode.current == NetMode.Client then
        if player.isCurrentClientPlayer then
            self:ClientInteract()
        end
    end

    self.bone.joints.scale = Vector2.new(1.0, 1.0)
    animator:setFloat("Speed", speedRate)
    animator:setFloat("AirSpeed", player.speedY)
    self.bone.joints.flip = not player.facingDirection
    self.bone:update()

    self:UpdateBone()

    heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack then
        heldSlot:GetStack():RunOnHeldEvent(player)
    end

end

function GPlayer:UpdateBone()
    local player = self.player

    local isServer = NetMode.current == NetMode.Server
    local heldSlot = self:GetHeldSlot()

    self.bone.animator:setLayerTimeScale(1, 1.0)
    self.lastTickAction = self.currentAction

    -- change the skin by equipment
    if not isServer then

        local changeSkinData = false
        if self.equipmentSkinCacheData == nil then
            changeSkinData = true
        else
            local equipmentInventory = player.equipmentInventory
            for i = 0, 5 do
                local slot = equipmentInventory:GetSlot(i)
                local cacheID = self.equipmentSkinCacheData[i + 1]
                if slot.hasStack then
                    if slot:GetStack():GetItem().id ~= cacheID then
                        changeSkinData = true
                        break
                    end
                elseif cacheID ~= 0 then
                    changeSkinData = true
                    break
                end
            end
        end

        if changeSkinData then

            -- save equipment data to cache
            self.equipmentSkinCacheData = {}
            local equipmentInventory = player.equipmentInventory
            for i = 0, 5 do
                local slot = equipmentInventory:GetSlot(i)
                if slot.hasStack then
                    self.equipmentSkinCacheData[i + 1] = slot:GetStack():GetItem().id
                else
                    self.equipmentSkinCacheData[i + 1] = 0
                end
            end

            local HAT_INDICES = { 3, 0 }
            local CLOTH_INDICES = { 4, 1 }
            local PANT_INDICES = { 5, 2 }
            local hatTex, clothTex, pantTex
            local showHair = true

            for i = 1, 2 do
                local index = HAT_INDICES[i]
                local slot = equipmentInventory:GetSlot(index)

                if slot.hasStack and slot:GetStack():GetItem().toolType == "HELMET" then
                    hatTex = slot:GetStack():GetItem().entityTextureLocation
                    showHair = slot:GetStack():GetItem().showHair
                    break
                end
            end
            for i = 1, 2 do
                local index = CLOTH_INDICES[i]
                local slot = equipmentInventory:GetSlot(index)
                if slot.hasStack and slot:GetStack():GetItem().toolType == "CHESTPLATE" then
                    clothTex = slot:GetStack():GetItem().entityTextureLocation
                    break
                end
            end
            for i = 1, 2 do
                local index = PANT_INDICES[i]
                local slot = equipmentInventory:GetSlot(index)
                if slot.hasStack and slot:GetStack():GetItem().toolType == "LEGGINGS" then
                    pantTex = slot:GetStack():GetItem().entityTextureLocation
                    break
                end
            end

            PlayerBoneInfo.setSkinByID(self.bone, self.player.skinID)

            local skinTable = PlayerBoneInfo.getSkinTableByID(self.player.skinID)
            if not showHair then
                skinTable.hair = nil
            end
            if hatTex then
                skinTable.hat = hatTex
            end
            if clothTex then
                skinTable.cloth = clothTex
            end
            if pantTex then
                skinTable.pant = pantTex
            end

            PlayerBoneInfo.setSkin(self.bone, skinTable)
        end
    end

    if self.currentAction == BoneAction.None then
        -- client: using current action by specify item
        -- server: get the new action from client side
        self.currentAction = player.remoteDataWatcher:GetInteger(self.BONE_ACTION)
        self.currentActionTick = 0
        self.currentActionMaxTicks = 0
        local beginFunc = self._animationBeginFunc[self.currentAction]
        if beginFunc then
            beginFunc(self)
        else
            self.currentAction = BoneAction.None
        end
    end

    if heldSlot.hasStack then
        local item = heldSlot:GetStack():GetItem()
        local holdingItemAnm = false
        if item.isBlock or item.isMaterial then
            holdingItemAnm = true
        end
        self.bone.animator:setBool("HoldingItem", holdingItemAnm)
    end

    if self.currentAction ~= BoneAction.None then
        local updateFunc = self._animationUpdateFunc[self.currentAction]
        if updateFunc then
            updateFunc(self)
        end
        if self.currentActionTick >= self.currentActionMaxTicks + 1 then
            local endFunc = self._animationEndFunc[self.currentAction]
            if endFunc then
                endFunc(self)
            end
            self.currentActionTick = 0
            self.bone.animator:setTrigger("StopAction")
        else
            self.currentActionTick = self.currentActionTick + 1
        end
    end

    if not isServer then
        -- swim animation (kicking legs)
        if not player.stand and self.swimTime > 0 then
            local angle1 = -Utils.SinValue(self.swimTime, 32) * 0.5
            local angle2 = -angle1
            local body = self.bone.joints:getJoint("base.body")
            local front_leg = body:getChild("front_leg")
            local back_leg = body:getChild("back_leg")
            front_leg.angle = angle1
            back_leg.angle = angle2
        end
    end

    if player.dying then
        self.bone.animator:setBool("Death", true)
        if not isServer then
            if self.deathUI == nil then
                self.deathUI = require("ui.DeathUI").new()
                -- TODO:关闭其他打开的GUI
            end
        end
    else
        self.bone.animator:setBool("Death", false)
        if not isServer then
            if self.deathUI ~= nil then
                self.deathUI:closeWindow()
                self.deathUI = nil
            end
        end
    end

    self.bone:update(false)
end

function GPlayer:OnSwordAttackingAnimationBegin()
    self.bone.animator:setTrigger("SwordAttacking")
    self.currentActionMaxTicks = self.player.holdColdTime
end

function GPlayer:EndAction()
    if self.currentAction ~= BoneAction.None then
        self.currentAction = BoneAction.None
        self.currentActionTick = 0
        return true
    end
    return false
end

function GPlayer:OnSwordAttackingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnSwordAttackingAnimationUpdate()
    local timeScale = self.currentActionMaxTicks > 0 and (60.0 / self.currentActionMaxTicks) or 1.0
    self.bone.animator:setLayerTimeScale(1, timeScale)
    self:UseHeldItem()
end

function GPlayer:OnPlacingAnimationBegin()
    self.bone.animator:setTrigger("Placing")
    self.currentActionMaxTicks = 16
end

function GPlayer:OnPlacingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnEatingAnimationBegin()
    self.bone.animator:setTrigger("Eating")
    self.currentActionMaxTicks = 16
    if NetMode.current == NetMode.Server then
        self:TryUseHeldItem()
    else
        local xi = Utils.Cell(self.player.centerX)
        local yi = Utils.Cell(self.player.centerY)

        SoundUtils.PlaySound(Reg.SoundID("drink"), xi, yi)
    end
end

function GPlayer:OnEatingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnDiggingAnimationBegin()
    self.bone.animator:setTrigger("StopAction")
    self.currentActionMaxTicks = self.player.holdColdTime
end

function GPlayer:OnDiggingAnimationEnd()
    if self:EndAction() then
        self.player.direction = self.player.facingDirection
    end
end

function GPlayer:OnDiggingAnimationUpdate()
    if self.currentActionMaxTicks <= 0 then
        return
    end
    self:UpdateLookAngle()
    local body = self.bone.joints:getJoint("base.body")
    local head = body:getChild("head")
    local back_arm = body:getChild("back_arm")

    local rate = self.currentActionTick / self.currentActionMaxTicks
    local lookAngle = self:GetLookAngleInFacingDirection()

    back_arm.angle = lookAngle + math.pi * 0.5 * (2 * rate - 2.0)
    head.angle = (math.abs(lookAngle + math.pi / 2) - math.pi / 2) / 8

end

function GPlayer:OnBowShootingAnimationBegin()
    self.bone.animator:setTrigger("StopAction")
    self.currentActionMaxTicks = self.player.holdColdTime
    self:UseHeldItem()
end

function GPlayer:OnBowShootingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnBowShootingAnimationUpdate()
    if self.currentActionMaxTicks <= 0 then
        return
    end
    self:UpdateLookAngle()
end

function GPlayer:OnStaffShootingAnimationBegin()
    self.bone.animator:setTrigger("StopAction")
    self.currentActionMaxTicks = self.player.holdColdTime
end

function GPlayer:OnStaffShootingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnStaffShootingAnimationUpdate()
    if self.currentActionMaxTicks <= 0 then
        return
    end
    self:UpdateLookAngle()
    self:UseHeldItem()
end

function GPlayer:OnGunShootingAnimationBegin()
    self.bone.animator:setTrigger("StopAction")
    self.currentActionMaxTicks = self.player.holdColdTime
end

function GPlayer:OnGunShootingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnGunShootingAnimationUpdate()
    if self.currentActionMaxTicks <= 0 then
        return
    end
    self:UpdateLookAngle()
    self:UseHeldItem()
end

function GPlayer:OnHoldLookingAnimationBegin()
    self.bone.animator:setTrigger("StopAction")
    self.currentActionMaxTicks = 11
end

function GPlayer:OnHoldLookingAnimationEnd()
    self:EndAction()
end

function GPlayer:OnHoldLookingAnimationUpdate()
    if self.currentActionMaxTicks <= 0 then
        return
    end
    self:UpdateLookAngle()
end

function GPlayer:_onMouseScroll(_, deltaY)
    if deltaY == 0 then
        return
    end
    local player = self.player
    if not player.isCurrentClientPlayer then
        return
    end

    local UIManager = require("ui.UIManager")
    if UIManager.getInstance():hasUIGroup(require("ui.UIDefault").GROUP_GAME_WINDOW) then
        return
    end

    if deltaY > 0 then
        if player.heldSlotIndex == 0 then
            player.heldSlotIndex = 9
        else
            player.heldSlotIndex = player.heldSlotIndex - 1
        end
    else
        if player.heldSlotIndex == 9 then
            player.heldSlotIndex = 0
        else
            player.heldSlotIndex = player.heldSlotIndex + 1
        end
    end
end

function GPlayer:CheckDoorAutoOperation()
    -- Auto door operation is only available in mobile.
    if not SettingsData.isMobileOperation then
        return
    end

    local player = self.player
    if self.doorOpenColdTime > 0 then
        self.doorOpenColdTime = self.doorOpenColdTime - 1
    end
    if self.doorCloseColdTime > 0 then
        self.doorCloseColdTime = self.doorCloseColdTime - 1
    end
    if math.abs(player.speedX) < 0.5 then
        return
    end
    local frontDir = player.speedX > 0 and 1 or -1
    local xi = player.centerXi + frontDir * 2
    local xi2 = player.centerXi - frontDir * 2
    local yi = player.centerYi
    if self.doorOpenColdTime == 0 then
        local frontID = MapUtils.GetFrontID(xi, yi)
        if frontID > 0 then
            local blockData = BlockUtils.GetData(frontID)
            if blockData.isDoorClosed then
                player:RequestClickMap(xi, yi)
                self.doorOpenColdTime = 32
            end
        end
    end
    if self.doorCloseColdTime == 0 then
        local frontID = MapUtils.GetFrontID(xi2, yi)
        if frontID > 0 then
            local blockData = BlockUtils.GetData(frontID)
            if blockData.isDoorOpened then
                player:RequestClickMap(xi2, yi)
                self.doorCloseColdTime = 32
            end
        end
    end
end

function GPlayer:ClientInteract()
    local player = self.player
    if not player.isCurrentClientPlayer then
        return
    end

    if player.heldSlotIndexJustChanged then
        self.aimOffsetX = 0
        self.aimOffsetY = 0
        self.lastAimOffsetX = 0
        self.lastAimOffsetY = 0
    end

    local inputControl = InputControl.getInstance()
    local pressingNum = InputControl.getCurrentPressingKeyNum()
    if pressingNum ~= -1 and (pressingNum >= 0 and pressingNum <= 9) then
        if pressingNum == 0 then
            player.heldSlotIndex = 9
        else
            player.heldSlotIndex = pressingNum - 1
        end
    end

    if inputControl.isMapClicking then
        inputControl.isMapClicking = false
        local clickPosition = inputControl.touchMapPosition:clone()
        local realPosition = Vector2.new(clickPosition.x + MiscUtils.screenX, clickPosition.y + MiscUtils.screenY)
        if realPosition:getDistance(Vector2.new(player.centerX, player.centerY)) < INTERACTION_DISTANCE then
            local xi = Utils.Cell(realPosition.x)
            local yi = Utils.Cell(realPosition.y)
            player:RequestClickMap(xi, yi)
        end
    end

    -- hide wire render
    MapUtils.SetWireVisible(false)
    -- hide block preview
    MapUtils.ClearBlockRenderPreview()

    -- auto open or close door
    self:CheckDoorAutoOperation()

    player:SetSmartMode(SmartMode.None)
    local heldSlot = self:GetHeldSlot()
    local behavior = Behavior.None
    -- refresh the player action
    player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.None)
    -- refresh placing time
    if self.placeColdTime ~= 0 then
        self.placeColdTime = math.max(self.placeColdTime - 1, 0)
    end
    self.player.holdColdTime = 0
    player.facingDirection = player.direction

    if heldSlot.hasStack then
        local itemStack = heldSlot:GetStack()
        local item = itemStack:GetItem()
        if item.isBlock then
            -- holding a block item
            behavior = Behavior.Placing
        elseif item.isTool then
            -- holding a tool item
            local tempBehavior = ToolBehaviorProxies[item.toolType]
            if tempBehavior ~= nil then
                behavior = tempBehavior
            end
            self.player.holdColdTime = math.max(8, item.coldTime)
        elseif item.isMaterial then
            -- holding a material item
            local itemID = item.id
            if item.isSeed then
                behavior = Behavior.Seeding
            elseif item.eatable then
                behavior = Behavior.Eating
            elseif MiscHelper.IsEmptyBucket(itemID) then
                behavior = Behavior.LoadingLiquid
            elseif MiscHelper.IsEmptyGrassBottle(itemID) then
                behavior = Behavior.LoadingBottle
            elseif MiscHelper.IsPullableBucket(itemID) then
                behavior = Behavior.PullingLiquid
            elseif MiscHelper.IsEmptyBowl(itemID) then
                behavior = Behavior.LoadingBowl
            elseif MiscHelper.IsBoneMeal(itemID) then
                behavior = Behavior.Ripening
            else
                local modItem = itemStack:GetModItem()
                if modItem then
                    if modItem.isBossCaller then
                        behavior = Behavior.Eating
                    end
                end
            end
        else
            if item.type == ItemType.Projectile then
                if item.canThrow then
                    behavior = Behavior.Throwing
                end
            elseif item.type == ItemType.Wire then
                behavior = Behavior.PlacingWire
            end
        end
    end

    if behavior ~= Behavior.None then
        local fun = self._clientInteractProxies[behavior]
        if fun then
            fun(self)
        end
    end
end

function GPlayer:ClientSwordAttacking()
    local inputControl = InputControl.getInstance()
    inputControl.aimMode = ControlAimMode.PressOnly
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack and (inputControl.aimTriggerUsing or inputControl.isPcMouseLeftPressingAtMap) then
        if not SettingsData.isMobileOperation then
            -- PC
        end
        player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.SwordAttacking)
        local item = heldSlot:GetStack():GetItem()
        player.holdColdTime = item.coldTime
    end
end

function GPlayer:ClientBowShooting()
    local inputControl = InputControl.getInstance()
    inputControl.aimMode = ControlAimMode.LookDirectionOrShoot
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack and (inputControl.aimTriggerUsing or inputControl.isPcMouseLeftPressingAtMap) then
        self.player.direction = self.player.facingDirection
        player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.BowShooting)
        local item = heldSlot:GetStack():GetItem()
        player.holdColdTime = item.coldTime
    end
    self:UpdateLookAngle()
end

function GPlayer:ClientStaffShooting()
    local inputControl = InputControl.getInstance()
    inputControl.aimMode = ControlAimMode.LookDirectionOrShoot
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack and (inputControl.aimTriggerUsing or inputControl.isPcMouseLeftPressingAtMap) then
        self.player.direction = self.player.facingDirection
        player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.StaffShooting)
        local item = heldSlot:GetStack():GetItem()
        player.holdColdTime = item.coldTime
    end
end

function GPlayer:ClientGunShooting()
    local inputControl = InputControl.getInstance()
    inputControl.aimMode = ControlAimMode.LookDirectionOrShoot
    local player = self.player
    local heldSlot = self:GetHeldSlot()

    player.lookAngle = 0
    if not player.facingDirection then
        player.lookAngle = math.pi
    end

    if heldSlot.hasStack and (not SettingsData.isMobileOperation or inputControl.aimPressing) then
        self:UpdateLookAngle()
        self.player.direction = self.player.facingDirection
        if inputControl.aimTriggerUsing or inputControl.isPcMouseLeftPressingAtMap then
            player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.GunShooting)
            local item = heldSlot:GetStack():GetItem()
            player.holdColdTime = item.coldTime
            --else
            --    player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.HoldLooking)
            --    player.holdColdTime = 1
        end
    end
end

function GPlayer:ClientPlacing()
    local xi, yi, op = self:CheckAimPositionInMap()
    local player = self.player
    local heldSlot = self:GetHeldSlot()

    if heldSlot.hasStack then
        local blockID = heldSlot:GetStack():GetItem().blockID
        if blockID > 0 then
            local canPlace = false
            if InputControl.getInstance().operatingWall then
                canPlace = MapUtils.CanPlaceWall(xi, yi, blockID)
            else
                canPlace = MapUtils.CanPlaceFront(xi, yi, blockID)
            end

            if canPlace and not SettingsData.isMobileOperation and not self:InInteractionDistanceIPos(xi, yi) then
                canPlace = false
            end

            local ox = self.player.centerX + self.aimOffsetX
            local oy = self.player.centerY + self.aimOffsetY

            MapUtils.SetBlockRenderPreview(blockID, ox, oy, canPlace, player.centerX, player.centerY)
        end
    end

    if heldSlot.hasStack and op == 1 then
        player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Placing)
        -- skip placing
        if self.placeColdTime > 0 then
            return
        end
        if not SettingsData.isMobileOperation and not self:InInteractionDistanceIPos(xi, yi) then
            return
        end
        player:RequestPlaceBlock(xi, yi, player.heldSlotIndex, InputControl.getInstance().operatingWall)
        self.placeColdTime = 8
        player.direction = xi * 16 + 8 > player.centerX
    end
end

function GPlayer:ClientPlacingWire()
    local xi, yi, op = self:CheckAimPositionInMap()
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    MapUtils.SetWireVisible(true)
    -- skip placing
    if self.placeColdTime > 0 then
        return
    end
    if not SettingsData.isMobileOperation and not self:InInteractionDistanceIPos(xi, yi) then
        return
    end
    if heldSlot.hasStack and op == 1 then
        player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Placing)
        if player:RequestPlaceWire(xi, yi, player.heldSlotIndex) then
            SoundUtils.PlaySoundGroup(Reg.SoundGroupID("cloth"))
        end
        self.placeColdTime = 8
        player.direction = xi * 16 + 8 > player.centerX
    end
end

function GPlayer:_CanRemoveWire(xi, yi)
    local heldSlot = self:GetHeldSlot()
    if not heldSlot.hasStack then
        return false
    end
    local item = heldSlot:GetStack():GetItem()
    if item.toolType ~= "WIRE_CUTTER" then
        return false
    end
    return MapUtils.HasWire(xi, yi)
end

function GPlayer:ClientRemovingWire()
    local xi, yi, op = self:CheckAimPositionInMap()
    local player = self.player
    MapUtils.SetWireVisible(true)
    if not SettingsData.isMobileOperation and not self:InInteractionDistanceIPos(xi, yi) then
        return
    end
    if op == 1 then
        if self:_CanRemoveWire(xi, yi) then
            MapUtils.RemoveWire(xi, yi)
            player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Placing)
            self.placeColdTime = 8
            player.direction = xi * 16 + 8 > player.centerX
            NetworkProxy.RPCSendServerBound(Mod.current, RPC_ID.SB_REMOVE_WIRE, xi, yi)
        end
    end
end

function GPlayer:OnRemovingWireBound(xi, yi)
    if self:_CanRemoveWire(xi, yi) then
        MapUtils.RemoveWireAndDrop(xi, yi)
        SoundUtils.PlaySoundGroup(Reg.SoundGroupID("cloth"), xi, yi)

    else
        MapUtils.SyncUnit(xi, yi)
    end
end

function GPlayer:ClientEating()
    local inputControl = InputControl.getInstance()
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack and (inputControl.aimTriggerUsing or inputControl.isPcMouseLeftInstantDownAtMap) then
        local stack = heldSlot:GetStack()
        if stack:CanUse(player) then
            player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Eating)
        end
    end
end

function GPlayer:ClientThrowing()
    local inputControl = InputControl.getInstance()
    inputControl.aimMode = ControlAimMode.LookDirectionOrShoot
    local player = self.player
    local heldSlot = self:GetHeldSlot()

    player.lookAngle = 0
    if not player.facingDirection then
        player.lookAngle = math.pi
    end

    if heldSlot.hasStack and (inputControl.aimPressing or not SettingsData.isMobileOperation) then
        self:UpdateLookAngle()
        self.player.direction = self.player.facingDirection
        if inputControl.aimTriggerUsing or inputControl.isPcMouseLeftInstantDownAtMap then
            if self.placeColdTime > 0 then
                return
            end
            player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Placing)
            self.placeColdTime = 16

            NetworkProxy.RPCSendServerBound(Mod.current, RPC_ID.SB_PLAYER_THROWING, player.lookAngle)
        end
    end
end

function GPlayer:CheckThrowing(angle)
    local heldSlot = self:GetHeldSlot()
    if not heldSlot.hasStack then
        return false
    end
    local item = heldSlot:GetStack():GetItem()

    local player = self.player

    -- Check if item is boomerang
    if item.toolType == "BOOMERANG" then
        if self.throwingBoomerang then
            return false
        end
        local proj = ProjectileUtils.CreateFromPlayer(player, item.projectileID,
                player.centerX, player.centerY,
                item.speed * math.cos(angle), item.speed * math.sin(angle),
                item.baseAttack
        )
        proj.targetTime = 100
        proj.isCheckPlayer = false
        proj.isCheckNpc = true
        local mp = proj:GetModProjectile()
        if mp then
            mp.playerOwnerIndex = EntityIndex.new(player.entityIndex.entityID, player.entityIndex.uniqueID)
            self.throwingBoomerangTime = 1000
            self.throwingBoomerang = true
        end
    else
        if not (item.type == ItemType.Projectile and item.canThrow) then
            return false
        end
        local proj = ProjectileUtils.CreateFromPlayer(player, item.projectileID,
                player.centerX, player.centerY,
                item.speed * math.cos(angle), item.speed * math.sin(angle),
                item.baseAttack
        )
        proj.isCheckPlayer = false
        proj.isCheckNpc = true
        proj.targetTime = item.coldTime

        heldSlot:DecrStackSize(1)
    end

    return true
end

function GPlayer:OnThrowingServerBound(angle)
    local ok = self:CheckThrowing(angle)
    if not ok then
        self:GetHeldSlot():SyncAll()
    end
end

function GPlayer:ClientDoMapOp(opType, conditionFunc, removeOneOnSend)
    local xi, yi, op = self:CheckAimPositionInMap()
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack and op == 1 then
        if self.placeColdTime > 0 then
            return
        end
        if not SettingsData.isMobileOperation and not self:InInteractionDistanceIPos(xi, yi) then
            return
        end
        player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Placing)

        if conditionFunc ~= nil and not conditionFunc(self, xi, yi, heldSlot) then
            return
        end

        if removeOneOnSend == nil then
            removeOneOnSend = true
        end
        if removeOneOnSend then
            heldSlot:DecrStackSize(1)
        end

        NetworkProxy.RPCSendServerBound(Mod.current, RPC_ID.SB_PLAYER_MAP_OPERATION,
                opType, xi, yi
        )

        self.placeColdTime = 8
        player.direction = xi * 16 + 8 > player.centerX
    end
end

---_CanLoadLiquid
---@param xi int
---@param yi int
---@param heldSlot Slot
function GPlayer:_CanLoadLiquid(xi, yi, heldSlot)
    if not (heldSlot.hasStack and MiscHelper.IsEmptyBucket(heldSlot:GetStack():GetItem().id)) then
        return false
    end
    local npcs = NpcUtils.SearchByRect(xi * 16 + 8, yi * 16 + 8, 1, 1)
    ---@param npc Npc
    for _, npc in each(npcs) do
        if MiscHelper.IsCow(npc.id) then
            return true
        end
    end

    local liquidID, amount = MapUtils.GetLiquidIDAmount(xi, yi)
    if not (liquidID > 0 and amount > 60) then
        return false
    end
    if MiscHelper.GetBucketIDFromLiquidID(liquidID) == 0 then
        return false
    end
    return true
end

function GPlayer:ServerLoadingLiquid(xi, yi)
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if not self:_CanLoadLiquid(xi, yi, heldSlot) then
        return false
    end
    local npcs = NpcUtils.SearchByRect(xi * 16 + 8, yi * 16 + 8, 1, 1)
    ---@param npc Npc
    for _, npc in each(npcs) do
        if MiscHelper.IsCow(npc.id) then
            heldSlot:DecrStackSize(1)

            local remain = player.backpackInventory:AddItemStack(ItemStack.new(ItemRegistry.GetItemByID(MiscHelper.GetMilkBucketID())))
            if remain:Valid() then
                player:DropItem(remain)
            end

            SoundUtils.PlaySoundGroup(Reg.SoundGroupID("swim"), xi, yi)
            return true
        end
    end

    local liquidID = MapUtils.GetLiquidID(xi, yi)
    if liquidID == 0 then
        return false
    end
    heldSlot:DecrStackSize(1)
    MapUtils.RemoveLiquid(xi, yi)
    MapUtils.TriggerLiquid(xi - 1, yi)
    MapUtils.TriggerLiquid(xi, yi - 1)
    MapUtils.TriggerLiquid(xi, yi + 1)
    MapUtils.TriggerLiquid(xi + 1, yi)
    local liquidBucketID = MiscHelper.GetBucketIDFromLiquidID(liquidID)
    if liquidBucketID > 0 then
        local remain = player.backpackInventory:AddItemStack(ItemStack.new(ItemRegistry.GetItemByID(liquidBucketID)))
        if remain:Valid() then
            player:DropItem(remain)
        end
    end
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("swim"), xi, yi)

    return true
end

function GPlayer:ClientLoadingLiquid()
    self:ClientDoMapOp(MapOpType.LoadingLiquid, self._CanLoadLiquid)
end

---_GetLoadBowlNpc
---@param xi int
---@param yi int
---@return Npc
function GPlayer:_GetLoadBowlNpc(xi, yi)
    local npcs = NpcUtils.SearchByRect(xi * 16 + 8, yi * 16 + 8, 1, 1)
    ---@param npc Npc
    for _, npc in each(npcs) do
        if MiscHelper.IsMushroomCow(npc.id) then
            return npc
        end
    end
    return nil
end

---_CanLoadBowl
---@param xi int
---@param yi int
---@param heldSlot Slot
function GPlayer:_CanLoadBowl(xi, yi, heldSlot)
    if not (heldSlot.hasStack and MiscHelper.IsEmptyBowl(heldSlot:GetStack():GetItem().id)) then
        return false
    end
    return self:_GetLoadBowlNpc(xi, yi) ~= nil
end

function GPlayer:ServerLoadingBowl(xi, yi)
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if not self:_CanLoadBowl(xi, yi, heldSlot) then
        return false
    end
    local npc = self:_GetLoadBowlNpc(xi, yi)
    if npc == nil then
        return false
    end
    heldSlot:DecrStackSize(1)

    local remain = player.backpackInventory:AddItemStack(ItemStack.new(ItemRegistry.GetItemByID(MiscHelper.GetMushroomBowl())))
    if remain:Valid() then
        player:DropItem(remain)
    end

    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("swim"), xi, yi)
    return true
end

function GPlayer:ClientLoadingBowl()
    self:ClientDoMapOp(MapOpType.LoadingBowl, self._CanLoadBowl)
end

function GPlayer:ClientShearing()
    --TODO:
    --self:ClientDoMapOp(MapOpType.Shearing, self._CanShearing)
end

---_CanLoadBottle
---@param xi int
---@param yi int
---@param heldSlot Slot
function GPlayer:_CanLoadBottle(xi, yi, heldSlot)
    local liquidID = MapUtils.GetLiquidID(xi, yi)
    if not (heldSlot.hasStack and MiscHelper.IsEmptyGrassBottle(heldSlot:GetStack():GetItem().id)) then
        return false
    end
    if not (liquidID > 0) then
        return false
    end
    return liquidID == Reg.LiquidID("water")
end

function GPlayer:ServerLoadingBottle(xi, yi)
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if not self:_CanLoadBottle(xi, yi, heldSlot) then
        return false
    end
    heldSlot:DecrStackSize(1)
    local remain = player.backpackInventory:AddItemStack(ItemStack.new(ItemRegistry.GetItemByID(Reg.ItemID("potion_water"))))
    if remain:Valid() then
        player:DropItem(remain)
    end
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("swim"), xi, yi)

    return true
end

function GPlayer:ClientLoadingBottle()
    self:ClientDoMapOp(MapOpType.LoadingBottle, self._CanLoadBottle)
end

function GPlayer:_CanPullLiquid(xi, yi, heldSlot)
    if not heldSlot.hasStack then
        return false
    end
    if MapUtils.IsSolid(xi, yi) then
        return false
    end
    local liquidPullID = MiscHelper.GetLiquidIDFromBucket(heldSlot:GetStack():GetItem().id)
    if liquidPullID == 0 then
        return
    end

    local liquidID = MapUtils.GetLiquidID(xi, yi)
    if liquidID == 0 or liquidID == liquidPullID then
        return true
    end
    return false
end

function GPlayer:ServerPullingLiquid(xi, yi)
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if not self:_CanPullLiquid(xi, yi, heldSlot) then
        return false
    end
    local liquidPullID = MiscHelper.GetLiquidIDFromBucket(heldSlot:GetStack():GetItem().id)
    MapUtils.SetLiquid(xi, yi, liquidPullID)
    MapUtils.TriggerLiquid(xi, yi)
    heldSlot:DecrStackSize(1)
    local remain = player.backpackInventory:AddItemStack(ItemStack.new(ItemRegistry.GetItemByID(MiscHelper.GetEmptyBucketID())))
    if remain:Valid() then
        player:DropItem(remain)
    end
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("swim"), xi, yi)

    return true
end

function GPlayer:ClientPullingLiquid()
    self:ClientDoMapOp(MapOpType.PullingLiquid, self._CanPullLiquid)
end

---_CanFarm
---@param xi int
---@param yi int
---@param heldSlot Slot
function GPlayer:_CanFarm(xi, yi, heldSlot)
    if not heldSlot.hasStack then
        return false
    end
    if heldSlot:GetStack():GetItem().toolType ~= "HOE" then
        return
    end
    local blockID = MapUtils.GetFrontID(xi, yi)
    if blockID == 0 then
        return false
    end
    return MiscHelper.CanTransformToFramland(blockID)
end

function GPlayer:ServerFarming(xi, yi)
    local player = self.player
    local heldSlot = self:GetHeldSlot()
    if not self:_CanFarm(xi, yi, heldSlot) then
        return false
    end
    MapUtils.RemoveFront(xi, yi)
    MapUtils.PlaceFront(xi, yi, MiscHelper.GetFarmlandID())
    if player.gameMode ~= GameMode.Creative then
        --heldSlot:GetStack():LoseDurable(1)
    end
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("farm"), xi, yi)
    return true
end

function GPlayer:ClientFarming()
    self:ClientDoMapOp(MapOpType.Farming, self._CanFarm, false)
end

---@param xi int
---@param yi int
---@param heldSlot Slot
function GPlayer:_CanSeeding(xi, yi, heldSlot)
    if not heldSlot.hasStack then
        return false
    end
    if not MapUtils.IsAreaValid(xi, yi, 1, 2) then
        return false
    end
    if MapUtils.HasFront(xi, yi) then
        return false
    end
    local downID = MapUtils.GetFrontID(xi, yi + 1)
    if downID == 0 then
        return false
    end
    if not MapUtils.IsSolid(xi, yi + 1) then
        return false
    end
    local item = heldSlot:GetStack():GetItem()
    if not (item.isSeed and item.blockID > 0) then
        return false
    end
    if not MapUtils.CanPlaceFront(xi, yi, item.blockID) then
        return false
    end
    local data = BlockUtils.GetData(downID)
    if not data:CanSeed(item.id) then
        return false
    end
    return true
end

function GPlayer:ServerSeeding(xi, yi)
    local heldSlot = self:GetHeldSlot()
    if not self:_CanSeeding(xi, yi, heldSlot) then
        return false
    end
    local item = heldSlot:GetStack():GetItem()
    MapUtils.PlaceFront(xi, yi, item.blockID)
    heldSlot:DecrStackSize(1)
    SoundUtils.PlaySoundGroup(Reg.SoundGroupID("farm"), xi, yi)
    return true
end

function GPlayer:ClientSeeding()
    self:ClientDoMapOp(MapOpType.Seeding, self._CanSeeding)
end

---@param xi int
---@param yi int
---@param heldSlot Slot
function GPlayer:_CanRipen(xi, yi, heldSlot)
    if not heldSlot.hasStack then
        return false
    end
    if not MiscHelper.IsBoneMeal(heldSlot:GetStack():GetItem().id) then
        return false
    end
    if not MapUtils.HasFront(xi, yi) then
        return false
    end
    return true
end

function GPlayer:ServerRipen(xi, yi)
    local heldSlot = self:GetHeldSlot()
    if not self:_CanRipen(xi, yi, heldSlot) then
        return false
    end

    MapUtils.DoRandomTick(xi, yi)

    heldSlot:DecrStackSize(1)
    SoundUtils.PlaySound(Reg.SoundID("shear"), xi, yi)
    return true
end

function GPlayer:ClientRipening()
    self:ClientDoMapOp(MapOpType.Ripening, self._CanRipen)
end

function GPlayer:OnMapOpServerBound(opType, xi, yi)
    local heldSlot = self:GetHeldSlot()
    local success = false

    local func = self._mapOpFunc[opType]
    if func ~= nil then
        success = func(self, xi, yi)
    end

    if not success then
        MapUtils.SyncUnit(xi, yi)
        heldSlot:SyncAll()
    end
end

function GPlayer.GetMiningToolType(toolType)
    if toolType == "DRILL" then
        return "PICKAXE"
    elseif toolType == "SAW" then
        return "AXE"
    end
    return toolType
end

function GPlayer:ClientDigging()
    local xi, yi, op = self:CheckAimPositionInMap()
    local player = self.player
    -- Just switch the held slot, skip process
    if player.heldSlotIndexJustChanged then
        return
    end
    local operatingWall = InputControl.getInstance().operatingWall
    local heldSlot = self:GetHeldSlot()
    if not heldSlot.hasStack then
        return
    end
    local stack = heldSlot:GetStack()
    local item = stack:GetItem()
    local isSmart = InputControl.getInstance().isSmart
    if not item.isTool then
        return
    end
    local toolType = GPlayer.GetMiningToolType(item.toolType)
    if isSmart then
        player:SetSmartMode(SmartMode.Digging, xi, yi, operatingWall, stack, toolType)
    end
    if op == 1 then
        local readyToRequest = false

        if isSmart and player.isSmartPositionFound then
            xi, yi = player:GetSmartPosition()
            readyToRequest = true
        else
            if SettingsData.isMobileOperation then
                readyToRequest = true
            else
                readyToRequest = self:InInteractionDistanceIPos(xi, yi)
            end
        end
        if readyToRequest then
            player:RequestDigBlock(xi, yi, player.heldSlotIndex, operatingWall, toolType)
            player.remoteDataWatcher:UpdateInteger(self.BONE_ACTION, BoneAction.Digging)
        end
    end
end

function GPlayer:InInteractionDistanceIPos(xi, yi)
    local player = self.player
    return player:GetDistance(xi * 16 + 8, yi * 16 + 8) < INTERACTION_DISTANCE
end

function GPlayer:OnRender()
    self.bone.joints:render(cameraInGameInstance.camera)
    local slot = self:GetHeldSlot()
    if slot.hasStack then
        local stack = slot:GetStack()
        stack:RunOnHeldRenderEvent(self.player)
    end
end

function GPlayer:TryUseHeldItem()
    local slot = self:GetHeldSlot()
    if slot.hasStack then
        local stack = slot:GetStack()
        if stack:CanUse(self.player) then
            self:UseHeldItem()
        end
    end
end

function GPlayer:UseHeldItem()
    local slot = self:GetHeldSlot()
    if slot.hasStack then
        local stack = slot:GetStack()
        stack:RunOnUsedEvent(self.player)
        local killed = false
        if stack:GetItem().maxDurable > 0 and stack.durable == 0 then
            if stack:RunOnDurableEmptyEvent(self.player) then
                slot:ClearStack()
                killed = true
            end
        end
        if not killed then
            local modItem = stack:GetModItem()
            if modItem ~= nil and modItem.IsKilledAfterUsed ~= nil and modItem:IsKilledAfterUsed() then
                if modItem.OnKilledAfterUsed then
                    modItem:OnKilledAfterUsed(self.player)
                end
                slot:DecrStackSize(1)
                killed = true
            end
        end
    end
end

function GPlayer:GetHeldItemJoint()
    return self.bone.joints:getJoint("base.body.back_arm.back_hand.back_item")
end

function GPlayer:UpdateLookAngle()
    if NetMode.current == NetMode.Client and self.player.isCurrentClientPlayer then
        self.player.lookAngle = 0
        if SettingsData.isMobileOperation then
            if InputControl.getInstance().aimDistance > 0 then
                self.player.lookAngle = Vector2.new(self.aimOffsetX, self.aimOffsetY).angle
            else
                if not self.player.facingDirection then
                    self.player.lookAngle = math.pi
                end
            end
        else
            -- PC
            self.player.lookAngle = Vector2.new(self.aimOffsetX, self.aimOffsetY).angle
        end
        self:FacingByLookAngle()
    end
end

function GPlayer:FacingByLookAngle()
    if self.aimOffsetX ~= 0 then
        local lastFacing = self.player.facingDirection
        self.player.facingDirection = self.aimOffsetX > 0
        if self.player.facingDirection ~= lastFacing then
            self.bone.joints.flip = not self.player.facingDirection
            self.bone:update(false)
        end
    end
end

function GPlayer:GetLookAngleInFacingDirection()
    local lookAngle = self.player.lookAngle
    if not (lookAngle > -math.pi * 0.5 and lookAngle < math.pi * 0.5) then
        lookAngle = math.pi - lookAngle
        lookAngle = Utils.FixAngle(lookAngle)
    end
    return lookAngle
end

function GPlayer:CheckAimPositionInMap()
    InputControl.getInstance().aimMode = ControlAimMode.LookPositionOrUse
    return self:GetAimPositionInMap()
end

function GPlayer:GetAimPositionInMap()
    local xi = Utils.Cell(self.player.centerX + self.aimOffsetX)
    local yi = Utils.Cell(self.player.centerY + self.aimOffsetY)
    local op = 0
    if SettingsData.isMobileOperation then
        if InputControl.getInstance().aimTriggerUsing then
            op = 1
        end
    else
        -- PC
        if InputControl.getInstance().isPcMouseLeftPressingAtMap then
            op = 1
        elseif InputControl.getInstance().isPcMouseRightPressingAtMap then
            op = 2
        end
    end
    return xi, yi, op
end

function GPlayer:GetHeldSlot()
    return self.player.backpackInventory:GetSlot(self.player.heldSlotIndex)
end

function GPlayer:GetAmmoIndexInBackpack(ammoID, ammoLevel, searchBest)
    local backpack = self.player.backpackInventory
    local count = backpack.slotCount
    local res = -1
    local baseAmmoRes = -1
    local minBestAmmoLevel = -1
    for i = 1, count do
        local slot = backpack:GetSlot(i - 1)
        if slot.hasStack then
            local item = slot:GetStack():GetItem()
            if item.isProjectile and item.ammoID == ammoID then
                if not searchBest and item.ammoLevel == ammoLevel then
                    res = i - 1
                    break
                elseif searchBest and item.ammoLevel > minBestAmmoLevel then
                    minBestAmmoLevel = item.ammoLevel
                    res = i - 1
                elseif baseAmmoRes ~= -1 and item.ammoLevel == 0 then
                    baseAmmoRes = i - 1
                end
            end
        end
    end
    -- Use the same ammo level slot first.
    -- If no same level slot found, then we use level 0 slot.
    if res == -1 then
        res = baseAmmoRes
    end
    return res
end

function GPlayer:RecalculateProperties()
    local player = self.player
    local enchantmentProxies = EnchantmentProxies.getInstance()
    local buffProxies = BuffProxies.getInstance()

    player.baseAttack:Restore()
    player.baseDefense:Restore()
    self.manaAddSpeed = 128

    if player.dying then
        return
    end

    DebugHelper.RunDebugProp(player)

    local heldSlot = self:GetHeldSlot()
    if heldSlot.hasStack then
        local stack = heldSlot:GetStack()
        local item = stack:GetItem()

        player.baseAttack.attack = player.baseAttack.attack + item.baseAttack.attack
        player.baseAttack.knockBack = player.baseAttack.knockBack + item.baseAttack.knockBack
        player.baseAttack.crit = player.baseAttack.crit + item.baseAttack.crit

        enchantmentProxies:OnHeld(stack, player)
    end

    local equipmentInventory = player.equipmentInventory
    local fullDressName = nil
    for i = 0, 2 do
        local equipmentSlot = equipmentInventory:GetSlot(i)
        if equipmentSlot.hasStack then
            local stack = equipmentSlot:GetStack()
            local item = stack:GetItem()

            player.baseDefense.defense = player.baseDefense.defense + item.defense

            enchantmentProxies:OnEquipped(i, stack, player)

            if i == 0 then
                fullDressName = DressMappings[i + 1][item.id]
            elseif fullDressName then
                local name = DressMappings[i + 1][item.id]
                if name ~= fullDressName then
                    fullDressName = nil
                end
            end
        else
            fullDressName = nil
        end
    end

    if player.tickTime % 64 == 0 then
        local backpackInventory = player.backpackInventory
        for i = 0, backpackInventory.slotCount - 1 do
            local slot = backpackInventory:GetSlot(i)
            if slot.hasStack then
                enchantmentProxies:OnUpdateSecond(slot:GetStack(), player)
            end
        end
        for i = 0, 2 do
            local slot = equipmentInventory:GetSlot(i)
            if slot.hasStack then
                enchantmentProxies:OnUpdateSecond(slot:GetStack(), player)
            end
        end
    end

    buffProxies:OnUpdatePlayer(player)

    if fullDressName then
        self:OnFullDress(fullDressName)
    end

    if NetMode.current == NetMode.Server then

        -- food
        if player.gameMode ~= GameMode.Creative then
            local interval = 256
            if math.abs(player.speedX) < 0.5 then
                interval = 1024
            end
            if player.foodSaturationLevel > 0 then
                if player.tickTime % interval == 0 then
                    player.foodSaturationLevel = player.foodSaturationLevel - 1
                end
            else
                player.foodSaturationLevel = 0
                if player.foodLevel > 0 then
                    if player.tickTime % interval == 0 then
                        player.foodLevel = player.foodLevel - 1
                    end
                else
                    if player.tickTime % 32 == 0 then
                        player:Strike(DeathReason.STARVE, Attack.new(1, 0, 0))
                    end
                end
            end
        end

        -- auto add hp
        if player.health < player.maxHealth then
            if player.foodLevel >= 90 then
                if player.foodLevel == 100 then
                    if player.tickTime % 64 == 0 then
                        player:Heal(1, false)
                    end
                else
                    if player.tickTime % 128 == 0 then
                        player:Heal(1, false)
                    end
                end
            end
        end

        -- auto add magic
        local maxAutoMana = math.floor(player.maxMana * 0.80)
        if player.mana < maxAutoMana then
            local sp = math.max(1, math.ceil(self.manaAddSpeed))

            if player.tickTime % sp == 0 then
                local offset = math.min(4, maxAutoMana - player.mana)
                if offset > 0 then
                    player:AddMagic(offset, false)
                end
            end
        end
    end

    for i = 1, self.accessoryInventory.slotCount do
        local slot = self.accessoryInventory:GetSlot(i - 1)
        if slot.hasStack then
            local stack = slot:GetStack()
            local modItem = stack:GetModItem()

            if modItem ~= nil and modItem.OnAccessoryUpdate ~= nil then
                modItem:OnAccessoryUpdate(player)
            end
        end
    end
end

function GPlayer:OnFullDress(fullDressName)
    local data = FullDress[fullDressName]
    if data == nil then
        return
    end
    local player = self.player
    if data.advancementID ~= nil then
        player:FinishAdvancement(data.advancementID)
    end
    if data.defense ~= nil then
        player.baseDefense.defense = player.baseDefense.defense + data.defense
    end
    if data.attack ~= nil then
        player.baseAttack.attack = player.baseAttack.attack + data.attack
    end
    if data.fireDefense then
        if player.tickTime % 64 == 0 then
            player:AddBuff(Reg.BuffID("fire_defense"), 100)
        end
    end
    if data.lighting then
        LightingUtils.Add(player.centerXi, player.centerYi, 32)
    end
    if data.speed ~= nil then
        player.speedRate = player.speedRate + data.speed
        if math.abs(player.speedX) > 2 then
            if player.tickTime % 8 == 0 then
                if player.stand then
                    EffectUtils.Create(Reg.EffectID("smoke"),
                            player.randX,
                            player.bottomY,
                            Utils.RandSym(0.25),
                            Utils.RandSym(0.25),
                            Utils.RandSym(0.1), 0.25)
                else
                    EffectUtils.Create(Reg.EffectID("smoke"),
                            player.randX,
                            player.randY,
                            -player.speedX / 8 + Utils.RandSym(0.5),
                            -player.speedY / 8 + Utils.RandSym(0.5),
                            Utils.RandSym(0.1), 0.5, 0.2)
                end
            end
        end
    end
    if data.manaAddSpeed ~= nil then
        self.manaAddSpeed = self.manaAddSpeed * data.manaAddSpeed
    end
end

function GPlayer:HasAccessory(itemID)
    for i = 1, self.accessoryInventory.slotCount do
        local slot = self.accessoryInventory:GetSlot(i - 1)
        if slot.hasStack then
            local stack = slot:GetStack()
            if stack:GetItem().id == itemID then
                return true
            end
        end
    end
    return false
end

function GPlayer:OnHitByNpc(npc)
    local player = self.player
    local enchantmentProxies = EnchantmentProxies.getInstance()
    for i = 0, 2 do
        local equipmentSlot = equipmentInventory:GetSlot(i)
        if equipmentSlot.hasStack then
            local stack = equipmentSlot:GetStack()
            enchantmentProxies:OnEquippedHitByNpc(i, stack, player, npc)
        end
    end
end

function GPlayer:OnHitByProjectile(projectile)
    local player = self.player
    local enchantmentProxies = EnchantmentProxies.getInstance()
    for i = 0, 2 do
        local equipmentSlot = equipmentInventory:GetSlot(i)
        if equipmentSlot.hasStack then
            local stack = equipmentSlot:GetStack()
            enchantmentProxies:OnEquippedHitByProjectile(i, stack, player, projectile)
        end
    end
end

---GetInstance
---@param player Player
---@return TC.GPlayer
function GPlayer.GetInstance(player)
    return player:GetGlobalPlayer("tc:GPlayer")
end

function GPlayer:Save()
    return {
        accessoryInventory = self.accessoryInventory:Serialization(),
    }
end

function GPlayer:Load(tagTable)
    if tagTable.accessoryInventory ~= nil then
        Inventory.Deserialization(self.accessoryInventory, tagTable.accessoryInventory)
    end
end

function GPlayer:SaveCSC()
    local player = self.player
    local csc = {
        health = player.health,
        maxHealth = player.maxHealth,
        mana = player.mana,
        maxMana = player.maxMana,
        foodSaturationLevel = player.foodSaturationLevel,
        foodLevel = player.foodLevel,
        expLevel = player.expLevel,
        remainExp = player.remainExp,
        backpackInventory = player.backpackInventory:Serialization(),
        equipmentInventory = player.equipmentInventory:Serialization(),
        enderInventory = player.enderInventory:Serialization(),
        accessoryInventory = self.accessoryInventory:Serialization(),
    }

    --print("save csc:", csc)
    return csc
end

function GPlayer:LoadCSC(csc)
    --print("load csc:", csc)
    local player = self.player
    if csc.health ~= nil then
        player.health = csc.health
    end
    if csc.maxHealth ~= nil then
        player.maxHealth = csc.maxHealth
    end
    if csc.mana ~= nil then
        player.mana = csc.mana
    end
    if csc.maxMana ~= nil then
        player.maxMana = csc.maxMana
    end
    if csc.foodSaturationLevel ~= nil then
        player.foodSaturationLevel = csc.foodSaturationLevel
    end
    if csc.foodLevel ~= nil then
        player.foodLevel = csc.foodLevel
    end
    if csc.expLevel ~= nil then
        player.expLevel = csc.expLevel
    end
    if csc.remainExp ~= nil then
        player.remainExp = csc.remainExp
    end
    if csc.backpackInventory ~= nil then
        Inventory.Deserialization(player.backpackInventory, csc.backpackInventory)
    end
    if csc.equipmentInventory ~= nil then
        Inventory.Deserialization(player.equipmentInventory, csc.equipmentInventory)
    end
    if csc.enderInventory ~= nil then
        Inventory.Deserialization(player.enderInventory, csc.enderInventory)
    end
    if csc.accessoryInventory ~= nil then
        Inventory.Deserialization(self.accessoryInventory, csc.accessoryInventory)
    end

end

function GPlayer:OnInventoryChanged()
    --print("OnInventoryChanged")
end

function GPlayer:OnInventoryItemAdded(itemID, stackSize)
    --print("OnInventoryItemAdded", Reg.ItemIDName(itemID), stackSize)
    AdvancementTriggers.getInstance():TriggerGetItem(self.player, itemID, stackSize)

    if self.recipeBookHookUI ~= nil then
        self.recipeBookHookUI:RefreshDisplayState()
    end
end

function GPlayer:OnInventoryItemRemoved(itemID, stackSize)
    --print("OnInventoryItemRemoved", Reg.ItemIDName(itemID), stackSize)
end

function GPlayer:OnAdvancementMade(advancementID)
    --print("OnAdvancementMade", Reg.AdvancementIDName(advancementID))
    local HudUI = require("ui.hud.HudUI")
    HudUI.showAdvancementTip(advancementID)
end

function GPlayer:OnAdvancementRemoved(advancementID)
    --print("OnAdvancementRemoved", Reg.AdvancementIDName(advancementID))
end

function GPlayer:OnKilled()
    --print("player killed")

end

local s_advancement_hunter = Reg.AdvancementID("hunter")
local s_advancement_leather = Reg.AdvancementID("leather")

---OnKillNpc
---@param npc Npc
function GPlayer:OnKillNpc(npc)
    AdvancementTriggers.getInstance():TriggerKillNpc(self.player, npc)
    -- kill any npc
    if not self.player:IsAdvancementFinished(s_advancement_leather) then
        self.player:FinishAdvancement(s_advancement_leather)
    end
    -- kill enemy
    if not self.player:IsAdvancementFinished(s_advancement_hunter) then
        if not npc.friendly or npc.angry then
            self.player:FinishAdvancement(s_advancement_hunter)
        end
    end
end

function GPlayer:OnRespawn()
    --print("player respawn")
    local player = self.player
    player.health = 100
    if player.health > player.maxHealth then
        player.health = player.maxHealth
    end
    player.mana = 0
    player.foodLevel = 100
    player.foodSaturationLevel = 100
    if not self:HasAccessory(Reg.ItemID("gold_talisman")) then
        player.expLevel = math.floor(player.expLevel * 0.8)
    else
        player.expLevel = math.floor(player.expLevel * 0.9)
    end
    player.remainExp = 0
end

return GPlayer