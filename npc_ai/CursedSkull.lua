---@class TC.CursedSkull:ModNpc
local CursedSkull = class("CursedSkull", ModNpc)

local ST_READY = 0
local ST_DASH = 1

function CursedSkull:Init()
    self.facingAngle = 0
end

function CursedSkull:Update()
    local npc = self.npc
    local flyOnly = true
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 340 then
            flyOnly = false
            if npc.state == ST_READY then
                npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.1)
                npc.stateTimer = npc.stateTimer + 1
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                if npc.stateTimer >= 32 then
                    npc.speedX = npc.maxSpeed * math.cos(angle) * 2
                    npc.speedY = npc.maxSpeed * math.sin(angle) * 2
                    self.facingAngle = angle
                    npc.state = ST_DASH
                    npc.stateTimer = 0
                else
                    self.facingAngle = self.facingAngle + Utils.FixAngle(angle - self.facingAngle) * 0.1
                end
            elseif npc.state == ST_DASH then
                npc.maxSpeed = 3
                npc:Fly(true, 0.1, true)
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer >= 128 then
                    npc.state = ST_READY
                    npc.stateTimer = 0
                end
            end
        end
    end
    if flyOnly then
        npc.maxSpeed = 1.25
        if playerTarget ~= nil then
            self.facingAngle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
        else
            self.facingAngle = npc.speedAngle
        end
        npc.state = ST_READY
        npc.stateTimer = 0
        npc:Fly(true, 0.1, true)
    end
    if npc.speedX > 0 then
        npc.direction = true
    elseif npc.speedX < 0 then
        npc.direction = false
    end

    if npc.tickTime % 8 == 0 then
        EffectUtils.Create(Reg.EffectID("flame_star"), npc.randX, npc.randY, Utils.RandSym(1), Utils.RandSym(1), 0,
            Utils.RandDoubleArea(1, 1))
        EffectUtils.Create(Reg.EffectID("flame_star"), npc.randX, npc.randY, Utils.RandSym(1), -Utils.RandDouble(2), 0,
            Utils.RandDoubleArea(0.5, 0.5))
    end
end

function CursedSkull:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 3
end

return CursedSkull