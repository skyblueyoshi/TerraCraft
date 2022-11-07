---@class TC.Zombie:TC.SwordHumanFighter
local Zombie = class("Zombie", require("SwordHumanFighter"))

function Zombie:Init()
	Zombie.super.Init(self)
	if Utils.RandTry(20) then
    	self:SetHeldItemByIDName("stone_sword")
	end
end

function Zombie:Update()
	Zombie.super.Update(self)
	if not self:HasHeldSword() then
		self:DoExternArmsAnimation()
	end
end

return Zombie