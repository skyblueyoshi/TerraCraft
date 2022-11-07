---@type ModNpc
local Guardian = class("Guardian", ModNpc)

local ST_NORMAL = 0
local ST_ANGRY = 1
local ST_SHOOTING = 2

function Guardian:Update()
    local npc = self.npc
    npc:Swim()
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 360 then
            if npc.state == ST_NORMAL then
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer > 16 then
                    npc.stateTimer = 0
                    npc.state = ST_ANGRY
                end
            elseif npc.state == ST_ANGRY then
                npc.direction = (playerTarget.centerX > npc.centerX)
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer > 64 then
                    npc.stateTimer = 0
                    npc.state = ST_SHOOTING
                end
            elseif npc.state == ST_SHOOTING then
                npc.direction = (playerTarget.centerX > npc.centerX)
                local shootAngle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                if npc.tickTime % 16 == 0 then
                    local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("bullet_laser"), npc.centerX, npc.centerY,
                                     9 * math.cos(shootAngle), 9 * math.sin(shootAngle), npc.baseAttack)
                    proj.isCheckPlayer = true
                    SoundUtils.PlaySound(Reg.SoundID("rifle_fire"), npc.centerXi, npc.centerYi)
                end
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer > 100 then
                    npc.stateTimer = 0
                    npc.state = ST_NORMAL
                end
            end
        else
            npc.stateTimer = 0
            npc.state = ST_NORMAL
        end
    else
        npc.stateTimer = 0
        npc.state = ST_NORMAL
    end
end

function Guardian:OnDraw()
    local npc = self.npc
    npc.spriteOffsetX = 0
    npc.spriteOffsetY = 0
    if npc.state == ST_ANGRY then
        local rate = Utils.SinValue(npc.tickTime, 16)
        local scaleRate = 1.05 + rate * 0.05
        npc.spriteEx.scaleRateX = scaleRate
        npc.spriteEx.scaleRateY = scaleRate
        npc.spriteOffsetX = -(scaleRate - 1) * npc.spriteDefaultWidth / 2
        npc.spriteOffsetY = -(scaleRate - 1) * npc.spriteDefaultHeight / 2
    end
end

return Guardian