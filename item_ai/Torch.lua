---@class TC.Torch:ModItem
local Torch = class("Sword", ModItem)
local GPlayer = require("player.GPlayer")

local modTextureID = Reg.ModTextureID("torch_fire")
local modTexture = ModTextureUtils.GetData(modTextureID)
local modTextureLocation = modTexture.textureLocation

function Torch:GetFirePoint(player)
    local globalPlayer = GPlayer.GetInstance(player)
    local itemJoint = globalPlayer:GetHeldItemJoint()
    return itemJoint.transform.worldMatrix:transformVector2(self.itemStack:GetItem():GetFirePoint(0))
end

function Torch:OnHeld(player)
    local tp = self:GetFirePoint(player)
    local xi = Utils.Cell(tp.x)
    local yi = Utils.Cell(tp.y)

    local lightingAlpha, r, g, b = self:GetLightingValue()

    LightingUtils.AddDelay(xi, yi, 20, lightingAlpha, r, g, b)
    if player.tickTime % 16 == 0 then
        EffectUtils.Create(Reg.EffectID("fire_smoke"), tp.x, tp.y,
                Utils.RandSym(0.25), -0.85, Utils.RandSym(0.05),
                Utils.RandDoubleArea(0.95, 0.5), 0.8
        )
    end

end

function Torch:OnHeldRender(player)
    local tp = self:GetFirePoint(player)
    local style = math.floor(player.tickTime / 8) % 4
    local cutRect = Rect.new(style * 16, 0, 16, 16)
    local drawX = tp.x - 8 - MiscUtils.screenX
    local drawY = tp.y - 12 - MiscUtils.screenY
    Sprite.draw(modTextureLocation, Vector2.new(drawX, drawY), cutRect, Color.White)
end

function Torch:GetLightingValue()
    return 30, 0, 0, 0
end

return Torch