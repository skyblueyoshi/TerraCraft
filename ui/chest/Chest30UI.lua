---@class TC.Chest30UI:TC.IChestUI
local Chest30UI = class("Chest30UI", require("IChestUI"))

---@param container TC.Chest30ContainerClient
function Chest30UI:__init(container)
    Chest30UI.super.__init(self, require("ui.UIDesign").getChest30UI(), container,
            require("ui.GuiID").Chest30)
end

return Chest30UI