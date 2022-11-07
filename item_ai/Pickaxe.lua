---@class TC.Pickaxe:TC.BaseTool
local Pickaxe = class("Staff", require("BaseTool"))

function Pickaxe:DrawIcon(position, color, spriteExData)
    self:_DrawIconRotated(position, color, spriteExData)
end

return Pickaxe