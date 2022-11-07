---@class TC.Anvil:ModBlock
local Anvil = class("Anvil", ModBlock)
local GuiID = require("ui.GuiID")

function Anvil.OnClicked(xi, yi, parameterClick)
local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        player:OpenGui(Mod.current, GuiID.Repair, xi, yi)
    end
end

return Anvil