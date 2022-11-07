---@class TC.HumanFighter:TC.Fighter
local HumanFighter = class("HumanFighter", require("Fighter"))
local NpcHumanBoneInfo = require("bone2d.NpcHumanBoneInfo")
local cameraInGameInstance = require("client.CameraInGame").getInstance()

function HumanFighter:Init()
    local npc = self.npc
    if self.boneSizeIndex == nil then
        self.boneSizeIndex = 0
    end
    self.bone = NpcHumanBoneInfo.getInstance():load(npc.id, npc.texture, self.boneSizeIndex)
    self.itemSlotHeld = nil ---@type Slot
    self.isUsingItemForAnimation = false
    self.normalActionStyle = "NORMAL"

    self.isHeadLook = false
    self.headLookAngle = 0
    self.headLookDenominator = 1.0

    self.isBackHandLook = false
    self.backHandLookAngle = 0
    self.isBackHandLookAngleSameDirection = false

    self.isFrontHandLook = false
    self.frontHandLookAngle = 0
    self.isFrontHandLookAngleSameDirection = false

    self.isFrontLegOverwrite = false
    self.frontLegOverwriteAngle = 0
    self.isFrontLegLookAngleSameDirection = false

    self.isBackLegOverwrite = false
    self.backLegOverwriteAngle = 0
    self.isBackLegLookAngleSameDirection = false

    self.backItemCache = {}
end

function HumanFighter:PostUpdate()
    self:UpdateBone()
end

function HumanFighter:UpdateBone()
    local npc = self.npc
    self.bone.joints.position = Vector2.new(npc.centerX, npc.bottomY)

    if self.itemSlotHeld then
        NpcHumanBoneInfo.checkHandItem(self:GetHeldItemJoint(), self.itemSlotHeld, self.backItemCache)
    end

    local animator = self.bone.animator
    animator:setBool("OnGround", npc.stand)

    local speedRate = 0
    if npc.maxSpeed > 0 then
        speedRate = math.abs(npc.speedX) / npc.maxSpeed
    end
    speedRate = math.min(math.max(speedRate, 0), 1)
    animator:setFloat("Speed", speedRate)
    self.bone.joints.flip = not npc.direction

    self.bone.joints.scale = Vector2.new(1, 1)
    self.bone:update()

    self:UpdateSpecialAnimation()
end

function HumanFighter:UpdateSpecialAnimation()

    local hasJointChanged = false
    if self.isHeadLook and self.headLookDenominator > 0 then
        hasJointChanged = true
        local head = self.bone.joints:getJoint("base.body.head")
        head.angle = self:GetLookAngleInFacingDirection(self.headLookAngle) / self.headLookDenominator
    end
    if self.isBackHandLook then
        hasJointChanged = true
        local arm = self.bone.joints:getJoint("base.body.back_arm")
        if self.isBackHandLookAngleSameDirection then
            arm.angle = self.backHandLookAngle - math.pi * 0.5
        else
            arm.angle = self:GetLookAngleInFacingDirection(self.backHandLookAngle) - math.pi * 0.5
        end
    end
    if self.isFrontHandLook then
        hasJointChanged = true
        local arm = self.bone.joints:getJoint("base.body.front_arm")
        if self.isFrontHandLookAngleSameDirection then
            arm.angle = self.frontHandLookAngle - math.pi * 0.5
        else
            arm.angle = self:GetLookAngleInFacingDirection(self.frontHandLookAngle) - math.pi * 0.5
        end
    end
    if self.isFrontLegOverwrite then
        hasJointChanged = true
        local leg = self.bone.joints:getJoint("base.body.front_leg")
        if self.isFrontLegLookAngleSameDirection then
            leg.angle = self.frontLegOverwriteAngle
        else
            leg.angle = self:GetLookAngleInFacingDirection(self.frontLegOverwriteAngle)
        end
    end
    if self.isBackLegOverwrite then
        hasJointChanged = true
        local leg = self.bone.joints:getJoint("base.body.back_leg")
        if self.isBackLegLookAngleSameDirection then
            leg.angle = self.backLegOverwriteAngle
        else
            leg.angle = self:GetLookAngleInFacingDirection(self.backLegOverwriteAngle)
        end
    end
    if hasJointChanged then
        self.bone:update(false)
    end

    if self.isUsingItemForAnimation then
        self.isUsingItemForAnimation = false

        if self.itemSlotHeld and self.itemSlotHeld.hasStack then
            local stack = self.itemSlotHeld:GetStack()
            stack:RunOnUsedByNpcEvent(self.npc)
            local item = stack:GetItem()
            if item.useSoundGroupID > 0 then
                SoundUtils.PlaySoundGroup(item.useSoundGroupID, self.npc.centerXi, self.npc.centerYi)
            end
            if item.useSoundID > 0 then
                SoundUtils.PlaySound(item.useSoundID, self.npc.centerXi, self.npc.centerYi)
            end
        end
    end
end

function HumanFighter:GetLookAngleInFacingDirection(rawAngle)
    local lookAngle = rawAngle
    if not (lookAngle > -math.pi * 0.5 and lookAngle < math.pi * 0.5) then
        lookAngle = math.pi - lookAngle
        lookAngle = Utils.FixAngle(lookAngle)
    end
    return lookAngle
end

function HumanFighter:GetHeldItemJoint()
    return NpcHumanBoneInfo.getItemJoint(self.bone, true)
end

function HumanFighter:OnRender()
    self.bone.joints:render(cameraInGameInstance.camera)
end

function HumanFighter:DoExternArmsAnimation(amplitude, period)
    if amplitude == nil then
        amplitude = 0.25
    end
    if period == nil then
        period = 16
    end
    amplitude = math.max(amplitude, 0.0)
    period = math.max(period, 1)
    local npc = self.npc
    self.frontHandLookAngle = math.cos(npc.tickTime / period) * amplitude
    self.backHandLookAngle = math.sin(npc.tickTime / period) * amplitude
end

return HumanFighter