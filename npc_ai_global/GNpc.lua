---@type GlobalNpc
local GNpc = class("GNpc", GlobalNpc)

function GNpc.CheckCreateInstance(npc)
    return true
end

function GNpc:CanUpdate()
    return true
end

function GNpc:Update()
    if self.npc.stand then
        --self.npc.speedY = -5
    end
end

return GNpc