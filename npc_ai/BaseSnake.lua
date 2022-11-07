---@class TC.BaseSnake:ModNpc
local BaseSnake = class("BaseSnake", ModNpc)
local SnakeModel = require("util.SnakeModel")

-- TODO: 网络同步优化！不能每帧都同步坐标！！
function BaseSnake:Init()
    local npc = self.npc
    self.npc.netUpdate = false
    self._snakeModel = SnakeModel.new()
    self._npcIndices = {}

    npc.isWatchAngleForTarget = false
    npc.rotateAngle = 0
end

function BaseSnake:SetSnakeData(totalJointCount, bodyID, tailID, headDistance, bodyDistance, tailDistance, bodySize, tailSize)
    if NetMode.current ~= NetMode.Server then
        return
    end
    if totalJointCount < 2 then
        return
    end
    local npc = self.npc
    local cx, cy = npc.centerX, npc.centerY
    local lastDistance = headDistance
    local headRotateAngle = npc.rotateAngle
    local backAngle = Utils.FixAngle(headRotateAngle + math.pi)
    self._snakeModel:addHead(cx, cy, headRotateAngle, headDistance)
    for i = 2, totalJointCount do
        local id = bodyID
        local distance = bodyDistance
        local size = bodySize
        if i == totalJointCount then
            id = tailID
            distance = tailDistance
            size = tailSize
        end
        local d = (lastDistance + distance) * 0.5
        cx = cx + math.cos(backAngle) * d
        cy = cy + math.sin(backAngle) * d
        local nextNpc = NpcUtils.Create(id, cx - size.width / 2, cy - size.height / 2)
        nextNpc.rotateAngle = headRotateAngle
        lastDistance = distance
        local entityIndex = EntityIndex.new(nextNpc.entityIndex.entityID, nextNpc.entityIndex.uniqueID)
        table.insert(self._npcIndices, entityIndex)

        self._snakeModel:addBody(Utils.FixAngle(nextNpc.rotateAngle + math.pi), distance)

        local modNpc = nextNpc:GetModNpc()
        if modNpc ~= nil and modNpc.SetHeadOwner ~= nil then
            modNpc:SetHeadOwner(self.npc.entityIndex)
        end
    end
end

function BaseSnake:PostUpdate()
    if NetMode.current == NetMode.Server then
        local npc = self.npc
        --npc.gravity = 0.1
        --npc.speedY = npc.speedY + 0.05
        --npc.speedX = 1

        self._snakeModel:update(npc.centerX, npc.centerY, npc.speedX, npc.speedY, npc.rotateAngle)

        local cx, cy, angle = self._snakeModel:getRes(1)

        npc:SetCenterX(cx)
        npc:SetCenterY(cy)
        npc.rotateAngle = angle
        npc.watchAngle = npc.rotateAngle

        for i = 1, #self._npcIndices do
            local entityIndex = self._npcIndices[i]
            if NpcUtils.IsAlive(entityIndex) then
                local npcPart = NpcUtils.Get(entityIndex)
                cx, cy, angle = self._snakeModel:getRes(i + 1)

                npcPart:SetCenterX(cx)
                npcPart:SetCenterY(cy)
                npcPart.rotateAngle = angle
                npcPart.watchAngle = npcPart.rotateAngle
            end
        end

        npc.x = npc.x - npc.speedX
        npc.y = npc.y - npc.speedY
    end
end

function BaseSnake:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = npc.watchAngle + math.pi
end

function BaseSnake:OnKilled()
    for i = 1, #self._npcIndices do
        local entityIndex = self._npcIndices[i]
        if NpcUtils.IsAlive(entityIndex) then
            local npcPart = NpcUtils.Get(entityIndex)
            npcPart.noLooting = true
            npcPart:KillByStrike()
        end
    end
end

return BaseSnake