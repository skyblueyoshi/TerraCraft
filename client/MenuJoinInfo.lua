---@class TC.MenuJoinInfo
local MenuJoinInfo = class("MenuJoinData")

local s_instance
---@return TC.MenuJoinInfo
function MenuJoinInfo.getInstance()
    if s_instance == nil then
        s_instance = MenuJoinInfo.new()
    end
    return s_instance
end

function MenuJoinInfo:__init()
    self.playerInfo = {
        name = ""
    }
    self.worldInfo = {
        name = ""
    }
    self.serverInfo = {
        address = "",
        port = 0,
        isMultiplayer = false
    }
end

function MenuJoinInfo:getData()
    local joinData = JoinData.new()
    joinData.playerName = self.playerInfo.name
    joinData.worldName = self.worldInfo.name
    joinData.multiplayer = self.serverInfo.isMultiplayer
    joinData.address = self.serverInfo.address
    joinData.port = self.serverInfo.port
    return joinData
end

return MenuJoinInfo