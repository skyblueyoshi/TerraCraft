---@class TC.TCModWorldData
local TCModWorldData = class("TCModWorldData")
local Portals = require("Portals")

local s_instance
---@return TC.TCModWorldData
function TCModWorldData.getInstance()
    if s_instance == nil then
        s_instance = TCModWorldData.new()
    end
    return s_instance
end

function TCModWorldData:__init()
    self.portals = Portals.new()
end

function TCModWorldData:Save()
    local resPortals = self.portals:Save()
    return {
        portals = resPortals
    }
end

function TCModWorldData:Load(data)
    if data.portals ~= nil then
        self.portals:Load(data.portals)
    end
end

return TCModWorldData