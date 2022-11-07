---@type ModNpc
local WasteGhost = class("WasteGhost", ModNpc)

function WasteGhost:Update()
    local npc = self.npc
    npc.gravity = npc.gravity * 0.2
    npc:Walk()
    if npc.tickTime % 16 == 0 then
        local cy = npc.y
        if npc.speedY < 0 then
            cy = npc.bottomY
        end
        EffectUtils.Create(
                Reg.EffectID("liquid_paticular"),
                npc.randX,
                cy,
                Utils.RandSym(0.5),
                0,
                0,
                Utils.RandDoubleArea(0.5, 0.5),
                0,
                Color.new(255, 200, 100)
        )
    end
end

function WasteGhost:OnTileCollide(_, _)
    local npc = self.npc
    if npc.stand then
        npc.speedY = -npc.jumpForce
    end
end

function WasteGhost:OnDraw()
    local npc = self.npc
    if npc.maxSpeed > 0 then
        npc.spriteEx.angle = npc.speedX / npc.maxSpeed / 2
    end
end

return WasteGhost