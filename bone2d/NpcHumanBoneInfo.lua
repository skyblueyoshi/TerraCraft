---@class TC.NpcHumanBoneInfo
local NpcHumanBoneInfo = class("NpcHumanBoneInfo")
local NpcHumanJoints = require("NpcHumanJoints")
local NpcHumanJointsTall = require("NpcHumanJointsTall")
local NpcHumanClips = require("NpcHumanClips")
local NpcHumanAnimator = require("NpcHumanAnimator")
local ItemJointHelper = require("ItemJointHelper")

local s_instance
---@return TC.NpcHumanBoneInfo
function NpcHumanBoneInfo.getInstance()
    if s_instance == nil then
        s_instance = NpcHumanBoneInfo.new()
    end
    return s_instance
end

function NpcHumanBoneInfo:__init()
    self._pool = {} ---@type JointBody2D[]
end

---load
---@param npcID int
---@param texture TextureLocation
---@param sizeIndex int
---@return JointBody2D
function NpcHumanBoneInfo:load(npcID, texture, sizeIndex)
    if sizeIndex == nil then
        sizeIndex = 0
    end
    local last = self._pool[npcID]
    if last then
        return last:clone()
    end
    local joints
    if sizeIndex == 1 then
        joints = NpcHumanJointsTall.create(texture)
    else
        joints = NpcHumanJoints.create(texture)
    end
    local reserve = JointBody2D.new(joints)
    reserve:setAnimator(NpcHumanClips.create(reserve.joints), NpcHumanAnimator.create())
    self._pool[npcID] = reserve
    return reserve:clone()
end

---checkHandItem
---@param itemJoint Joint2D
---@param itemSlot Slot
---@param cacheTable table
function NpcHumanBoneInfo.checkHandItem(itemJoint, itemSlot, cacheTable)
    ItemJointHelper.checkItem(itemJoint, itemSlot, cacheTable)
end

---@param jointBody JointBody2D
---@param isBackHand boolean
function NpcHumanBoneInfo.getItemJoint(jointBody, isBackHand)
    return isBackHand and jointBody.joints:getJoint("base.body.back_arm.back_item")
            or jointBody.joints:getJoint("base.body.front_arm.front_item")
end

return NpcHumanBoneInfo