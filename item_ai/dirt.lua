---@class TC.Dirt:ModItem
local Dirt = class("Dirt", ModItem)

function Dirt:Init()
    --print("hello dirt! you have", self.itemStack.stackSize)
end

function Dirt:DrawIcon(position, color, spriteExData)
    local item = self.itemStack:GetItem()
    local texture = item.iconTextureLocation
    local rectSource = TextureManager.getSourceRect(texture)
    spriteExData.originX = rectSource.width / 2
    spriteExData.originY = rectSource.height / 2
    Sprite.draw(texture, position, rectSource, color, spriteExData, 0)
end

function Dirt:OnHeld(player)
    --print("hhhhh", player.name)
end

return Dirt