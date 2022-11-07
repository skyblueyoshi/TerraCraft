---@class TC.Potion:TC.Food
local Potion = class("Potion", require("Food"))

function Potion:IsUseTex32()
    return true
end

function Potion:DrawIcon(position, color, spriteExData)
    local item = self.itemStack:GetItem()
    local texture = item.iconTextureLocation
    local rectSource = TextureManager.getSourceRect(texture)

    local width = rectSource.width
    local height = rectSource.height / 2

    spriteExData.originX = width / 2
    spriteExData.originY = height / 2

    local rectBase = Rect.new(0, 0, width, height)
    local rectLiquid = Rect.new(0, height, width, height)
    if item.iconColor2.alpha ~= 0 then
        Sprite.draw(texture, position, rectLiquid, item.iconColor2 * color, spriteExData, 0)
    end
    Sprite.draw(texture, position, rectBase, color, spriteExData, 0)
end

function Potion:PlayEatSound(player)
    SoundUtils.PlaySound(Reg.SoundID("drink"), player.centerXi, player.centerYi)
end

return Potion