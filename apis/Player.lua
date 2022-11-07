---@class Player:Entity
---@field entityIndex EntityIndex
---@field dataWatcher DataWatcher
---@field remoteDataWatcher DataWatcher
---@field lookAngle double
---@field facingDirection boolean
---@field hostXi int
---@field hostYi int
---@field biomeType int
---@field biomeID int
---@field defaultMaxSpeed double
---@field defaultJumpTime int
---@field defaultJumpSpeed double
---@field defaultFallSpeed double
---@field speedRate double
---@field jumpRate double
---@field jumpSpeedRate double
---@field fallSpeedRate double
---@field digSpeedRate double
---@field isInvisibility boolean
---@field health int
---@field maxHealth int
---@field mana int
---@field maxMana int
---@field expLevel int
---@field remainExp int
---@field isNoBreathing boolean
---@field breathRate double
---@field foodLevel int
---@field foodSaturationLevel int
---@field touchLiquidID int
---@field inLiquid boolean
---@field oldInLiquid boolean
---@field gameMode int
---@field op int
---@field name string
---@field ip string
---@field port int
---@field isCurrentClientPlayer boolean
---@field mouseInventory Inventory
---@field backpackInventory Inventory
---@field equipmentInventory Inventory
---@field enderInventory Inventory
---@field heldSlotIndex int
---@field heldSlotIndexJustChanged boolean
---@field smartMode SmartMode_Value
---@field isSmartPositionFound boolean
---@field holdColdTime int
---@field isDownPlatform boolean
---@field baseAttack Attack
---@field baseDefense Defense
---@field ignoreCollisionWithTiles boolean
---@field dying boolean
local Player = {}

---Strike
---@overload fun(deathReason:int, attack:Attack)
---@overload fun(deathReason:int, attack:Attack, hitAngle:double)
---@overload fun(deathReason:int, attack:Attack, hitAngle:double, immune:boolean)
---@param deathReason int
---@param attack Attack
---@param hitAngle double
---@param immune boolean
---@param makeHurtSound boolean
function Player:Strike(deathReason, attack, hitAngle, immune, makeHurtSound)
end

---StrikeFromPlayer
---@overload fun(player:Player, attack:Attack)
---@overload fun(player:Player, attack:Attack, hitAngle:double)
---@overload fun(player:Player, attack:Attack, hitAngle:double, immune:boolean)
---@param player Player
---@param attack Attack
---@param hitAngle double
---@param immune boolean
---@param makeHurtSound boolean
function Player:StrikeFromPlayer(player, attack, hitAngle, immune, makeHurtSound)
end

---StrikeFromNpc
---@overload fun(npc:Npc, attack:Attack)
---@overload fun(npc:Npc, attack:Attack, hitAngle:double)
---@overload fun(npc:Npc, attack:Attack, hitAngle:double, immune:boolean)
---@param npc Npc
---@param attack Attack
---@param hitAngle double
---@param immune boolean
---@param makeHurtSound boolean
function Player:StrikeFromNpc(npc, attack, hitAngle, immune, makeHurtSound)
end

---Heal
---@overload fun(healValue:int)
---@param healValue int
---@param showTip boolean
function Player:Heal(healValue, showTip)
end

---AddMagic
---@overload fun(magicValue:int)
---@param magicValue int
---@param showTip boolean
function Player:AddMagic(magicValue, showTip)
end

---AddBreath
---@param breathValue double
function Player:AddBreath(breathValue)
end

---DecBreath
---@param breathValue double
function Player:DecBreath(breathValue)
end

---SetBreath
---@param breathValue double
function Player:SetBreath(breathValue)
end

---AddFood
---@param foodLevel int
---@param foodSaturationLevel int
function Player:AddFood(foodLevel, foodSaturationLevel)
end

---DecFood
---@overload fun(foodLevel:int)
---@param foodLevel int
---@param foodSaturationLevel int
function Player:DecFood(foodLevel, foodSaturationLevel)
end

---OpenGui
---@param mod Mod
---@param guiID int
---@param xi int
---@param yi int
function Player:OpenGui(mod, guiID, xi, yi)
end

---
---@param mod Mod
---@param guiID int
---@param xi int
---@param yi int
function Player:OpenGuiRemote(mod, guiID, xi, yi)
end

---CloseGui
---@param mod Mod
---@param guiID int
function Player:CloseGui(mod, guiID)
end

---IsGuiOpened
---@param mod Mod
---@param guiID int
---@return boolean
function Player:IsGuiOpened(mod, guiID)
end

---DropItem
---@overload fun(itemStack:ItemStack)
---@param itemStack ItemStack
---@param onlyDropOne boolean
function Player:DropItem(itemStack, onlyDropOne)
end

---RequestPlaceBlock
---@param xi int
---@param yi int
---@param slotIndex int
---@param isPlacingWall boolean
---@return boolean
function Player:RequestPlaceBlock(xi, yi, slotIndex, isPlacingWall)
end

---RequestPlaceWire
---@param xi int
---@param yi int
---@param slotIndex int
---@return boolean
function Player:RequestPlaceWire(xi, yi, slotIndex)
end

---RequestDigBlock
---@param xi int
---@param yi int
---@param slotIndex int
---@param isDiggingWall boolean
---@param toolType string
---@return boolean
function Player:RequestDigBlock(xi, yi, slotIndex, isDiggingWall, toolType)
end

---RequestClickMap
---@param xi int
---@param yi int
---@return boolean
function Player:RequestClickMap(xi, yi)
end

---SetSmartMode
---@overload fun(smartMode:SmartMode_Value)
---@param smartMode SmartMode_Value
---@param pointedXi int
---@param pointedYi int
---@param operatingWall boolean
---@param itemStack ItemStack
---@param toolType string
function Player:SetSmartMode(smartMode, pointedXi, pointedYi, operatingWall, itemStack, toolType)
end

---@return int,int
function Player:GetSmartPosition()
end

---
---
---@param globalPlayerName string
---@return GlobalPlayer
function Player:GetGlobalPlayer(globalPlayerName)
end

---FinishAdvancement
---@param advancementID int
function Player:FinishAdvancement(advancementID)
end

---ClearAdvancement
---@param advancementID int
function Player:ClearAdvancement(advancementID)
end

---ClearAllAdvancement
function Player:ClearAllAdvancement()
end

---IsAdvancementFinished
---@param advancementID int
---@return boolean
function Player:IsAdvancementFinished(advancementID)
end

---GetSaveString
---@return string
function Player:GetSaveString()
end

---GetLevelNeedExp
---@param expLevel int
---@return int
function Player:GetLevelNeedExp(expLevel)
end

---AddExperience
---@param amount int
function Player:AddExperience(amount)
end

---RemoveExpLevel
---@param level int
function Player:RemoveExpLevel(level)
end

---AddBuff
---@param buffID int
---@param buffTime int
function Player:AddBuff(buffID, buffTime)
end

---RemoveBuff
---@param buffID int
function Player:RemoveBuff(buffID)
end

---RemoveAllBuff
function Player:RemoveAllBuff()
end

function Player:RemoveAllBuffExceptHealthCold()
end

---HasBuff
---@param buffID int
function Player:HasBuff(buffID)
end

---HasAnyBuff
function Player:HasAnyBuff()
end

---@return Buff[]
function Player:GetBuffList()
end

---@return boolean
function Player:GoHome()
end

function Player:TeleportToSpawn()
end

function Player:Teleport(x, y)
end

return Player