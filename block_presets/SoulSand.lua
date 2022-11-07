---@class TC.SoulSand:ModBlock
local SoulSand = class("SoulSand", ModBlock)

function SoulSand.OnPlayerCollide(xi, yi, player, collisionDirection)
    if player.speedRate > 0.5 then
        player.speedRate = player.speedRate * 0.75
        if player.speedRate < 0.5 then
            player.speedRate = 0.5
        end
    end
end

return SoulSand