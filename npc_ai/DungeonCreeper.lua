---@class TC.DungeonCreeper:TC.Creeper
local DungeonCreeper = class("DungeonCreeper", require("Creeper"))

function DungeonCreeper:Init()
    DungeonCreeper.super.Init(self)
    self.boomPower = 8
    --self.boomHurtNpc = true
    --self.boomHurtPlayer = true
    self.boomKillTile = false
    self.boomKillWall = false
end

function DungeonCreeper:OnCreateBoomEffect(centerX, centerY)
    EffectUtils.CreateExplosion(centerX, centerY)
    local npc = self.npc
    local cnt = 16
    for i = 0, cnt do
        local angle = math.pi * 2 / cnt * i
        local proj = ProjectileUtils.CreateFromNpc(npc,
                Reg.ProjectileID("lighting_arrow"),
                npc.centerX, npc.centerY,
                8 * math.cos(angle), 8 * math.sin(angle), npc.baseAttack)
        proj.isCheckPlayer = true
    end
end

return DungeonCreeper