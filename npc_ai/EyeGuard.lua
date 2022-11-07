---@class TC.EyeGuard:ModNpc
local EyeGuard = class("EyeGuard", ModNpc)

function EyeGuard:Init()

end

function EyeGuard:Update()
    local npc = self.npc
    local playerTarget = PlayerUtils.Get(npc.playerTargetIndex)
    if playerTarget ~= nil then
        local distance = npc:GetDistance(playerTarget.centerX, playerTarget.centerY)
        if distance < 180 then
            npc:Fly(false)    -- random fly
        else
            npc:Fly()
        end
    else
        npc:Fly(false, 0.5)
    end

    LightingUtils.Add(npc.centerXi, npc.centerYi, 24, 12, 0, 0)
end

function EyeGuard:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 4
    else
        npc.spriteEx.angle = 0
    end
end

return EyeGuard