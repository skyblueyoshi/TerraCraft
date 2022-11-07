---@class TC.DungeonEater:TC.BaseSnake
local DungeonEater = class("DungeonEater", require("BaseSnake"))
local PhysicsUtil = require("util.PhysicsUtil")

function DungeonEater:Init()
    DungeonEater.super.Init(self)

    self:SetSnakeData(12, Reg.NpcID("dungeon_eater_body"), Reg.NpcID("dungeon_eater_tail"),
            48, 34, 48, Size.new(44, 36), Size.new(54, 40)
    )
    self.npc.isAntiLava = true
    self.hungerTick = 0
    self:NotifyAllPlayer("dungeon_eater")
end

function DungeonEater:Update()
    local npc = self.npc
    if NetMode.current == NetMode.Server then
        local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
        local isMad = self.hungerTick > 128
        local force = 0.15
        local maxSpeed = 4
        if isMad then
            force = 0.10
            maxSpeed = 5
        end

        if self.hungerTick > 1500 then
            npc.speedY = math.min(4, npc.speedY + 0.3)
        else
            if playerTarget ~= nil then
                npc.speedX, npc.speedY = PhysicsUtil.SightChaseSpeed2D(npc.speedX, npc.speedY, force,
                        Utils.GetAngle(playerTarget.centerX - npc.centerX, playerTarget.centerY - npc.centerY),
                        maxSpeed)
                npc.speedX = npc.speedX + Utils.RandSym(0.5)
                npc.speedY = npc.speedY + Utils.RandSym(0.5)
            end
        end

        if isMad then
            if playerTarget ~= nil then
                local iv = 64
                if self.hungerTick < 400 then
                    iv = 64
                elseif self.hungerTick < 700 then
                    iv = 32
                end
                if npc.tickTime > 0 and npc.tickTime % iv == 0 then
                    local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                    local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("ice_bullet"),
                            npc.centerX, npc.centerY, 7 * math.cos(angle), 7 * math.sin(angle), npc.baseAttack)

                    proj.isCheckPlayer = true
                    SoundUtils.PlaySound(Reg.SoundID("fireball"), npc.centerXi, npc.centerYi)
                end
            end
        end

        if npc.tickTime % 8 == 0 then
            local eat = DungeonEater.DoEatDungeonBlocks(npc)
            if eat then
                self.hungerTick = 0
            end
        end
        self.hungerTick = self.hungerTick + 1

    end
    LightingUtils.Add(npc.centerXi, npc.centerYi, 26)
end

function DungeonEater:OnKilled()
    DungeonEater.super.OnKilled(self)

    self:NotifyAllPlayer("dungeon_eater_killed")
end

function DungeonEater:NotifyAllPlayer(advancementIDName)
    local advancementID = Reg.AdvancementID(advancementIDName)
    local players = PlayerUtils.SearchByCircle(self.npc.centerX, self.npc.centerY, 300 * 16)
    ---@param player Player
    for _, player in each(players) do
        player:FinishAdvancement(advancementID)
    end
end

local EATABLE_DUNGEON_BLOCKS = {
    [Reg.BlockID("more_dungeons:dungeon_brick_green")] = true,
}

function DungeonEater.DoEatDungeonBlocks(npc)
    local eat = false
    local cxi, cyi = npc.centerXi, npc.centerYi
    for i = -1, 1 do
        for j = -1, 1 do
            local xi, yi = cxi + i, cyi + j
            local ok = false

            local blockID = MapUtils.GetFrontID(xi, yi)
            if blockID > 0 and EATABLE_DUNGEON_BLOCKS[blockID] then
                local hasAttachBlock = false
                if (MapUtils.HasFront(xi, yi - 1) and not MapUtils.IsSolid(xi, yi - 1)) or
                        (MapUtils.HasFront(xi, yi + 1) and not MapUtils.IsSolid(xi, yi + 1)) then
                    hasAttachBlock = true
                end
                if not hasAttachBlock then
                    ok = MapUtils.RemoveFront(xi, yi, false, true)
                    if ok then
                        eat = true
                        if Utils.RandTry(16) then
                            local effect = EffectUtils.SendFromServer(Reg.EffectID("flame_star"),
                                    xi * 16 + 8, yi * 16 + 8,
                                    Utils.RandSym(1.0), Utils.RandSym(1.0),
                                    Utils.RandSym(1.0), Utils.RandDoubleArea(1, 2))
                            effect:SetDisappearTime(120)
                        end
                    end
                end
            end
        end
    end
    return eat
end

return DungeonEater