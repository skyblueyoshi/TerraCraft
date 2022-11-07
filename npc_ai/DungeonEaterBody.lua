---@class TC.DungeonEaterBody:TC.BaseSnakeBody
local DungeonEaterBody = class("DungeonEaterBody", require("BaseSnakeBody"))
local DungeonEater = require("DungeonEater")

function DungeonEaterBody:Init()
    DungeonEaterBody.super.Init(self)
end

function DungeonEaterBody:Update()
    DungeonEaterBody.super.Update(self)
    local npc = self.npc
    DungeonEater.DoEatDungeonBlocks(npc)
    LightingUtils.Add(npc.centerXi, npc.centerYi, 26)
end

return DungeonEaterBody