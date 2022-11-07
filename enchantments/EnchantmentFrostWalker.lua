---@class TC.EnchantmentFrostWalker:TC.BaseEnchantmentProxy
local EnchantmentFrostWalker = class("EnchantmentFrostWalker")

function EnchantmentFrostWalker.OnHeld(level, player, _)

    local waterID = Reg.LiquidID("water")

    local xi1 = Utils.Cell(player.x) - 2
    local xi2 = Utils.Cell(player.rightX) + 2
    local yi1 = Utils.Cell(player.bottomY)
    local yi2 = yi1 + 1
    if MapUtils.IsAreaValid(xi1, yi1 - 1, xi2 - xi1, yi2 - yi1 + 1) then
        for xi = xi1, xi2 do
            for yi = yi1, yi2 do
                if not MapUtils.HasFront(xi, yi) then
                    local liquidID, amount = MapUtils.GetLiquidIDAmount(xi, yi)
                    if liquidID == waterID then
                        if not MapUtils.IsSolid(xi, yi - 1) then
                            MapUtils.RemoveFront(xi, yi)
                            MapUtils.SetFront(xi, yi, Reg.BlockID("ice_thin"))
                            MapUtils.SetFrontTag(xi, yi, amount)
                            for i = 1, 4 do
                                EffectUtils.SendFromServer(Reg.EffectID("heal"), xi * 16 + 8, yi * 16 + 8,
                                        Utils.RandSym(1.0), Utils.RandSym(1.0),
                                        Utils.RandSym(0.25))
                            end
                        end
                    end
                end
            end
        end
    end
end

return EnchantmentFrostWalker