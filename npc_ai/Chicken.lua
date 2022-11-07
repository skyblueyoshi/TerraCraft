---@type ModNpc
local Chicken = class("Chicken", require("Animal"))

function Chicken:PostUpdate()
    local npc = self.npc
    if not npc.hurry then
        if npc.stand and npc.speedX == 0 and Utils.RandTry(2048) then
            -- lay eggs
            ItemUtils.CreateDrop(Reg.ItemID("egg"), 1, npc.centerX, npc.centerY)
            SoundUtils.PlaySound(Reg.SoundID("pop"), npc.centerXi, npc.centerYi)
        end
    end
    if npc.speedY > 3 then -- fall slowly
        npc.speedY = 3
    end
    if npc.stand and npc.speedX == 0 then
        npc.frameTickTime = 0
    end
end

function Chicken:OnDraw()
    local npc = self.npc
    if not npc.stand then
        npc.spriteRect.y = npc.spriteDefaultHeight
    end
end

return Chicken