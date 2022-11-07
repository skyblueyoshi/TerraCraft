---@class TC.BaseSnakeBody:ModNpc
local BaseSnakeBody = class("BaseSnakeBody", ModNpc)

function BaseSnakeBody:Init()
    self.npc.netUpdate = false
    self.headOwnerNpcIndex = nil
    self.npc.isAntiLava = true
end

function BaseSnakeBody:Update()
    if self.npc.tickTime % 64 == 0 then
        if self.headOwnerNpcIndex ~= nil then
            if not NpcUtils.IsAlive(self.headOwnerNpcIndex) then
                self.npc:Kill()
            end
        end
    end
end

function BaseSnakeBody:SetHeadOwner(npcIndex)
    self.headOwnerNpcIndex = npcIndex
end

function BaseSnakeBody:OnDraw()
    local npc = self.npc
    npc.spriteEx.angle = npc.watchAngle + math.pi
end

function BaseSnakeBody:ModifyHit(attack)
    local headNpc = NpcUtils.Get(self.headOwnerNpcIndex)
    if headNpc ~= nil then
        attack.attack = attack.attack * 0.7
        headNpc:Strike(attack)
        return false
    end
    return true
end

return BaseSnakeBody