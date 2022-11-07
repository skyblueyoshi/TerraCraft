---@type ModProjectile
local Grenade = class("Grenade", require("Bomb"))

function Grenade:OnKilled()
    local projectile = self.projectile
    EffectUtils.CreateExplosion(projectile.centerX, projectile.centerY)
    MiscUtils.CreateExplosion(projectile.centerXi, projectile.centerYi, projectile.baseAttack.attack,
            true, false, -- hurt npc / player
            false, false, -- kill tiles / walls
            false) -- play explosion sound
    SoundUtils.PlaySound(Reg.SoundID("grenade_fire"), projectile.centerXi, projectile.centerYi)
end

return Grenade