---@type ModNpc
local MagmaElf = class("MagmaElf", ModNpc)

function MagmaElf:Update()
    local npc = self.npc
    npc:Walk()
    if npc.inLiquid then
        -- in lava
        npc.gravity = 0
        if npc.speedY > 0 then
            npc.speedY = math.min(npc.speedY + 0.1, npc.maxSpeed)
        else
            npc.speedY = math.max(npc.speedY - 0.1, -npc.maxSpeed)
        end
    elseif not npc.inLiquid and npc.oldInLiquid then
        -- just jump out of lava
        if npc.speedY > -npc.jumpForce * 1.5 then
            npc.speedY = -npc.jumpForce * 1.5
        end
    else
        -- in air
        npc.gravity = npc.gravity * 0.25
        if npc.tickTime % 16 == 0 then
            EffectUtils.Create(Reg.EffectID("fire_flame"), npc.randX, npc.randY, Utils.RandSym(0.25), Utils.RandSym(0.25), 0,
                Utils.RandDoubleArea(0.5, 0.5))
        end
    end
    LightingUtils.Add(npc.centerXi, npc.centerYi, 24, 12, 0, 0)
end

function MagmaElf:OnTileCollide(oldSpeedX, oldSpeedY)
    local npc = self.npc
    if npc.stand then
        npc.speedY = -npc.jumpForce
    end
end

function MagmaElf:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = npc.speedAngle
    npc.spriteEx.flipHorizontal = false
end

return MagmaElf