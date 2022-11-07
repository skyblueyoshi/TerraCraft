---@class TC.LargeBat:ModNpc
local LargeBat = class("LargeBat", ModNpc)

function LargeBat:Update()
    local npc = self.npc

    if npc.state == 0 then
        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 64 then
            npc.stateTimer = 0
            npc.state = 1
        end
        npc:Fly()
    elseif npc.state == 1 then

        npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.35)

        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 64 then
            npc.stateTimer = 0
            npc.state = 0

            local ba = Utils.RandDouble(math.pi / 2)
            for i = 0, 3 do
                local angle = math.pi * 2 / 3 * i + ba
                local proj = ProjectileUtils.CreateFromNpc(npc,
                        Reg.ProjectileID("lighting_bullet_blue"),
                        npc.centerX, npc.centerY,
                        3 * math.cos(angle), 3 * math.sin(angle), npc.baseAttack)
                proj.isCheckPlayer = true
            end
        end
    end

    local effect = EffectUtils.Create(Reg.EffectID("chip"),
            self.npc.randX, self.npc.bottomY + Utils.RandSym(12),
            Utils.RandSym(0.1), Utils.RandDoubleArea(1, 1),
            Utils.RandSym(1), 1.0, 0.8,
            Color.new(200, 200, 200))
    effect:SetDisappearTime(30)

    LightingUtils.Add(npc.centerXi, npc.centerYi, 32)
end

function LargeBat:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
    else
        npc.spriteEx.angle = 0
    end
end

return LargeBat