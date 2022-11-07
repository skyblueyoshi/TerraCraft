---@class BlockData
---@field textureLocation TextureLocation
---@field group int
---@field subGroup int
---@field stepSoundId int
---@field stepSoundGroupId int
---@field functionSoundId int
---@field functionSoundGroupId int
---@field functionSoundId2 int
---@field functionSoundGroupId2 int
---@field functionSoundId3 int
---@field functionSoundGroupId3 int
---@field functionSoundId4 int
---@field functionSoundGroupId4 int
---@field isRipen boolean
---@field isDoorOpened boolean
---@field isDoorClosed boolean
local BlockData = {}

---CanSeed
---@param itemID int
---@return boolean
function BlockData:CanSeed(itemID)
end

---@return boolean
function BlockData:HasAnimation()
end

return BlockData