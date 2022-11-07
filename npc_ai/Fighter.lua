---@class TC.Fighter:ModNpc
local Fighter = class("Fighter", ModNpc)

function Fighter:Update()
	self.npc:TryMakeSound()
	self.npc:Walk()
end

return Fighter