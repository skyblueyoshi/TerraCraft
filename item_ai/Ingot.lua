---@class TC.Ingot:ModItem
local Ingot = class("Ingot", ModItem)

function Ingot:IsUseTex32()
    return true
end

function Ingot:DrawIcon(position, color, spriteExData)
    local item = self.itemStack:GetItem()
    local texture = item.iconTextureLocation
    local rectSource = TextureManager.getSourceRect(texture)

    local width = rectSource.width
    local height = rectSource.height / 2

    spriteExData.originX = width / 2
    spriteExData.originY = height / 2

    local rectBase = Rect.new(0, 0, width, height)
    Sprite.draw(texture, position, rectBase, item.iconColor * color, spriteExData, 0)
    if item.iconColor2.alpha ~= 0 then
        local rectHighlight = Rect.new(0, height, width, height)
        Sprite.draw(texture, position, rectHighlight, item.iconColor2 * color, spriteExData, 0)
    end
end

return Ingot