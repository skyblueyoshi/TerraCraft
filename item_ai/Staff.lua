---@class TC.Staff:TC.BaseRangedWeapon
local Staff = class("Staff", require("BaseRangedWeapon"))
local GPlayer = require("player.GPlayer")

local BoneAction = {
    StaffShooting = 5,
}

function Staff:OnHeld(player)
    local globalPlayer = GPlayer.GetInstance(player)
    if globalPlayer.currentAction == BoneAction.StaffShooting or
            globalPlayer.lastTickAction == BoneAction.StaffShooting then
        return
    end
    local body = globalPlayer.bone.joints:getJoint("base.body")
    local backArm = body:getChild("back_arm")
    local backHand = backArm:getChild("back_hand")

    backArm.angle = -math.pi * 0.4
    backHand.angle = 0

    globalPlayer.bone:update(false)
end

function Staff:OnSolveUsingAnimation(player)
    local globalPlayer = GPlayer.GetInstance(player)
    local itemJoint = globalPlayer:GetHeldItemJoint()
    itemJoint.angle = math.pi
end

function Staff:DrawIcon(position, color, spriteExData)
    self:_DrawIconRotated(position, color, spriteExData)
end

return Staff