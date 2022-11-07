---@class TC.CameraInGame
local CameraInGame = class("CameraInGame")

local s_instance
---@return TC.CameraInGame
function CameraInGame.getInstance()
    if s_instance == nil then
        s_instance = CameraInGame.new()
    end
    return s_instance
end

function CameraInGame:__init()
    ---@type CameraComponentWrapper
    self.camera = nil
end

function CameraInGame:setCamera(camera)
    self.camera = camera
end

return CameraInGame