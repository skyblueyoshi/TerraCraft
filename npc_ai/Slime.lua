---@class TC.Slime:ModNpc
local Slime = class("Slime", ModNpc)

local ST_NORMAL = 0
local ST_READY_TO_JUMP = 1

function Slime:Init()
    local npc = self.npc
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
    end
    self.jumpTryTimes = 0
    self.JUMP_TRY_TIMES = npc.dataWatcher:AddInteger(0)
end

function Slime:Update()
    self:RecvSync()
    local npc = self.npc
    local following = (npc.y > MapUtils.UNDERGROUND_LINE * 16)
    if npc.inLiquid then
        npc.gravity = 0
        if npc.stand then
            npc.speedY = -1
        elseif npc.speedY > -1 then
            npc.speedY = npc.speedY - npc.defaultGravity
        end
    end
    if not npc.stand then
        if npc.direction then
            npc.speedX = npc.speedX + 0.0625
        else
            npc.speedX = npc.speedX - 0.0625
        end
        npc.speedX = math.max(npc.speedX, -npc.maxSpeed)
        npc.speedX = math.min(npc.speedX, npc.maxSpeed)
    end
    if not npc.inLiquid and npc.stand then
        if following then
            local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
            if playerTarget ~= nil then
                npc.direction = (playerTarget.centerX > npc.centerX)
            end
        end
        npc.speedX = Utils.SlowSpeed1D(npc.speedX, 0.25)
        if npc.state == ST_NORMAL then
            if Utils.RandTry(32) then
                npc.state = ST_READY_TO_JUMP
            end
        elseif npc.state == ST_READY_TO_JUMP then
            npc.stateTimer = npc.stateTimer + 1
            if npc.stateTimer > 64 then
                npc.stateTimer = 0
                npc.state = ST_NORMAL
                if npc.direction then
                    npc.speedX = npc.maxSpeed
                else
                    npc.speedX = -(npc.maxSpeed)
                end
                npc.speedY = -Utils.RandDoubleArea(8, 2)
            end
        end
    end
    self:SendSync()
end

--- Called when NPC collides the tiles.
---@param oldSpeedX double Represents the X speed before colliding tiles.
---@param oldSpeedY double Represents the Y speed before colliding tiles.
function Slime:OnTileCollide(oldSpeedX, oldSpeedY)
    local npc = self.npc
    if npc.stand then
        if not npc.isCollisionLeft and not npc.isCollisionRight then
            self.jumpTryTimes = 0
        end
        if npc.isCollisionLeft and not npc.direction then
            if self.jumpTryTimes >= 1 then
                self.jumpTryTimes = 0
                npc.direction = true
            else
                npc.speedY = -npc.jumpForce
                self.jumpTryTimes = self.jumpTryTimes + 1
            end
        elseif npc.isCollisionRight and npc.direction then
            if self.jumpTryTimes >= 1 then
                self.jumpTryTimes = 0
                npc.direction = false
            else
                npc.speedY = -npc.jumpForce
                self.jumpTryTimes = self.jumpTryTimes + 1
            end
        end
    elseif npc.inLiquid then
        if npc.isCollisionLeft and not npc.direction then
            npc.direction = true
        elseif npc.isCollisionRight and npc.direction then
            npc.direction = false
        end
    end
    self:SendSync()
end

function Slime:SendSync()
    if NetMode.current == NetMode.Server then
        self.npc.dataWatcher:UpdateInteger(self.JUMP_TRY_TIMES, self.jumpTryTimes)
    end
end

function Slime:RecvSync()
    if NetMode.current == NetMode.Client then
        self.jumpTryTimes = self.npc.dataWatcher:GetInteger(self.JUMP_TRY_TIMES)
    end
end

function Slime:OnDraw()
    local npc = self.npc
    if not npc.stand then
        npc.spriteRect.x = npc.spriteDefaultWidth
    end
end

return Slime