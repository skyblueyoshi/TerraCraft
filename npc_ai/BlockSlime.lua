---@class TC.BlockSlime:ModNpc
local BlockSlime = class("BlockSlime", ModNpc)

local State = {
    NORMAL = 0,
    READY_TO_JUMP = 1,
    FALLEN = 2,
}

function BlockSlime:Update()
    local npc = self.npc
    if not npc.stand then
        npc.state = State.FALLEN
        if npc.direction then
            npc.speedX = npc.speedX + 0.1
        else
            npc.speedX = npc.speedX - 0.1
        end
        npc.speedX = math.max(npc.speedX, -npc.maxSpeed)
        npc.speedX = math.min(npc.speedX, npc.maxSpeed)
    else
        local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
        if playerTarget ~= nil then
            npc.direction = (playerTarget.centerX > npc.centerX)
            npc.speedX = Utils.SlowSpeed1D(npc.speedX, 0.1)
            if npc.state == State.NORMAL then
                npc.stateTimer = npc.stateTimer + 1
                -- if Utils.RandTry(32) then
                if npc.stateTimer > 32 then
                    npc.stateTimer = 0
                    npc.state = State.READY_TO_JUMP
                end
            elseif npc.state == State.READY_TO_JUMP then
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer > 16 then
                    npc.stateTimer = 0
                    npc.state = State.FALLEN
                    if npc.direction then
                        npc.speedX = Utils.RandDoubleArea(npc.maxSpeed / 2, npc.maxSpeed / 2)
                    else
                        npc.speedX = -Utils.RandDoubleArea(npc.maxSpeed / 2, npc.maxSpeed / 2)
                    end
                    npc.speedY = -Utils.RandDoubleArea(8, 4)
                end
            elseif npc.state == State.FALLEN then
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer > 16 then
                    npc.stateTimer = 0
                    npc.state = State.NORMAL
                end
            end
        else
            npc.stateTimer = 0
            npc.state = State.NORMAL
        end
    end
end

function BlockSlime:OnDraw()
    local npc = self.npc
    npc.frameTickTime = 0
    if not npc.stand then
        npc.spriteRect.x = npc.spriteDefaultWidth * 2
    else
        if npc.state == State.NORMAL then
            npc.spriteRect.x = 0
        else
            npc.spriteRect.x = npc.spriteDefaultWidth
        end
    end
end

return BlockSlime