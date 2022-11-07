---@class TC.BrewingContainerServer:Container
local BrewingContainerServer = class("BrewingContainerServer", Container)
local ContainerHelper = require("ui.ContainerHelper")
local UIData = require("BrewingUIData")
local RecipeBookServer = require("ui.recipe_book.RecipeBookServer")


---__init
---@param player Player
---@param xi int
---@param yi int
function BrewingContainerServer:__init(player, xi, yi)
    BrewingContainerServer.super.__init(self)
    self.playerIndex = player.entityIndex
    self.inventory = player.backpackInventory
    self.xi = xi
    self.yi = yi
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    local brewingEntity = self:GetBrewingEntity()

    for i = 0, 3 do
        local slot = brewingEntity.inventory:GetSlot(i)
        self:AddSlotToContainer(brewingEntity.inventory, i)
        if i ~= 2 then
            slot:AddOnPickListener({ BrewingContainerServer.OnChanged, self })
            slot:AddOnPushListener({ BrewingContainerServer.OnChanged, self })
        end
    end

    self.recipeBookServer = RecipeBookServer.new(
            Reg.RecipeConfigID("Brew"),
            player, brewingEntity.inventory, 0, 2)
end

function BrewingContainerServer:GetBrewingEntity()
    local blockEntity = MapUtils.GetBlockEntity(Reg.BlockEntityID("BrewingEntity"), self.xi, self.yi)
    if blockEntity == nil then
        return nil
    end
    ---@type TC.BrewingEntity
    local modEntity = blockEntity:GetModBlockEntity()
    return modEntity
end

function BrewingContainerServer:OnChanged()
    local modEntity = self:GetBrewingEntity()
    if modEntity then
        modEntity:FlushRecipeData()
    end
end

function BrewingContainerServer:OnDetectChange()
    local modEntity = self:GetBrewingEntity()
    if modEntity then
        local progress = 0
        if modEntity.totalProcessTime > 0 then
            progress = math.ceil(modEntity.processedTime * 16.0 / modEntity.totalProcessTime)
            progress = math.min(math.max(progress, 0), 16)
        end
        self:DetectAndSendChangeInteger(0, progress)
        self:DetectAndSendChangeInteger(1, modEntity.remainProcessTimes)
        self:DetectAndSendChangeBoolean(2, modEntity.currentRecipeID > 0)
    end
end

function BrewingContainerServer:OnEvent(eventId, eventString)
    if eventId == UIData.EventID.RecipeBookRequest then
        local recipeID = tonumber(eventString)
        self.recipeBookServer:FlushValidRecipe(recipeID)
    elseif eventId == UIData.EventID.PickOutput then
        self:TryPickOutput()
    end
end

function BrewingContainerServer:TryPickOutput()
    if not PlayerUtils.IsAlive(self.playerIndex) then
        return
    end
    local player = PlayerUtils.Get(self.playerIndex)
    local brewingEntity = self:GetBrewingEntity()
    if brewingEntity == nil then
        return
    end

    local inventory = player.backpackInventory
    local outputSlot = brewingEntity.inventory:GetSlot(2)
    if outputSlot.hasStack then
        local outStack = inventory:AddItemStack(outputSlot:GetStack())
        if outStack:Valid() then
            player:DropItem(outStack)
        end
        outputSlot:ClearStack()
    end
    self:OnChanged()

end

function BrewingContainerServer:CanInteractWith(player)
    if self:GetBrewingEntity() == nil then
        return false
    end
    local ok = ContainerHelper.InInteractDistance(player, self.xi, self.yi)
    return ok
end

return BrewingContainerServer