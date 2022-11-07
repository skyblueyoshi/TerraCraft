---@class TC.EnderChest30UI:TC.IChestUI
local EnderChest30UI = class("EnderChest30UI", require("IChestUI"))

---@param container TC.Chest30ContainerClient
function EnderChest30UI:__init(container)
    EnderChest30UI.super.__init(self, require("ui.UIDesign").getChest30UI(), container,
            require("ui.GuiID").EnderChest30)
end

return EnderChest30UI