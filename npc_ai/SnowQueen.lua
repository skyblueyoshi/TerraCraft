---@class TC.SnowQueen:TC.HumanFighter
local SnowQueen = class("SnowQueen", require("HumanFighter"))

local ST_STAGE_START = 0
local ST_STAGE_MID = 1
local ST_STAGE_LAST = 2

function SnowQueen:Init()
    SnowQueen.super.Init(self)

    self.isFrontHandLook = true
    self.isBackHandLook = true
    self.isFrontLegOverwrite = true
    self.isBackLegOverwrite = true
    self.isFrontHandLookAngleSameDirection = false
    self.isBackHandLookAngleSameDirection = false
    self.isFrontLegLookAngleSameDirection = true
    self.isBackLegLookAngleSameDirection = true

    self.shootAngle = 0

    self:NotifyAllPlayer("snow_queen")
end

function SnowQueen:Update()
    local npc = self.npc
    -- get the target player
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
    end
    -- set the boss stage
    npc.state = ST_STAGE_START
    if npc.health < npc.maxHealth / 3 then
        npc.state = ST_STAGE_LAST
    elseif npc.health < npc.maxHealth / 3 * 2 then
        npc.state = ST_STAGE_MID
    end
    -- if else state machine
    if npc.state == ST_STAGE_START then
        npc:Fly()
        if npc.tickTime > 0 and npc.tickTime % 64 == 0 then
            if playerTarget ~= nil then
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("snow_flake"), npc.centerX + math.cos(angle) * 32,
                        npc.centerY + math.sin(angle) * 32, 0.5 * math.cos(angle), 0.5 * math.sin(angle),
                        npc.baseAttack)
                proj.isCheckPlayer = true
                SoundUtils.PlaySound(Reg.SoundID("fireball"), npc.centerXi, npc.centerYi)
            end
        end
    elseif npc.state == ST_STAGE_MID then
        npc:Fly()
        if npc.tickTime % 64 == 0 then
            if playerTarget ~= nil then
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                local initSpeed = 4
                for i = 1, 3 do
                    local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("ice_bullet"), npc.centerX + math.cos(angle) * 32,
                            npc.centerY + math.sin(angle) * 32, initSpeed * math.cos(angle),
                            initSpeed * math.sin(angle), npc.baseAttack)
                    proj.isCheckPlayer = true
                    initSpeed = initSpeed + 1
                end
                SoundUtils.PlaySound(Reg.SoundID("fireball"), npc.centerXi, npc.centerYi)
            end
        end
    elseif npc.state == ST_STAGE_LAST then
        npc:Fly(false)
        npc.speedY = npc.speedY - 0.01
        self.shootAngle = self.shootAngle + 0.1
        if npc.tickTime % 4 == 0 then
            if playerTarget ~= nil then
                local angle = self.shootAngle
                local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("ice_bullet"), npc.centerX + math.cos(angle) * 32,
                        npc.centerY + math.sin(angle) * 32, 4 * math.cos(angle), 4 * math.sin(angle),
                        npc.baseAttack)
                proj.isCheckPlayer = true
                if npc.tickTime % 16 == 0 then
                    SoundUtils.PlaySound(Reg.SoundID("fireball2"), npc.centerXi, npc.centerYi)
                end
            end
        end
    end

    if npc.stand then
        npc.speedY = -6
    end

    if npc.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("liquid_paticular"), npc.randX, npc.bottomY, Utils.RandSym(0.2), 1)
    end

    self.frontLegOverwriteAngle = -Utils.SinValue(npc.frameTickTime, 128) * 0.3 - math.pi / 6 + 0.1
    self.backLegOverwriteAngle = -Utils.CosValue(npc.frameTickTime, 128) * 0.3 - math.pi / 4 + 0.1
    self.frontHandLookAngle = -Utils.SinValue(npc.frameTickTime, 256) * 0.8 - math.pi / 12 + 2.2
    self.backHandLookAngle = -Utils.CosValue(npc.frameTickTime, 256) * 0.4 - math.pi / 8 + 1.8

end

function SnowQueen:OnKilled()
    self:NotifyAllPlayer("snow_queen_killed")
    if self.hookXi ~= nil and self.hookYi ~= nil then
        for i = 1, 12 do
            local effect = EffectUtils.SendFromServer(Reg.EffectID("chip"),
                    self.hookXi * 16 + 8,
                    self.hookYi * 16 + 8,
                    Utils.RandSym(5),
                    Utils.RandSym(5),
                    0,
                    Utils.RandDoubleArea(1, 1),
                    1.0,
                    Color.White
            )
            effect.disappearTime = 64
            effect.gravity = false
        end

        MapUtils.RemoveFront(self.hookXi, self.hookYi)
    end
end

function SnowQueen:NotifyAllPlayer(advancementIDName)
    local advancementID = Reg.AdvancementID(advancementIDName)
    local players = PlayerUtils.SearchByCircle(self.npc.centerX, self.npc.centerY, 300 * 16)
    ---@param player Player
    for _, player in each(players) do
        player:FinishAdvancement(advancementID)
    end
end

return SnowQueen