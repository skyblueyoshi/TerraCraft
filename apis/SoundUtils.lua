---@class SoundUtils
local SoundUtils = {}

---PlaySound
---@overload fun(soundID:int)
---@param soundID int
---@param xi int
---@param yi int
function SoundUtils.PlaySound(soundID, xi, yi)
end

---PlaySoundGroup
---@overload fun(soundGroupID:int)
---@param soundGroupID int
---@param xi int
---@param yi int
function SoundUtils.PlaySoundGroup(soundGroupID, xi, yi)
end

return SoundUtils