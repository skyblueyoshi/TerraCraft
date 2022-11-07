---@class TC.CrisonEye:ModNpc
local CrisonEye = class("ManEater", ModNpc)

local ST_READY = 0
local ST_DASH = 1
local ST_TRANSFORM = 2
local ST_LEAVE = 3

local IDLE_TIME = 128
local MAD_IDLE_TIME = 64

local TRANSFORM_TIME = 100
local TRANSFORM_TIME_HALF = TRANSFORM_TIME / 2

local DISTANCE = 360
local MAD_DISTANCE = 500

local DASH_TIME = 48
local DASH_TIMES = 1
local DASH_SPEED_SCALE = 2.5

local MAD_DASH_TIME = 80
local MAD_DASH_TIMES = 2
local MAD_DASH_SPEED_SCALE = 2.7

function CrisonEye:Init()
    self.facingAngle = 0
    self:NotifyAllPlayer("crison_eye")

    self.isMad = false
    self.dashRemainTimes = 0
    self.IS_MAD = self.npc.dataWatcher:AddBool(self.isMad)
    self.DASH_REMAIN_TIMES = self.npc.dataWatcher:AddInteger(self.dashRemainTimes)
end

function CrisonEye:Update()
    self:RecvSync()
    local npc = self.npc

    if not MiscUtils.isNight then
        npc.state = ST_LEAVE
        npc.stateTimer = 0
        npc.speedX = 1
        npc.speedY = -7
        self.facingAngle = npc.speedAngle
    end

    if npc.state ~= ST_LEAVE then
        if not self.isMad and npc.health < npc.maxHealth * 0.4 then
            self.isMad = true
            npc.state = ST_TRANSFORM
            npc.stateTimer = 0
            self:MakeMonsterSound()
        end

        if npc.state == ST_TRANSFORM then
            npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.1)
            npc.stateTimer = npc.stateTimer + 1

            if npc.tickTime % 32 == 0 then
                local rid = Reg.NpcID("fly_mouth")
                NpcUtils.Create(rid, npc.centerX + 60, npc.centerY + 60)
            end

            self.facingAngle = self.facingAngle + 0.4 * (1.0 - math.abs(npc.stateTimer - TRANSFORM_TIME_HALF) / TRANSFORM_TIME_HALF)

            if npc.stateTimer >= TRANSFORM_TIME then
                npc.state = ST_READY
                npc.stateTimer = 0
            end
        else
            local flyFollowOnly = true
            local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
            if playerTarget ~= nil then
                local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
                local checkDistance = self.isMad and 320 or DISTANCE
                if distance < checkDistance then
                    flyFollowOnly = false
                    npc.maxSpeed = 3.2
                    if npc.state == ST_READY then
                        local force = 0.1
                        if self.isMad then
                            force = 0.2
                        end
                        npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, force)
                        npc.stateTimer = npc.stateTimer + 1
                        local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                        if not self.isMad and npc.stateTimer == 16 and Utils.RandTry(7) then
                            local rid = Reg.NpcID("fly_mouth")
                            NpcUtils.Create(rid,
                                    npc.centerX + 60 * math.cos(angle),
                                    npc.centerY + 60 * math.sin(angle),
                                    2 * math.cos(angle),
                                    2 * math.sin(angle)
                            )
                        end
                        local idleTime = self.isMad and 128 or IDLE_TIME
                        if npc.stateTimer >= idleTime then
                            local speedScale = self.isMad and MAD_DASH_SPEED_SCALE or DASH_SPEED_SCALE
                            npc.speedX = npc.maxSpeed * math.cos(angle) * speedScale
                            npc.speedY = npc.maxSpeed * math.sin(angle) * speedScale
                            self.facingAngle = angle
                            npc.state = ST_DASH
                            npc.stateTimer = 0
                            if self.isMad then
                                self:MakeMonsterSound()
                            end
                            self.dashRemainTimes = self.isMad and MAD_DASH_TIMES or DASH_TIMES
                            npc:SyncAll()
                        else
                            self.facingAngle = self.facingAngle + Utils.FixAngle(angle - self.facingAngle) * 0.1
                        end
                    elseif npc.state == ST_DASH then
                        npc.stateTimer = npc.stateTimer + 1
                        local dashTime = self.isMad and MAD_DASH_TIME or DASH_TIME
                        if npc.stateTimer >= dashTime then
                            self.dashRemainTimes = self.dashRemainTimes - 1
                            if self.dashRemainTimes <= 0 then
                                npc.state = ST_READY
                                npc.stateTimer = 0
                            else
                                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)

                                local speedScale = self.isMad and MAD_DASH_SPEED_SCALE or DASH_SPEED_SCALE
                                npc.speedX = npc.maxSpeed * math.cos(angle) * speedScale
                                npc.speedY = npc.maxSpeed * math.sin(angle) * speedScale
                                npc.state = ST_DASH
                                npc.stateTimer = 0
                                if self.isMad then
                                    self:MakeMonsterSound()
                                end
                            end
                            npc:SyncAll()
                        end
                        if self.isMad then
                            local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                            self.facingAngle = angle
                        end
                    end
                end
            end
            if flyFollowOnly then
                if playerTarget ~= nil then
                    self.facingAngle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                else
                    self.facingAngle = npc.speedAngle
                end
                self.dashRemainTimes = 0
                npc.state = ST_READY
                npc.stateTimer = npc.stateTimer + 1

                npc.maxSpeed = 4
                local force = 0.1
                if self.isMad then
                    npc.maxSpeed = 8
                    force = 0.4
                end
                npc:Fly(true, force, true)
            end
        end
    end

    self:SendSync()
    npc:SyncAll()
end

function CrisonEye:MakeMonsterSound()
    SoundUtils.PlaySound(Reg.SoundID("monster"), self.npc.centerXi, self.npc.centerYi)
end

function CrisonEye:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = self.facingAngle
end

function CrisonEye:OnRender()
    local npc = self.npc
    local GW, GH = 184, 112
    local rect = Rect.new(0, 0, GW, GH)
    if self.isMad then
        rect.y = rect.y + GH
    end
    local pos = Vector2.new(npc.centerX - MiscUtils.screenX, npc.centerY - MiscUtils.screenY)
    local spriteEx = SpriteExData.new()
    spriteEx.originX = GW / 2
    spriteEx.originY = GH / 2
    spriteEx.angle = self.facingAngle
    Sprite.draw(npc.texture, pos, rect, Color.White, spriteEx, 0.0)
end

function CrisonEye:OnKilled()
    self:NotifyAllPlayer("crison_eye_killed")
end

function CrisonEye:NotifyAllPlayer(advancementIDName)
    local advancementID = Reg.AdvancementID(advancementIDName)
    local players = PlayerUtils.SearchByCircle(self.npc.centerX, self.npc.centerY, 300 * 16)
    ---@param player Player
    for _, player in each(players) do
        player:FinishAdvancement(advancementID)
    end
end

function CrisonEye:SendSync()
    if NetMode.current == NetMode.Server then
        self.npc.dataWatcher:UpdateBool(self.IS_MAD, self.isMad)
        self.npc.dataWatcher:UpdateInteger(self.DASH_REMAIN_TIMES, self.dashRemainTimes)
    end
end

function CrisonEye:RecvSync()
    if NetMode.current == NetMode.Client then
        self.isMad = self.npc.dataWatcher:GetBool(self.IS_MAD)
        self.dashRemainTimes = self.npc.dataWatcher:GetInteger(self.DASH_REMAIN_TIMES)
    end
end

return CrisonEye