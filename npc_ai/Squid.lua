---@type ModNpc
local Squid = class("Squid", ModNpc)

function Squid:Update()
    local npc = self.npc
    if not npc.inLiquid then
        -- bounce in air
        if npc.stand then
            npc.speedY = -npc.jumpForce
            npc.speedX = Utils.RandSym(npc.maxSpeed)
        end
        if npc.isCollisionLeft then
            npc.direction = true
            npc.speedX = npc.maxSpeed * 0.5
        elseif npc.isCollisionRight then
            npc.direction = false
            npc.speedX = -npc.maxSpeed * 0.5
        end
    else
        -- in liquid
        npc.gravity = 0
        if npc.stateTimer == 0 then
            local rate = Utils.RandDouble(1)
            local PI = math.pi
            local angle = 0
            if npc.stand then
                if npc.isCollisionLeft then
                    angle = -rate * PI / 2
                elseif npc.isCollisionRight then
                    angle = -rate * PI / 2 - PI / 2
                else
                    angle = rate * PI - PI
                end
            elseif npc.isCollisionTop then
                if npc.isCollisionLeft then
                    angle = rate * PI / 2
                elseif npc.isCollisionRight then
                    angle = rate * PI / 2 + PI / 2
                else
                    angle = rate * PI
                end
            elseif npc.isCollisionLeft then
                angle = rate * PI - PI / 2
            elseif npc.isCollisionRight then
                angle = rate * PI + PI / 2
            else
                angle = rate * 2 * PI - PI
            end
            npc.rotateAngle = angle
            npc.speedX, npc.speedY = Utils.GetXYFromPolar(npc.maxSpeed, angle)
        end
        npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.03125)
        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 64 then
            npc.stateTimer = 0
        end
    end
    if npc.stateTimer == 0 then
        npc.frameTickTime = 0
    end
end

function Squid:OnDraw()
    self.npc.spriteEx.angle = self.npc.rotateAngle + math.pi / 2
end

return Squid