---@type ModNpc
local Ghast = class("Ghast", ModNpc)

local ST_NORMAL = 0
local ST_FIRING = 1

function Ghast:Update()
    local npc = self.npc
    npc:TryMakeSound()
    npc:Fly(false)
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
        if npc.state == ST_NORMAL then
            npc.stateTimer = npc.stateTimer + 1
            if npc.stateTimer > 256 then
                npc.stateTimer = 0
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                local shootX = 0
                local shootY = npc.centerY
                if npc.direction then
                    shootX = npc.rightX - 16
                else
                    shootX = npc.x + 16
                end
                local shootXi = Utils.Cell(shootX)
                local shootYi = Utils.Cell(shootY)
                if not MapUtils.IsSolid(shootXi, shootYi) then
                    local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("fire_charge"), shootX, shootY, 4 * math.cos(angle),
                                     4 * math.sin(angle), npc.baseAttack)
                    if proj.modData:DataOf("Fireball") then
                        proj.isCheckPlayer = true
                        proj.modData.boom = true -- explosion when hit
                    end
                    SoundUtils.PlaySound(Reg.SoundID("ghast_charge"), npc.centerXi, npc.centerYi)
                    npc.state = ST_FIRING
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
end

function Ghast:OnDraw()
    local npc = self.npc
    if npc.state == ST_FIRING then
        npc.spriteRect.x = npc.spriteDefaultWidth
    end
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 8
    end
end

return Ghast