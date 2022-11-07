---@type ModNpc
local Cat = class("Cat", require("Animal"))

function Cat:OnDraw()
	local npc = self.npc
	if npc.frameTickTime > 0 then
		npc.spriteRect.x = npc.spriteRect.x + npc.spriteDefaultWidth
	end
end

return Cat