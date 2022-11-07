---@class TC.Cobweb:ModBlock
local Cobweb = class("Cobweb", ModBlock)

function Cobweb.OnPlayerOverlap(xi, yi, player)
	if player.speedX > 0.25 then
		player:SetSpeedX(0.25)
	elseif player.speedX < -0.25 then
		player:SetSpeedX(0.25)
	end
	if player.speedY > 0.25 then
		player:SetSpeedY(0.25)
	elseif player.speedY < -0.25 then
		player:SetSpeedY(0.25)
	end
	if Utils.RandTry(32) then
		MapUtils.RemoveFrontAndDrop(xi, yi)
	end
end

return Cobweb