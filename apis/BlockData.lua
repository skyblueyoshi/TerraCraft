---@API

---@class BlockData 描述一个方块数据。
---@field textureLocation TextureLocation 方块渲染在地图中的纹理。
---@field group int 方块组，决定渲染在地图中纹理衔接方式。
---@field subGroup int 方块子组。
---@field stepSoundId int 踩在方块上发出的音效ID。
---@field stepSoundGroupId int 踩在方块上发出的音效组ID。
---@field functionSoundId int 
---@field functionSoundGroupId int
---@field functionSoundId2 int
---@field functionSoundGroupId2 int
---@field functionSoundId3 int
---@field functionSoundGroupId3 int
---@field functionSoundId4 int
---@field functionSoundGroupId4 int
---@field isRipen boolean 是否允许催熟。
---@field isDoorOpened boolean 是否为开启了的门。
---@field isDoorClosed boolean 是否为关闭了的门。
local BlockData = {}

---判断指定物品，能否种植在当前方块上。
---@param itemID int 物品ID。
---@return boolean 物品能否种植在方块上。
function BlockData:CanSeed(itemID)
end

---当前方块是否拥有动画效果。
---@return boolean 是否拥有动画效果。
function BlockData:HasAnimation()
end

return BlockData
