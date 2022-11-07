---@class TC.MagmaBlock:ModBlock
local MagmaBlock = class("MagmaBlock", ModBlock)

function MagmaBlock.OnPlayerCollide(xi, yi, player, collisionDirection)
	player:AddBuff(Reg.BuffID("fire"), 120)
end

return MagmaBlock