---@class TC.CrystalMonster:ModNpc
local CrystalMonster = class("CrystalMonster", ModNpc)

function CrystalMonster:Update()
    local npc = self.npc

    if npc.state == 0 then
        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 128 then
            npc.stateTimer = 0
            npc.state = 1
        end
        npc:Fly()
    elseif npc.state == 1 then

        npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.55)

        if npc.tickTime % 2 == 0 then

            local effectAngle = Utils.RandSym(math.pi)
            local d = 128
            local effectX = npc.centerX + math.cos(effectAngle) * d
            local effectY = npc.centerY + math.sin(effectAngle) * d

            local effectSpeed = 6
            local effectSpeedAngle = Utils.FixAngle(effectAngle + math.pi)
            local spx = npc.speedX + math.cos(effectSpeedAngle) * effectSpeed
            local spy = npc.speedY + math.sin(effectSpeedAngle) * effectSpeed

            local colorChannel = Utils.RandIntArea(200, 50)

            EffectUtils.Create(
                    Reg.EffectID("circle"),
                    effectX,
                    effectY,
                    spx,
                    spy,
                    Utils.RandSym(0.5),
                    Utils.RandDoubleArea(0.25, 0.5),
                    0.7,
                    Color.new(colorChannel, colorChannel, colorChannel)
            )

            EffectUtils.Create(
                    Reg.EffectID("flash2"),
                    effectX,
                    effectY,
                    spx * 0.5,
                    spy * 0.5,
                    Utils.RandSym(0.5),
                    Utils.RandDoubleArea(0.25, 0.5),
                    0.9,
                    Color.new(colorChannel, colorChannel, colorChannel)
            )
        end

        npc.stateTimer = npc.stateTimer + 1
        if npc.stateTimer > 128 then
            npc.stateTimer = 0
            npc.state = 0

            for i = 0, 8 do
                local angle = math.pi * 2 / 8 * i
                local proj = ProjectileUtils.CreateFromNpc(npc,
                        Reg.ProjectileID("magic_wave"),
                        npc.centerX, npc.centerY,
                        3 * math.cos(angle), 3 * math.sin(angle), npc.baseAttack)
                proj.isCheckPlayer = true
            end

            SoundUtils.PlaySound(Reg.SoundID("wand1"), npc.centerXi, npc.centerYi)
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

function CrystalMonster:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
    else
        npc.spriteEx.angle = 0
    end
end

return CrystalMonster