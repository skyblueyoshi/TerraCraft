---@class MapUtils
local MapUtils = {}

---IsValid
---@param xi int
---@param yi int
---@return boolean
function MapUtils.IsValid(xi, yi)
end

---IsAreaValid
---@param xi int
---@param yi int
---@param width int
---@param height int
---@return boolean
function MapUtils.IsAreaValid(xi, yi, width, height)
end

---IsSolid
---@param xi int
---@param yi int
---@return boolean
function MapUtils.IsSolid(xi, yi)
end

---HasFront
---@param xi int
---@param yi int
---@return boolean
function MapUtils.HasFront(xi, yi)
end

---GetFrontID
---@param xi int
---@param yi int
---@return int
function MapUtils.GetFrontID(xi, yi)
end

---GetFrontCenterXY
---@param xi int
---@param yi int
---@return double,double
function MapUtils.GetFrontCenterXY(xi, yi)
end

---@param xi int
---@param yi int
---@return int,int
function MapUtils.GetBodyPos(xi, yi)
end

---GetFrontIDTag
---@param xi int
---@param yi int
---@return int,int
function MapUtils.GetFrontIDTag(xi, yi)
end

---CanSetFrontTag
---@param xi int
---@param yi int
---@return boolean
function MapUtils.CanSetFrontTag(xi, yi)
end

---SetFrontTag
---@param xi int
---@param yi int
---@param tag int
---@return boolean
function MapUtils.SetFrontTag(xi, yi, tag)
end

---CanSetFront
---@overload fun(xi:int, yi:int, frontID:int):boolean
---@overload fun(xi:int, yi:int, frontID:int, isDestroyFragile:boolean):boolean
---@param xi int
---@param yi int
---@param frontID int
---@param isDestroyFragile boolean
---@param isCheckingEntities boolean
---@return boolean
function MapUtils.CanSetFront(xi, yi, frontID, isDestroyFragile, isCheckingEntities)
end

---SetFront
---@overload fun(xi:int, yi:int, frontID:int):boolean
---@overload fun(xi:int, yi:int, frontID:int, isDestroyFragile:boolean):boolean
---@overload fun(xi:int, yi:int, frontID:int, isDestroyFragile:boolean, showEffect:boolean):boolean
---@param xi int
---@param yi int
---@param frontID int
---@param isDestroyFragile boolean
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.SetFront(xi, yi, frontID, isDestroyFragile, showEffect, playSound)
end

---CanPlaceFront
---@overload fun(xi:int, yi:int, frontID:int):boolean
---@overload fun(xi:int, yi:int, frontID:int, isDestroyFragile:boolean):boolean
---@param xi int
---@param yi int
---@param frontID int
---@param isDestroyFragile boolean
---@param isCheckingEntities boolean
---@return boolean
function MapUtils.CanPlaceFront(xi, yi, frontID, isDestroyFragile, isCheckingEntities)
end

---PlaceFront
---@overload fun(xi:int, yi:int, frontID:int):boolean
---@overload fun(xi:int, yi:int, frontID:int, isDestroyFragile:boolean):boolean
---@overload fun(xi:int, yi:int, frontID:int, isDestroyFragile:boolean, showEffect:boolean):boolean
---@param xi int
---@param yi int
---@param frontID int
---@param isDestroyFragile boolean
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.PlaceFront(xi, yi, frontID, isDestroyFragile, showEffect, playSound)
end

---RemoveFront
---@overload fun(xi:int, yi:int):boolean
---@overload fun(xi:int, yi:int, showEffect:boolean):boolean
---@param xi int
---@param yi int
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.RemoveFront(xi, yi, showEffect, playSound)
end

---RemoveFrontAndDrop
---@overload fun(xi:int, yi:int):boolean
---@overload fun(xi:int, yi:int, isDropOriginal:boolean):boolean
---@overload fun(xi:int, yi:int, isDropOriginal:boolean, dropFortune:int):boolean
---@overload fun(xi:int, yi:int, isDropOriginal:boolean, dropFortune:int, showEffect:boolean):boolean
---@param xi int
---@param yi int
---@param isDropOriginal boolean
---@param dropFortune int
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.RemoveFrontAndDrop(xi, yi, isDropOriginal, dropFortune, showEffect, playSound)
end

---HasWall
---@param xi int
---@param yi int
---@return boolean
function MapUtils.HasWall(xi, yi)
end

---GetWallID
---@param xi int
---@param yi int
---@return int
function MapUtils.GetWallID(xi, yi)
end

---CanSetWall
---@param xi int
---@param yi int
---@param wallID int
---@return boolean
function MapUtils.CanSetWall(xi, yi, wallID)
end

---SetWall
---@overload fun(xi:int,yi:int,id:int):boolean
---@overload fun(xi:int,yi:int,id:int,showEffect:boolean):boolean
---@overload fun(xi:int,yi:int,id:int,showEffect:boolean,playSound:boolean):boolean
---@param xi int
---@param yi int
---@param id int
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.SetWall(xi, yi, id, showEffect, playSound)
end

---CanPlaceWall
---@param xi int
---@param yi int
---@param wallID int
---@return boolean
function MapUtils.CanPlaceWall(xi, yi, wallID)
end

