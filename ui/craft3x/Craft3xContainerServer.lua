---@class TC.Craft3xContainerServer:Container
local Craft3xContainerServer = class("Craft3xContainerServer", Container)
local ContainerHelper = require("ui.ContainerHelper")
local Craft3xHelper = require("Craft3xHelper")
local RecipeBookServer = require("ui.recipe_book.RecipeBookServer")
local Craft3xUIData = require("Craft3xUIData")

---__init
---@param player Player
---@param xi int
---@param yi int
function Craft3xContainerServer:__init(player, xi, yi)
    Craft3xContainerServer.super.__init(self)

    self.playerIndex = player.entityIndex
    self.backpackInventory = player.backpackInventory
    self.xi = xi
    self.yi = yi

    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    -- 0-8 inputs 9 output
    self.craftSlots = Inventory.new(10)
    for i = 0, 9 do
        Craft3xHelper.InitSlot(self, self.craftSlots, i)
    end

    self.recipeBookServer = RecipeBookServer.new(
            Reg.RecipeConfigID("Craft3x"),
            player, self.craftSlots, 0, 9)

end

function Craft3xContainerServer:OnClose()
    Craft3xHelper.Close(self.craftSlots, self.playerIndex, self.xi, self.yi)
end

function Craft3xContainerServer:CanInteractWith(player)
    return ContainerHelper.InInteractDistance(player, self.xi, self.yi)
end

function Craft3xContainerServer:OnEvent(eventId, eventString)
    if eventId == Craft3xUIData.EventID.RecipeBookRequest then
        local recipeID = tonumber(eventString)
        self.recipeBookServer:FlushValidRecipe(recipeID)
        if PlayerUtils.IsAlive(self.playerIndex) then
            local player = PlayerUtils.Get(self.playerIndex)
            player:FinishAdvancement(Reg.AdvancementID("recipe_book"))
        end
    elseif eventId == Craft3xUIData.EventID.PickOutput then
        Craft3xHelper.TryPickOutput(self.playerIndex, self, self.craftSlots)
    end
end

return Craft3xContainerServer