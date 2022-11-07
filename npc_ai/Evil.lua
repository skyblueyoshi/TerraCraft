---@class TC.Evil:ModNpc
local Evil = class("Evil", ModNpc)

function Evil:Update()
    local npc = self.npc
    npc:Fly()
    if npc.speedY >= 0 then
        local b1 = Utils.RandTry(8)
        local b2 = Utils.RandTry(8)
        if b1 or b2 then
            local angle = npc.speedX / npc.maxSpeed / 2
            local ex = 32 * math.cos(angle)
            local ey = 32 * math.sin(angle)
            if b1 then
                EffectUtils.Create(Reg.EffectID("ender_flash"), npc.centerX + ex, npc.centerY + ey, Utils.RandSym(0.25),
                    Utils.RandSym(0.25), 0, Utils.RandDoubleArea(1, 1))
            end
            if b2 then
                EffectUtils.Create(Reg.EffectID("ender_flash"), npc.centerX - ex, npc.centerY - ey, Utils.RandSym(0.25),
                    Utils.RandSym(0.25), 0, Utils.RandDoubleArea(1, 1))
            end
        end
    else
        if Utils.RandTry(4) then
            EffectUtils.Create(Reg.EffectID("ender_flash"), npc.centerX + Utils.RandSym(8), npc.centerY + 8, Utils.RandSym(1),
                Utils.RandSym(1), 0, Utils.RandDoubleArea(1, 1))
        end
    end
end

function Evil:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
    end
    local noChangeFrame = false
    --if npc.speedY >= 0 then
    --    if npc.frameTickTime <= 1 then
    --        noChangeFrame = true
    --    end
    --end
    if npc.frameTickTime > npc.frames * npc.frameSpeed then
        noChangeFrame = true
    end
    if noChangeFrame then
        npc.frameTickTime = 0
    end
end

return Evil