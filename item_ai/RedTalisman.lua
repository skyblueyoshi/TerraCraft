---@class TC.RedTalisman:TC.BaseAccessory
local RedTalisman = class("RedTalisman", require("BaseAccessory"))

---OnAccessory
---@param player Player
function RedTalisman:OnAccessoryUpdate(player)
    if player.tickTime % 64 == 0 then
        player:Heal(1, false)
    end
end

return RedTalisman