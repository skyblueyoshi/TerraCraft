---@class Boomerang:ModProjectile
local Boomerang = class("Boomerang", ModProjectile)
local GPlayer = require("player.GPlayer")

local STATE_NORMAL = 0
local STATE_FLYING_BACK = 1

function Boomerang:Update()
    local alive = false
    local proj = self.projectile
    local slot = self:TryGetHookSlot()

    if slot ~= nil then
        alive = true
    end

    if alive then
        if proj.state == STATE_NORMAL then
            if proj.tickTime > proj.targetTime then
                proj.state = STATE_FLYING_BACK
            end
        elseif proj.state == STATE_FLYING_BACK then
            local player = self:TryGetHookPlayer()
            if player then
                local backX = player.centerX
                local backY = player.centerY
                if Utils.GetDistance(proj.centerX - backX, proj.centerY - backY) < 32 then
                    proj:Kill()
                    return
                end
                proj.speedX, proj.speedY = Utils.ForceSpeed2D(
                        proj.speedX, proj.speedY, 0.5, Utils.GetAngle(backX - proj.centerX, backY - proj.centerY), 8)
            end
        end
    end
    proj.rotateAngle = proj.rotateAngle + 0.4

    if proj.special == 1 and proj.tickTime % 4 == 0 then
        EffectUtils.Create(Reg.EffectID("flame_star"),
                    proj.randX,
                    proj.randY,
                    Utils.RandSym(1),
                    Utils.RandSym(1),
                    0,
                    Utils.RandDoubleArea(1, 1)
            )
    end
end

function Boomerang:TryGetHookPlayer()
    if self.playerOwnerIndex ~= nil then
        if PlayerUtils.IsAlive(self.playerOwnerIndex) then
            local player = PlayerUtils.Get(self.playerOwnerIndex)
            return player
        end
    end
    return nil
end

function Boomerang:TryGetHookSlot()
    local player = self:TryGetHookPlayer()
    if player == nil then
        return
    end
    local gp = GPlayer.GetInstance(player)
    local slot = gp:GetHeldSlot()
    if slot.hasStack then
        local stack = slot:GetStack()
        local item = stack:GetItem()
        if item.projectileID == self.projectile.id then
            return slot
        end
    end
    return nil
end

function Boomerang:TryReleasePlayerHook()
    local player = self:TryGetHookPlayer()
    if player ~= nil then
        local gp = GPlayer.GetInstance(player)
        gp.throwingBoomerang = false
        gp.throwingBoomerangTime = 0
    end
end

function Boomerang:TryLossDurable()
    local slot = self:TryGetHookSlot()
    if slot == nil then
        return
    end
    slot:GetStack():LoseDurable(1)
    if slot:GetStack().durable == 0 then
        slot:DecrStackSize(1)
    end
end

function Boomerang:PostUpdate()

end

function Boomerang:OnKilled()
    self:TryReleasePlayerHook()
end

function Boomerang:DoFlyBack()
    local proj = self.projectile
    if proj.state == STATE_NORMAL then
        proj.speedX = -proj.speedX
        proj.speedY = -proj.speedY
        proj.state = STATE_FLYING_BACK
    end
end

---OnHitNpc
---@param npc Npc
function Boomerang:OnHitNpc(npc, _)
    self:TryLossDurable()
    self:DoFlyBack()
    if self.projectile.special == 1 then
        npc:AddBuff(Reg.BuffID("fire"), 180)
    end
end

---@param player Player
function Boomerang:OnHitPlayer(player, _)
    self:TryLossDurable()
    self:DoFlyBack()
end

function Boomerang:OnTileCollide(_, _)
    local proj = self.projectile
    if proj.state == STATE_NORMAL then
        self:DoFlyBack()
    else
        proj.speedX = -proj.speedX
        proj.speedY = -proj.speedY

    end
end

return Boomerang