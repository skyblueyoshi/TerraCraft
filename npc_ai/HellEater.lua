---@class TC.HellEater:ModNpc
local HellEater = class("HellEater", ModNpc)

local ST_READY = 0
local ST_DASH = 1

function HellEater:Init()
    self.dashTimes = 0
    self.dashAngle = 0
    self.DASH_ANGLE = self.npc.dataWatcher:AddDouble(0.0)
end

function HellEater:Update()
    self:RecvSync()
    local npc = self.npc
    local flyOnly = true
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 640 then
            flyOnly = false
            if npc.state == ST_READY then
                npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.1)
                npc.stateTimer = npc.stateTimer + 1
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                if npc.stateTimer >= 64 then
                    npc.speedX = npc.maxSpeed * math.cos(angle) * 2
                    npc.speedY = npc.maxSpeed * math.sin(angle) * 2
                    self.dashAngle = angle
                    npc.state = ST_DASH
                    npc.stateTimer = 0
                    self.dashTimes = self.dashTimes + 1
                else
                    self.dashAngle = self.dashAngle + Utils.FixAngle(angle - self.dashAngle) *
                                                 0.1
                end
            elseif npc.state == ST_DASH then
                -- self.dashAngle = self.speedAngle
                npc.stateTimer = npc.stateTimer + 1
                if self.dashTimes < 4 and npc.stateTimer >= 32 then
                    npc.state = ST_READY
                    npc.stateTimer = 0
                end
                if npc.tickTime % 2 == 0 then
                    EffectUtils.Create(Reg.EffectID("fire_flame"), npc.randX, npc.randY, Utils.RandSym(0.15), Utils.RandSym(0.15),
                        1, Utils.RandDoubleArea(0.5, 0.25), Utils.RandDoubleArea(0.75, 0.25))
                end
            end
        end
    end
    if flyOnly then
        self.dashAngle = npc.speedAngle
        npc.state = ST_READY
        npc.stateTimer = 0
        self.dashTimes = 0
        npc.maxSpeed = npc.maxSpeed * 4
        npc:Fly(false, 0.1, true)
    end
    self:SendSync()
end

function HellEater:OnTileCollide(oldSpeedX, oldSpeedY)
    local npc = self.npc
    npc:Kill()
    MiscUtils.CreateExplosion(npc.centerXi, npc.centerYi, 6, false, true, false)
    EffectUtils.CreateExplosion(npc.centerX, npc.centerY)
end

function HellEater:OnDraw()
    self.npc.spriteEx.angle = self.dashAngle
end

function HellEater:SendSync()
    if NetMode.current == NetMode.Server then
        self.npc.dataWatcher:UpdateDouble(self.DASH_ANGLE, self.dashAngle)
    end
end

function HellEater:RecvSync()
    if NetMode.current == NetMode.Client then
        self.dashAngle = self.npc.dataWatcher:GetDouble(self.DASH_ANGLE)
    end
end

return HellEater