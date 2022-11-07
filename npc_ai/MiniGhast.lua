---@class TC.MiniGhast:ModNpc
local MiniGhast = class("MiniGhast", ModNpc)

local ST_NORMAL = 0
local ST_FIRING = 1

function MiniGhast:Update()
    local npc = self.npc
    npc:TryMakeSound(1000)
    npc:Fly(false)
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
        if npc.state == ST_NORMAL then
            npc.stateTimer = npc.stateTimer + 1
            if npc.stateTimer > 256 then
                npc.stateTimer = 0
                local shootX = 0
                local shootY = npc.centerY
                if npc.direction then
                    shootX = npc.rightX - 16
                else
                    shootX = npc.x + 16
                end
            end
        elseif npc.state == ST_FIRING then
            npc.stateTimer = npc.stateTimer + 1
            if npc.stateTimer > 32 then
                npc.stateTimer = 0
                npc.state = ST_NORMAL
            end
        end
    else
        npc.stateTimer = 0
        npc.state = ST_NORMAL
    end

    npc.color = Color.new(255, 255, 255, 180)
end

function MiniGhast:OnDraw()
    local npc = self.npc
    if npc.state == ST_FIRING then
        npc.spriteRect.x = npc.spriteDefaultWidth
    end
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 8
    end
end

function MiniGhast:OnHit()
    local npc = self.npc
    -- Let ghost gunners around shoot the players!
    local npcList = NpcUtils.SearchByCircle(npc.centerX, npc.centerY, 60 * 16)

    ---@param n Npc
    for _, n in each(npcList) do
        local modNpc = n:GetModNpc()
        if modNpc ~= nil and modNpc.isGhostGuard and modNpc.ghostAllowToShoot == false then
            SoundUtils.PlaySound(Reg.SoundID("ghast_charge"), n.centerXi, n.centerYi)
            modNpc.ghostAllowToShoot = true
            print("TRIGGER GHOST GUNNER")
        end
    end
end

return MiniGhast