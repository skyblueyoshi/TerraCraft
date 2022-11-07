---@class TC.BlueTalisman:TC.BaseAccessory
local BlueTalisman = class("BlueTalisman", require("BaseAccessory"))

---OnAccessory
---@param player Player
function BlueTalisman:OnAccessoryUpdate(player)
    if player.tickTime % 64 == 0 then
        player:AddMagic(1, false)
    end
end

return BlueTalisman