---@class TC.HellDestroyer:TC.BaseSnake
local HellDestroyer = class("HellDestroyer", require("BaseSnake"))
local PhysicsUtil = require("util.PhysicsUtil")

function HellDestroyer:Init()
    HellDestroyer.super.Init(self)

    self:SetSnakeData(24, Reg.NpcID("worm_body"), Reg.NpcID("worm_tail"),
            72, 34, 48, Size.new(46, 52), Size.new(60, 64)
    )
    self.npc.isAntiLava = true
    self:NotifyAllPlayer("nether_destroyer")
end

function HellDestroyer:Update()
    local npc = self.npc
    if NetMode.current == NetMode.Server then
        local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
        if playerTarget ~= nil then
            npc.speedX, npc.speedY = PhysicsUtil.SightChaseSpeed2D(npc.speedX, npc.speedY, 0.2,
                    Utils.GetAngle(playerTarget.centerX - npc.centerX, playerTarget.centerY - npc.centerY),
                    8)
            npc.speedX = npc.speedX + Utils.RandSym(0.5)
            npc.speedY = npc.speedY + Utils.RandSym(0.5)
        end

        local makeShoot = false
        if npc.tickTime > 0 then
            if npc.health > npc.maxHealth / 3 then
                makeShoot = npc.tickTime % 512 == 0
            else
                makeShoot = npc.tickTime % 256 == 0
            end
        end
        if makeShoot then
            local cxi, cyi = npc.centerXi, npc.centerYi
            if not MapUtils.IsSolid(cxi, cyi) then
                NpcUtils.Create(Reg.NpcID("small_hell_eater"), npc.centerX, npc.centerY,
                        Utils.RandSym(2), Utils.RandSym(2))
                SoundUtils.PlaySound(Reg.SoundID("fireball"), cxi, cyi)
            end
        end

        makeShoot = false
        if npc.tickTime > 0 then
            if npc.health > npc.maxHealth / 2 then
                makeShoot = (npc.tickTime + 64) % 1024 == 0
            else
                makeShoot = (npc.tickTime + 64) % 512 == 0
            end
        end
        if makeShoot then
            local cxi, cyi = npc.centerXi, npc.centerYi
            NpcUtils.Create(Reg.NpcID("small_fire_hell_eater"), npc.centerX, npc.centerY,
                    Utils.RandSym(2), Utils.RandSym(2))
            SoundUtils.PlaySound(Reg.SoundID("fireball"), cxi, cyi)
        end
    end
end

function HellDestroyer:OnKilled()
    HellDestroyer.super.OnKilled(self)

    self:NotifyAllPlayer("nether_destroyer_killed")
end

function HellDestroyer:NotifyAllPlayer(advancementIDName)
    local advancementID = Reg.AdvancementID(advancementIDName)
    local players = PlayerUtils.SearchByCircle(self.npc.centerX, self.npc.centerY, 300 * 16)
    ---@param player Player
    for _, player in each(players) do
        player:FinishAdvancement(advancementID)
    end
end

return HellDestroyer