---@class TC.EnderStorage:ModBlock
local EnderStorage = class("EnderStorage", ModBlock)
local GuiID = require("ui.GuiID")

function EnderStorage.OnClicked(xi, yi, parameterClick)
local player = PlayerUtils.Get(parameterClick.playerEntityIndex)
    if player then
        player:OpenGui(Mod.current, GuiID.EnderChest30, xi, yi)
    end
end

return EnderStorage