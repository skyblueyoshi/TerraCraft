---@class TC.PlayerBoneInfo
local PlayerBoneInfo = class("PlayerJointBody")
local PlayerJoints = require("PlayerJoints")
local PlayerClips = require("PlayerClips")
local PlayerAnimator = require("PlayerAnimator")
local ItemJointHelper = require("ItemJointHelper")

local s_instance
---@return TC.PlayerBoneInfo
function PlayerBoneInfo.getInstance()
    if s_instance == nil then
        s_instance = PlayerBoneInfo.new()
    end
    return s_instance
end

function PlayerBoneInfo:__init()
    self.body = JointBody2D.new(PlayerJoints.create())
    self.body:setAnimator(PlayerClips.create(self.body.joints), PlayerAnimator.create())
end

function PlayerBoneInfo:reload()
    self.body = JointBody2D.new(PlayerJoints.create())
    self.body:setAnimator(PlayerClips.create(self.body.joints), PlayerAnimator.create())
end

---create
---@param skinTable table
---@return JointBody2D
function PlayerBoneInfo.create(skinTable)
    local body = PlayerBoneInfo.getInstance().body:clone()
    PlayerBoneInfo.setSkin(body, skinTable)
    return body
end

function PlayerBoneInfo.getSkinTableByID(skinID)
    local skin = SkinUtils.GetSkin(skinID)
    return {
        head = skin.headTexture,
        body = skin.bodyTexture,
        leg = skin.legTexture,
        cloth = skin.clothTexture,
        hair = skin.hairTexture,
        pant = skin.pantTexture,
    }
end

function PlayerBoneInfo.createBySkinID(skinID)
    return PlayerBoneInfo.create(PlayerBoneInfo.getSkinTableByID(skinID))
end

---setSkin
---@param jointBody JointBody2D
---@param skinTable table
function PlayerBoneInfo.setSkin(jointBody, skinTable)
    PlayerJoints.setSkin(jointBody.joints, skinTable)
end

function PlayerBoneInfo.setSkinByID(jointBody, skinID)
    PlayerBoneInfo.setSkin(jointBody, PlayerBoneInfo.getSkinTableByID(skinID))
end

---checkHandItem
---@param itemJoint Joint2D
---@param itemSlot Slot
---@param cacheTable table
function PlayerBoneInfo.checkHandItem(itemJoint, itemSlot, cacheTable)
    ItemJointHelper.checkItem(itemJoint, itemSlot, cacheTable)
end

---@param jointBody JointBody2D
---@param isBackHand boolean
function PlayerBoneInfo.getItemJoint(jointBody, isBackHand)
    return isBackHand and jointBody.joints:getJoint("base.body.back_arm.back_hand.back_item")
            or jointBody.joints:getJoint("base.body.front_arm.front_hand.front_item")
end

return PlayerBoneInfo