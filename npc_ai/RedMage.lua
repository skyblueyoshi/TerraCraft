---@class TC.RedMage:ModNpc
local RedMage = class("RedMage", ModNpc)

local ST_NORMAL = 0
local ST_FIRING = 1
local SHOOT_TIMES = 3

function RedMage:Init()
    self.shootTimes = 0
end

function RedMage:Update()
    local npc = self.npc
    npc.speedX = Utils.SlowSpeed1D(npc.speedX, 0.1)
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        npc.direction = (playerTarget.centerX > npc.centerX)
    end
    if npc.state == ST_NORMAL then
        npc.stateTimer = npc.stateTimer + 1
        if self.shootTimes < SHOOT_TIMES and npc.stateTimer > 64 then
            npc.stateTimer = 0
            npc.state = ST_FIRING
            self.shootTimes = self.shootTimes + 1
            if playerTarget ~= nil then
                local angle = npc:GetAngleTo(playerTarget.centerX, playerTarget.centerY)
                local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("shulker_bullet"), npc.centerX, npc.centerY,
                        2 * math.cos(angle), 2 * math.sin(angle), npc.baseAttack)
                proj.isCheckPlayer = true
                SoundUtils.PlaySound(Reg.SoundID("fireball"), npc.centerXi, npc.centerYi)
            end
        end
        if npc.speedY > 6 or (self.shootTimes >= SHOOT_TIMES and npc.stateTimer > 64) then
            npc.state = 0
            self.shootTimes = 0
            npc.stateTimer = 0
            local currentX = npc.x
            local currentY = npc.y
            local teleportSuccess = npc:RandomTeleport(32)
            if teleportSuccess then
                local e_ender_flash = Reg.EffectID("ender_flash")
                for i = 1, 16 do
                    EffectUtils.Create(e_ender_flash, currentX + Utils.RandInt(npc.width),
                            currentY + Utils.RandInt(npc.height), Utils.RandSym(1), Utils.RandSym(1), Utils.RandSym(1), 2)
                end
                for i = 1, 16 do
                    EffectUtils.Create(e_ender_flash, npc.randX, npc.randY, Utils.RandSym(1), Utils.RandSym(1),
                            Utils.RandSym(1), 2)
                end
                SoundUtils.PlaySoundGroup(Reg.SoundGroupID("portal"), npc.centerXi, npc.centerYi)
            end
        end
    elseif npc.state == ST_FIRING then
        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 16 then
            npc.stateTimer = 0
            npc.state = ST_NORMAL
        end
    end
end

function RedMage:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = npc.speedX / 8
    if npc.state == ST_NORMAL then
        npc.spriteRect.x = 0
    elseif npc.state == ST_FIRING then
        npc.spriteRect.x = npc.spriteDefaultWidth
    end
end

return RedMage