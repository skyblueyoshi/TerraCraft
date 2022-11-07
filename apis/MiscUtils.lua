---@class MiscUtils
---@field screenX double
---@field screenY double
---@field screenWidth int
---@field screenHeight int
---@field inGame boolean
---@field isSinglePlayerMode boolean
---@field isNight boolean
local MiscUtils = {}

---CreateExplosion
---@overload fun(xi:int, yi:int, power:double, hurtNpc:boolean, hurtPlayer:boolean)
---@overload fun(xi:int, yi:int, power:double, hurtNpc:boolean, hurtPlayer:boolean, killTiles:boolean)
---@overload fun(xi:int, yi:int, power:double, hurtNpc:boolean, hurtPlayer:boolean, killTiles:boolean, killBack:boolean)
---@overload fun(xi:int, yi:int, power:double, hurtNpc:boolean, hurtPlayer:boolean, killTiles:boolean, killBack:boolean, makeSound:boolean)
---@param xi int
---@param yi int
---@param power double
---@param hurtNpc boolean
---@param hurtPlayer boolean
---@param killTiles boolean
---@param killBack boolean
---@param makeSound boolean
---@param tileLimit int
function MiscUtils.CreateExplosion(xi, yi, power, hurtNpc, hurtPlayer, killTiles, killBack, makeSound, tileLimit)
end

---UnicastUTF8
---@param player Player
---@param message string
function MiscUtils.UnicastUTF8(player, message)
end

---BroadcastUTF8
---@param message string
function MiscUtils.BroadcastUTF8(message)
end

---SetDayTime
---@param dayTime int
function MiscUtils.SetDayTime(dayTime)
end

---GetDayTime
---@return int
function MiscUtils.GetDayTime()
end

---SetDaySpeed
---@param daySpeed int
function MiscUtils.SetDaySpeed(daySpeed)
end

---@return int
function MiscUtils.GetDaySpeed()
end

---SetWeatherTime
---@param weatherTime int
function MiscUtils.SetWeatherTime(weatherTime)
end

---@return int
function MiscUtils.GetWeatherTime()
end

---SetDayTimeFormat
---@param hours int
---@param minutes int
---@param seconds int
function MiscUtils.SetDayTimeFormat(hours, minutes, seconds)
end

---@return int,int,int
function MiscUtils.GetDayTimeFormat()
end

---RayDistance
---@overload fun(fromX:double, fromY:double, shootAngle:double):double
---@param fromX double
---@param fromY double
---@param shootAngle double
---@param maxDistance int
---@return double
function MiscUtils.RayDistance(fromX, fromY, shootAngle, maxDistance)
end

---RayReach
---@param fromX double
---@param fromY double
---@param toX double
---@param toY double
---@return boolean
function MiscUtils.RayReach(fromX, fromY, toX, toY)
end

function MiscUtils.SaveAll()
end

---SetAutoSaveEnabled
---@param enabled boolean
function MiscUtils.SetAutoSaveEnabled(enabled)
end

---GetPortNumber
---@return int
function MiscUtils.GetPortNumber()
end

---SetPVP
---@param enabled boolean
function MiscUtils.SetPVP(enabled)
end

---GetPVP
---@return boolean
function MiscUtils.GetPVP()
end

---SetSafeBlow
---@param enabled boolean
function MiscUtils.SetSafeBlow(enabled)
end

---GetSafeBlow
---@return boolean
function MiscUtils.GetSafeBlow()
end

---SetGameMode
---@param gameMode int
function MiscUtils.SetGameMode(gameMode)
end

---GetGameMode
---@return int
function MiscUtils.GetGameMode()
end

---@return Player[]
function MiscUtils.GetOnlinePlayerList()
end

---KickPlayer
---@param playerName string
function MiscUtils.KickPlayer(playerName)
end

---KickAllPlayers
function MiscUtils.KickAllPlayers()
end

---@return string[]
function MiscUtils.GetBlackList()
end

---Ban
---@param ip string
function MiscUtils.Ban(ip)
end

---RemoveBan
---@param id string
function MiscUtils.RemoveBan(id)
end

---AddTips
---@param x double
---@param y double
---@param tipsText string
---@param color Color
function MiscUtils.AddTips(x, y, tipsText, color)
end

---@return double
function MiscUtils.GetMapDisplayScale()
end

---SetMapDisplayScale
---@param scale double
function MiscUtils.SetMapDisplayScale(scale)
end

return MiscUtils