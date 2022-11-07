---@class TC.CraftingTable:ModBlock
local CraftingTable = class("CraftingTable", ModBlock)
local GuiID = require("ui.GuiID")

function CraftingTable.OnClicked(xi, yi, parameterClick)
    local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        player:OpenGui(Mod.current, GuiID.Craft3x, xi, yi)
    end
end

return CraftingTable