---PlaceWall
---@overload fun(xi:int,yi:int,id:int):boolean
---@overload fun(xi:int,yi:int,id:int,showEffect:boolean):boolean
---@overload fun(xi:int,yi:int,id:int,showEffect:boolean,playSound:boolean):boolean
---@param xi int
---@param yi int
---@param id int
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.PlaceWall(xi, yi, id, showEffect, playSound)
end

---RemoveWall
---@overload fun(xi:int,yi:int):boolean
---@overload fun(xi:int,yi:int,showEffect:boolean):boolean
---@param xi int
---@param yi int
---@param showEffect boolean
---@param playSound boolean
function MapUtils.RemoveWall(xi, yi, showEffect, playSound)
end

---RemoveWallAndDrop
---@overload fun(xi:int, yi:int):boolean
---@overload fun(xi:int, yi:int, isDropOriginal:boolean):boolean
---@overload fun(xi:int, yi:int, isDropOriginal:boolean, dropFortune:int):boolean
---@overload fun(xi:int, yi:int, isDropOriginal:boolean, dropFortune:int, showEffect:boolean):boolean
---@param xi int
---@param yi int
---@param isDropOriginal boolean
---@param dropFortune int
---@param showEffect boolean
---@param playSound boolean
---@return boolean
function MapUtils.RemoveWallAndDrop(xi, yi, isDropOriginal, dropFortune, showEffect, playSound)
end

---HasLiquid
---@param xi int
---@param yi int
---@return boolean
function MapUtils.HasLiquid(xi, yi)
end

---GetLiquidID
---@param xi int
---@param yi int
---@return int
function MapUtils.GetLiquidID(xi, yi)
end

---GetLiquidIDAmount
---@param xi int
---@param yi int
---@return int,int
function MapUtils.GetLiquidIDAmount(xi, yi)
end

---SetLiquid
---@overload fun(xi:int,yi:int,liquidID:int):boolean
---@param xi int
---@param yi int
---@param liquidID int
---@param amount int
---@return boolean
function MapUtils.SetLiquid(xi, yi, liquidID, amount)
end

---RemoveLiquid
---@param xi int
---@param yi int
---@return boolean
function MapUtils.RemoveLiquid(xi, yi)
end

---TriggerLiquid
---@param xi int
---@param yi int
function MapUtils.TriggerLiquid(xi, yi)
end

---TriggerSignal
---@param xi int
---@param yi int
---@param isTurningOn boolean
---@return boolean
function MapUtils.TriggerSignal(xi, yi, isTurningOn)
end

---DelayTriggerSignal
---@param xi int
---@param yi int
---@param isTurningOn boolean
---@param delayTicks int
---@return boolean
function MapUtils.DelayTriggerSignal(xi, yi, isTurningOn, delayTicks)
end

---GetBlockEntity
---@param blockEntityID int
---@param xi int
---@param yi int
---@return BlockEntity
function MapUtils.GetBlockEntity(blockEntityID, xi, yi)
end

---CreateBlockEntity
---@param blockEntityID int
---@param xi int
---@param yi int
function MapUtils.CreateBlockEntity(blockEntityID,xi,yi)
end

---WeaponCollideWithMap
---@param obb ObbDouble
---@param isDestroyByWeapon boolean
---@return boolean,boolean
function MapUtils.WeaponCollideWithMap(obb, isDestroyByWeapon)
end

---PlayAnimation
---@param xi int
---@param yi int
---@param startFrameIndex int
---@param totalFrames int
---@param frameSpeed int
---@param isPositiveDirection boolean
function MapUtils.PlayAnimation(xi, yi, startFrameIndex, totalFrames, frameSpeed, isPositiveDirection)
end

---SetAnimationIndex
---@param xi int
---@param yi int
---@param animationIndex int
function MapUtils.SetAnimationIndex(xi, yi, animationIndex)
end

---SyncUnit
---@param xi int
---@param yi int
function MapUtils.SyncUnit(xi, yi)
end

---SetWireVisible
---@param visible boolean
function MapUtils.SetWireVisible(visible)
end

---IsWireVisible
---@return boolean
function MapUtils.IsWireVisible()
end

---HasWire
---@param xi int
---@param yi int
---@return boolean
function MapUtils.HasWire(xi, yi)
end

---GetWireID
---@param xi int
---@param yi int
---@return int
function MapUtils.GetWireID(xi, yi)
end

---SetWire
---@param xi int
---@param yi int
---@param wireID int
---@return boolean
function MapUtils.SetWire(xi, yi, wireID)
end

---RemoveWire
---@param xi int
---@param yi int
---@return boolean
function MapUtils.RemoveWire(xi, yi)
end

---RemoveWireAndDrop
---@overload fun(xi:int,yi:int):boolean
---@param xi int
---@param yi int
---@param playSound boolean
---@return boolean
function MapUtils.RemoveWireAndDrop(xi, yi, playSound)
end

---SetWireActivate
---@param xi int
---@param yi int
---@param activated boolean
function MapUtils.SetWireActivate(xi, yi, activated)
end

---DoRandomTick
---@param xi int
---@param yi int
function MapUtils.DoRandomTick(xi, yi)
end

---SetRenderPreview
---@param blockID int
---@param xi int
---@param yi int
---@param canPlace boolean
---@param playerCenterX double
---@param playerCenterY double
function MapUtils.SetBlockRenderPreview(blockID, centerX, centerY, canPlace, playerCenterX, playerCenterY)
end

function MapUtils.ClearBlockRenderPreview()
end

return MapUtils