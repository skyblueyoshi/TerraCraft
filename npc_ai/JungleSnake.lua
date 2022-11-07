---@class TC.JungleSnake:TC.BaseSnake
local JungleSnake = class("JungleSnake", require("BaseSnake"))

function JungleSnake:Init()
    JungleSnake.super.Init(self)

    self:SetSnakeData(5, Reg.NpcID("vine_man_eater_body"), Reg.NpcID("vine_man_eater_tail"),
            34, 36, 46, Size.new(44, 32), Size.new(54, 40)
    )
end

function JungleSnake:Update()
    if NetMode.current == NetMode.Server then
        return
    end
end

return JungleSnake