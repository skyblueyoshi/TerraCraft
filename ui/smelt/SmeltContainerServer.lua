---@class TC.SmeltContainerServer:Container
local SmeltContainerServer = class("SmeltContainerServer", Container)
local UIData = require("SmeltUIData")
local ContainerHelper = require("ui.ContainerHelper")
local RecipeBookServer = require("ui.recipe_book.RecipeBookServer")

---__init
---@param player Player
---@param xi int
---@param yi int
function SmeltContainerServer:__init(player, xi, yi)
    SmeltContainerServer.super.__init(self)
    self.playerIndex = player.entityIndex
    self.xi = xi
    self.yi = yi
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    local smeltEntity = self:GetSmeltEntity()
    for i = 0, 3 do
        local slot = smeltEntity.inventory:GetSlot(i)
        self:AddSlotToContainer(smeltEntity.inventory, i)
        if i ~= 2 then
            slot:AddOnPickListener({ SmeltContainerServer.OnChanged, self })
            slot:AddOnPushListener({ SmeltContainerServer.OnChanged, self })
        end
    end

    self.recipeBookServer = RecipeBookServer.new(
            Reg.RecipeConfigID("Smelt"),
            player, smeltEntity.inventory, 0, 1)
end

function SmeltContainerServer:GetSmeltEntity()
    local blockEntity = MapUtils.GetBlockEntity(Reg.BlockEntityID("SmeltEntity"), self.xi, self.yi)
    if blockEntity == nil then
        return nil
    end
    ---@type TC.SmeltEntity
    local smeltEntity = blockEntity:GetModBlockEntity()
    return smeltEntity
end

function SmeltContainerServer:OnChanged()
    local smeltEntity = self:GetSmeltEntity()
    if smeltEntity then
        smeltEntity:FlushRecipeData()
    end
end

function SmeltContainerServer:OnDetectChange()
    local smeltEntity = self:GetSmeltEntity()
    if smeltEntity then
        local cookProgress = 0
        local burnProgress = 0
        if smeltEntity.totalCookTime > 0 then
            cookProgress = math.ceil(smeltEntity.cookedTime * 16.0 / smeltEntity.totalCookTime)
            cookProgress = math.min(math.max(cookProgress, 0), 16)
        end
        if smeltEntity.burnTotalTime > 0 then
            burnProgress = math.ceil(smeltEntity.burnTime * 16.0 / smeltEntity.burnTotalTime)
            burnProgress = math.min(math.max(burnProgress, 0), 16)
        end

        self:DetectAndSendChangeInteger(0, cookProgress)
        self:DetectAndSendChangeInteger(1, burnProgress)
    end
end

function SmeltContainerServer:OnEvent(eventId, eventString)
    if eventId == UIData.EventID.RecipeBookRequest then
        local recipeID = tonumber(eventString)
        self.recipeBookServer:FlushValidRecipe(recipeID)
    elseif eventId == UIData.EventID.PickOutput then
        self:TryPickOutput()
    end
end

function SmeltContainerServer:TryPickOutput()
    if not PlayerUtils.IsAlive(self.playerIndex) then
        return
    end
    local player = PlayerUtils.Get(self.playerIndex)
    local smeltEntity = self:GetSmeltEntity()
    if smeltEntity == nil then
        return
    end

    local inventory = player.backpackInventory
    local outputSlot = smeltEntity.inventory:GetSlot(2)
    if outputSlot.hasStack then
        local outStack = inventory:AddItemStack(outputSlot:GetStack())
        if outStack:Valid() then
            player:DropItem(outStack)
        end
        outputSlot:ClearStack()
    end
    self:OnChanged()

end

function SmeltContainerServer:CanInteractWith(player)
    if self:GetSmeltEntity() == nil then
        return false
    end
    local ok = ContainerHelper.InInteractDistance(player, self.xi, self.yi)
    return ok
end

return SmeltContainerServer