---@class TC.BackpackContainerServer:Container
local BackpackContainerServer = class("BackpackContainerServer", Container)
local UIData = require("BackpackUIData")
local ContainerHelper = require("ui.ContainerHelper")
local Craft3xHelper = require("ui.craft3x.Craft3xHelper")
local RecipeBookServer = require("ui.recipe_book.RecipeBookServer")
local GPlayer = require("player.GPlayer")

---@param player Player
function BackpackContainerServer:__init(player)
    BackpackContainerServer.super.__init(self)

    self.playerIndex = player.entityIndex
    self.inventory = player.backpackInventory
    self.equipmentInventory = player.equipmentInventory
    self.accessoryInventory = GPlayer.GetInstance(player).accessoryInventory
    self.trashInventory = GPlayer.GetInstance(player).trashInventory
    self.xi = player.centerXi
    self.yi = player.centerYi
    -- 0-8 inputs 9 output
    self.craftSlots = Inventory.new(10)
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)
    for i = 1, 3 do
        -- 50-52 equipment
        self:AddSlotToContainer(self.equipmentInventory, i - 1)
    end
    for i = 1, 3 do
        -- 53-55 appearance
        self:AddSlotToContainer(self.equipmentInventory, i - 1 + 3)
    end
    --local craft2xMapping = { 0, 1, 3, 4 }
    --for i = 1, 4 do
    --    -- 56-59 craft inputs
    --    local slotIndexInCraft = craft2xMapping[i]
    --
    --    Craft3xHelper.InitSlot(self, self.craftSlots, slotIndexInCraft)
    --end
    for i = 0, 8 do
        -- 56-64 craft inputs
        Craft3xHelper.InitSlot(self, self.craftSlots, i)
    end

    -- 65 craft output
    Craft3xHelper.InitSlot(self, self.craftSlots, 9)

    for i = 1, 3 do
        -- 66-68 accessory
        self:AddSlotToContainer(self.accessoryInventory, i - 1)
    end

    -- 69 trash
    self:AddSlotToContainer(self.trashInventory, 0)

    self.recipeBookServer = RecipeBookServer.new(
            Reg.RecipeConfigID("Craft3x"),
            player, self.craftSlots, 0, 9)
end

function BackpackContainerServer:OnEvent(eventId, eventString)
    if eventId == UIData.EventID.SortBackpack then
        --self.inventory:SortAll()
        self.inventory:Sort(10, 40)
    elseif eventId == UIData.EventID.RecipeBookRequest then
        local recipeID = tonumber(eventString)
        self.recipeBookServer:FlushValidRecipe(recipeID)
        if PlayerUtils.IsAlive(self.playerIndex) then
            local player = PlayerUtils.Get(self.playerIndex)
            player:FinishAdvancement(Reg.AdvancementID("recipe_book"))
        end
    elseif eventId == UIData.EventID.PickOutput then
        Craft3xHelper.TryPickOutput(self.playerIndex, self, self.craftSlots)
    end
end

function BackpackContainerServer:OnUpdate()

end

function BackpackContainerServer:OnClose()
    Craft3xHelper.Close(self.craftSlots, self.playerIndex, self.xi, self.yi)
end

function BackpackContainerServer:CanInteractWith(_)
    return true
end

return BackpackContainerServer