---@class TC.BallMagic:ModNpc
local BallMagic = class("BallMagic", ModNpc)

function BallMagic:Init()
    self.npc.noHurt = true
    self.npc.noCollisionByWeapon = true
end

function BallMagic:Update()
    local npc = self.npc

    ---@type Player
    local target = PlayerUtils.SearchNearestPlayer(npc.centerX, npc.centerY, 1000)
    if target ~= nil then
        if npc:GetDistance(target.centerX, target.centerY) < 128 then
            npc.speedX, npc.speedY = Utils.SlowSpeed2D(npc.speedX, npc.speedY, 0.2)
            npc.speedY = npc.speedY + math.sin(npc.tickTime / 8) / 4
            npc.speedX = npc.speedX + math.cos(npc.tickTime / 18) / 6
        else
            local targetAngle = npc:GetAngleTo(target.centerX, target.centerY)
            npc.speedX, npc.speedY = Utils.ForceSpeed2D(npc.speedX, npc.speedY, 0.2, targetAngle, npc.maxSpeed)
        end
        npc.direction = npc.centerX < target.centerX
    else
        npc.direction = npc.speedX > 0
    end

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
                Reg.EffectID("flash2"),
                effectX,
                effectY,
                spx,
                spy,
                Utils.RandSym(0.5),
                Utils.RandDoubleArea(1.25, 0.5),
                0.9,
                Color.new(colorChannel, colorChannel, colorChannel)
        )
    end

    local npcTarget = NpcUtils.SearchNearestEnemy(npc.centerX, npc.centerY, 300, true)
    if npcTarget ~= nil then
        local targetAngle = npc:GetAngleTo(npcTarget.centerX, npcTarget.centerY)

        if npc.tickTime % 16 == 0 then
            local rotCenterX = npc.centerX
            local rotCenterY = npc.centerY - 8
            local angle = targetAngle
            local shootX = rotCenterX + 24 * math.cos(angle) + Utils.RandSym(20)
            local shootY = rotCenterY + 24 * math.sin(angle) + Utils.RandSym(20)
            local speed = 12
            local attack = Attack.new(11, 1, 1)
            local proj = ProjectileUtils.CreateFromNpc(npc, Reg.ProjectileID("air_wave"),
                    shootX, shootY,
                    speed * math.cos(angle),
                    speed * math.sin(angle),
                    attack)
            proj.isCheckNpc = true
            SoundUtils.PlaySound(Reg.SoundID("bow"), npc.centerXi, npc.centerYi)
        end

    end

    LightingUtils.Add(npc.centerXi, npc.centerYi, 32)
end

function BallMagic:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.spriteEx.angle + 0.1
    end
end

return BallMagic