---@class TC.LightingTalisman:TC.BaseAccessory
local LightingTalisman = class("LightingTalisman", require("BaseAccessory"))

---OnAccessory
---@param player Player
function LightingTalisman:OnAccessoryUpdate(player)
    LightingUtils.Add(player.centerXi, player.centerYi, 32)
end

return LightingTalisman