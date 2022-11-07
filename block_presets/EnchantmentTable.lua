---@class TC.EnchantmentTable:ModBlock
local EnchantmentTable = class("EnchantmentTable", ModBlock)
local GuiID = require("ui.GuiID")
local ModTextures = require("mod_textures.ModTextures")

function EnchantmentTable.OnClicked(xi, yi, parameterClick)
    local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        player:OpenGui(Mod.current, GuiID.Enchantment, xi, yi)
    end
end

function EnchantmentTable.UpdateScreen(xi, yi, tickTime)
    local checkTime = xi + yi + tickTime
    if checkTime % 32 == 0 then
        local effect = EffectUtils.Create(Reg.EffectID("heal"), xi * 16 + Utils.RandInt(16), yi * 16 - 48 + Utils.RandInt(16),
                Utils.RandSym(1), Utils.RandSym(1) - 0.5, Utils.RandSym(0.5), 1, 0.75)
        effect.color = Color.new(70, 70, 255)
    end

    if checkTime % 16 == 0 then

        local pickXi = Utils.RandIntArea(xi - 5, 12)
        local pickYi = Utils.RandIntArea(yi - 6, 7)
        local picked = false
        local frontID = MapUtils.GetFrontID(pickXi, pickYi)
        if frontID > 0 and (frontID == Reg.BlockID("book") or BlockUtils.GetSubGroupID(frontID) == Reg.BlockSubGroupID("BOOKCASE")) then
            picked = true
        end

        if picked then
            local effectX = pickXi * 16 + 8
            local effectY = pickYi * 16 + 8

            local cx = xi * 16 + 8
            local cy = yi * 16 - 32

            local effectAngle = Utils.GetAngle(effectX - cx, effectY - cy)

            local effectSpeed = 1
            local effectSpeedAngle = Utils.FixAngle(effectAngle + math.pi)
            local spx = math.cos(effectSpeedAngle) * effectSpeed
            local spy = math.sin(effectSpeedAngle) * effectSpeed

            local effect = EffectUtils.Create(
                    Reg.EffectID("heal"),
                    effectX,
                    effectY,
                    spx,
                    spy,
                    Utils.RandSym(0.25),
                    Utils.RandDoubleArea(0.5, 0.7),
                    1,
                    Color.new(70, 70, 255)
            )
            effect:SetDisappearTime(240)
        end
    end
end

function EnchantmentTable.PostRenderFurniture(xi, yi, tickTime)
    local sourceRect = Rect.new(0, 0, 32, 32)
    local ex = SpriteExData.new()
    ex.angle = Utils.CosValue(tickTime, 256, xi) * math.pi
    ex.origin = Vector2.new(16, 16)

    local drawX = (xi - 1) * 16 + 4 * Utils.SinValue(tickTime, 128, xi) + 24 - MiscUtils.screenX
    local drawY = (yi - 1) * 16 + 6 * Utils.CosValue(tickTime, 128, xi) - 24 - MiscUtils.screenY
    local pos = Vector2.new(drawX, drawY)

    Sprite.draw(ModTextures.getInstance():getTexture("fly_book"), pos, sourceRect, Color.White, ex, 0)
end

return EnchantmentTable