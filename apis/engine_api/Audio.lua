---@class Audio
---@field musicVolume number
local Audio = {}

---
---@param filePath string
---@return number
function Audio.loadSoundEffectFromFileSystem(filePath)
end

---
---@param assetBundle AssetBundle
---@param filePath string
---@return number
function Audio.loadSoundEffectFromAssetBundle(assetBundle, filePath)
end

---unloadSoundEffectByID
---@param soundID number
function Audio.unloadSoundEffectByID(soundID)
end

---
---@param bytes Bytes
---@param offset number
---@param size number
---@return number
function Audio.loadSoundEffectFromMemory(bytes, offset, size)
end

---
---@param filePath string
---@return number
function Audio.loadMusicEffectFromFileSystem(filePath)
end

---
---@param assetBundle AssetBundle
---@param filePath string
---@return number
function Audio.loadMusicEffectFromAssetBundle(assetBundle, filePath)
end

---
---@param bytes Bytes
---@param offset number
---@param size number
---@return number
function Audio.loadMusicEffectFromMemory(bytes, offset, size)
end

---unloadMusicEffectByID
---@param musicID number
function Audio.unloadMusicEffectByID(musicID)
end

---
---@overload fun(id:number)
---@overload fun(id:number, loops:number)
---@overload fun(id:number, loops:number, fadeInTime:number)
---@overload fun(id:number, loops:number, fadeInTime:number, beginTime:number)
---@param id number
---@param loops number
---@param fadeInTime number
---@param beginTime number
function Audio.playMusic(id, loops, fadeInTime, beginTime)
end

---stopMusic
---@param fadeOutTime number
function Audio.stopMusic(fadeOutTime)
end

function Audio.pauseMusic()
end

function Audio.resumeMusic()
end

---@return FadingState_Value
function Audio.getMusicFadingState()
end

---getMusicPlayingTimePoint
---@param musicID string
---@return string
function Audio.getMusicPlayingTimePoint(musicID)
end

---
---@param volume number
function Audio.setMusicVolume(volume)
end

---
---@param volume number
function Audio.setAllSoundEffectVolume(volume)
end

function Audio.isMusicPaused()
end

function Audio.isMusicPlaying()
end
---
---@param listener table|function
---@return ListenerID
function Audio:addMusicFinishedListener(listener)
end

---
---@param listenerID ListenerID
function Audio:removeMusicFinishedListener(listenerID)
end

return Audio