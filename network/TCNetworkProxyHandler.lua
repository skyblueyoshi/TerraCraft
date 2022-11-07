---@class TC.TCNetworkProxyHandler:TC.ModNetworkProxyHandler
local TCNetworkProxyHandler = class("TCNetworkProxyHandler", require("ModNetworkProxyHandler"))
local RPC_ID = require("RPC_ID")
local GPlayer = require("player.GPlayer")

function TCNetworkProxyHandler:__init()
    TCNetworkProxyHandler.super.__init(self, Mod.current)

    local SERVER_BOUND_MAPPINGS = {
        [RPC_ID.SB_PLAYER_MAP_OPERATION] = TCNetworkProxyHandler.PlayerMapOperation,
        [RPC_ID.SB_PLAYER_THROWING] = TCNetworkProxyHandler.PlayerThrowing,
        [RPC_ID.SB_REMOVE_WIRE] = TCNetworkProxyHandler.RemoveWire,
        [RPC_ID.SB_DROP_ITEM_HELD] = TCNetworkProxyHandler.DropItemHeld,
        [RPC_ID.SB_DROP_ITEM_MOUSE] = TCNetworkProxyHandler.DropItemMouse,
    }

    self:RegisterRPCHandlerServerBoundMappings(SERVER_BOUND_MAPPINGS)
end

function TCNetworkProxyHandler:PlayerMapOperation(player, opType, xi, yi)
    GPlayer.GetInstance(player):OnMapOpServerBound(opType, xi, yi)
end

function TCNetworkProxyHandler:PlayerThrowing(player, angle)
    GPlayer.GetInstance(player):OnThrowingServerBound(angle)
end

function TCNetworkProxyHandler:RemoveWire(player, xi, yi)
    GPlayer.GetInstance(player):OnRemovingWireBound(xi, yi)
end

---DropItemHeld
---@param player Player
function TCNetworkProxyHandler:DropItemHeld(player, onlyOne)
    local heldSlot = player.backpackInventory:GetSlot(player.heldSlotIndex)
    if heldSlot.hasStack then
        player:DropItem(heldSlot:GetStack(), onlyOne)
        if onlyOne then
            heldSlot:DecrStackSize(1)
        else
            heldSlot:ClearStack()
        end
    end
end

---DropItemHeld
---@param player Player
function TCNetworkProxyHandler:DropItemMouse(player)
    local mouseSlot = player.mouseInventory:GetSlot(0)
    if mouseSlot.hasStack then
        player:DropItem(mouseSlot:GetStack())
        mouseSlot:ClearStack()
    end
end

return TCNetworkProxyHandler