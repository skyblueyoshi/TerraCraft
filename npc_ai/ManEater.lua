---@type ModNpc
local ManEater = class("ManEater", ModNpc)

local ST_READY = 0
local ST_DASH = 1

function ManEater:Init()
    self.dashAngle = 0.0
    self.DASH_ANGLE = self.npc.dataWatcher:AddDouble(0.0)
end

function ManEater:Update()
    self:RecvSync()
    local npc = self.npc
    local flyOnly = true
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 440 then
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
                else
                    self.dashAngle = self.dashAngle + Utils.FixAngle(angle - self.dashAngle) * 0.1
                end
            elseif npc.state == ST_DASH then
                npc.stateTimer = npc.stateTimer + 1
                if npc.stateTimer >= 64 then
                    npc.state = ST_READY
                    npc.stateTimer = 0
                end
                if npc.tickTime % 4 == 0 then
                    EffectUtils.Create(
                            Reg.EffectID("liquid_paticular"),
                            npc.randX,
                            npc.randY,
                            Utils.RandSym(0.25),
                            Utils.RandSym(0.25),
                            1,
                            Utils.RandDoubleArea(1.0, 0.5),
                            Utils.RandDoubleArea(0.75, 0.25),
                            Color.new(255, 100, 100)
                    )
                end
            end
        end
    end
    if flyOnly then
        self.dashAngle = npc.speedAngle
        npc.state = ST_READY
        npc.stateTimer = 0
        npc:Fly(true, 0.1, true)
    end
    self:SendSync()
end

function ManEater:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = self.dashAngle
end

function ManEater:SendSync()
    if NetMode.current == NetMode.Server then
        self.npc.dataWatcher:UpdateDouble(self.DASH_ANGLE, self.dashAngle)
    end
end

function ManEater:RecvSync()
    if NetMode.current == NetMode.Client then
        self.dashAngle = self.npc.dataWatcher:GetDouble(self.DASH_ANGLE)
    end
end

return ManEater