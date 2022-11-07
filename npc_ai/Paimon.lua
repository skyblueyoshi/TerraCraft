---@class TC.Paimon:ModNpc
local Paimon = class("Paimon", ModNpc)

function Paimon:Init()
    self.npc.noHurt = true
    self.npc.noCollisionByWeapon = true
end

function Paimon:Update()
    local npc = self.npc

    ---@type Player
    local target = PlayerUtils.SearchNearestPlayer(npc.centerX, npc.centerY, 1000)
    if target ~= nil then
        if npc:GetDistance(target.centerX, target.centerY) < 128 then
            npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.2)
            npc.speedY =  npc.speedY + math.sin(npc.tickTime / 8) / 4
            npc.speedX =  npc.speedX + math.cos(npc.tickTime / 18) / 6
        else
            local targetAngle = npc:GetAngleTo(target.centerX, target.centerY)
            npc.speedX, npc.speedY = Utils.ForceSpeed2D(npc.speedX, npc.speedY, 0.2, targetAngle, npc.maxSpeed)
        end
        npc.direction = npc.centerX < target.centerX
    else
        npc.direction = npc.speedX > 0
    end


end

function Paimon:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 4
    end
end

return Paimon