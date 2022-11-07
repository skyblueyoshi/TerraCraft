---@class TC.MusicScene
local MusicScene = class("MusicScene")
local Algorithm = require("util.Algorithm")

---__init
---@param musicList
---@param fadeInTime int
---@param fadeOutTime int
---@param interval int
---@param intervalRandOffset int
function MusicScene:__init(musicList, fadeInTime, fadeOutTime, interval, intervalRandOffset)
    self.musicList = musicList
    self.fadeInTime = fadeInTime
    self.fadeOutTime = fadeOutTime
    self.interval = interval
    self.intervalRandOffset = intervalRandOffset
end

function MusicScene:doRandomList()
    Algorithm.Shuffle(self.musicList)
end

return MusicScene