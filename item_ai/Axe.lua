---@class TC.Axe:TC.BaseTool
local Axe = class("Staff", require("BaseTool"))

function Axe:DrawIcon(position, color, spriteExData)
    self:_DrawIconRotated(position, color, spriteExData)
end

return Axe