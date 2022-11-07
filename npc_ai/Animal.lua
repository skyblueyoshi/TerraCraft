---@class TC.Animal:ModNpc
local Animal = class("Animal", ModNpc)

function Animal:Init()
    -- all animal can save to file
    self.npc.isAutoSave = true
end

function Animal:Update()
    local npc = self.npc
    if npc.hurry then
        if Utils.RandTry(256) then
            npc.hurry = false
        end
    end
    if npc.hurry then
        npc.maxSpeed = npc.maxSpeed * 2
    end
    npc:TryMakeSound()
    npc:RandomWalk()
end

function Animal:PostUpdate()
    if self.npc.speedX == 0 then
        self.npc.frameTickTime = 0
    end
end

function Animal:OnHit()
    self.npc.hurry = true
end

--function Animal:Save()
--    return {
--        say = "I'm an animal!",
--        value = 123
--    }
--end
--
--function Animal:Load(tagTable)
--    print(tagTable)
--end
--
--function Animal:OnLoot()
--    ItemUtils.CreateDrop(ItemStack.new(ItemRegistry.GetItemByIDName("diamond"), 2),
--            self.npc.centerX, self.npc.centerY, 0, -3)
--end

return Animal