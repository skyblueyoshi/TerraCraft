---@class TC.BaseTool:ModItem
local BaseTool = class("BaseTool", ModItem)

function BaseTool:_DrawIconRotated(position, color, spriteExData, rotateAngle)
    if rotateAngle == nil then
        rotateAngle = math.pi / 4
    end
    local item = self.itemStack:GetItem()
    local texture = item.iconTextureLocation
    local rectSource = TextureManager.getSourceRect(texture)
    spriteExData.angle = spriteExData.angle + rotateAngle
    spriteExData.originX = rectSource.width / 2
    spriteExData.originY = rectSource.height / 2

    local adaptWidth = rectSource.width > 32
    local adaptHeight = rectSource.height > 32

    if adaptWidth or adaptHeight then
        local maxRate = 1.0
        if adaptWidth then
            maxRate = math.max(maxRate, rectSource.width / 32.0)
        end
        if adaptHeight then
            maxRate = math.max(maxRate, rectSource.height / 32.0)
        end
        spriteExData.scaleRateX = spriteExData.scaleRateX / maxRate * 1.25
        spriteExData.scaleRateY = spriteExData.scaleRateY / maxRate * 1.25
    end

    Sprite.draw(texture, position, rectSource, color, spriteExData, 0)
end

return BaseTool