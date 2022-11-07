---@class TC.RepairContainerServer:Container
local RepairContainerServer = class("RepairContainerServer", Container)
local ContainerHelper = require("ui.ContainerHelper")
local UIData = require("RepairUIData")
local RecipeBookServer = require("ui.recipe_book.RecipeBookServer")

local REPAIR_SLOT_COUNT = 3
local REPAIR_OUTPUT_INDEX = 2

---__init
---@param player Player
---@param xi int
---@param yi int
function RepairContainerServer:__init(player, xi, yi)
    RepairContainerServer.super.__init(self)
    self.playerIndex = player.entityIndex
    self.inventory = player.backpackInventory
    self.xi = xi
    self.yi = yi
    -- 0-49 inventory
    ContainerHelper.ContainerServerAddBackpack(player, self)

    self._tempSlots = Inventory.new(REPAIR_SLOT_COUNT)
    self._toolSlot = self._tempSlots:GetSlot(0)
    self._sourceSlot = self._tempSlots:GetSlot(1)
    self._outputSlot = self._tempSlots:GetSlot(2)

    self._needExpLevel = 0

    for i = 0, REPAIR_SLOT_COUNT - 1 do
        local slot = self._tempSlots:GetSlot(i)
        self:AddSlotToContainer(self._tempSlots, i)
        if i ~= REPAIR_OUTPUT_INDEX then
            slot:AddOnPickListener({ RepairContainerServer.OnChanged, self })
            slot:AddOnPushListener({ RepairContainerServer.OnChanged, self })
        end
    end

    self.recipeBookServer = RecipeBookServer.new(
            Reg.RecipeConfigID("Repair"),
            player, self._tempSlots, 0, 2)
end

function RepairContainerServer:OnChanged()
    self:_OnFlushData()
end

function RepairContainerServer:_OnFlushData()
    self._outputSlot:ClearStack()

    if self._toolSlot.hasStack and self._sourceSlot.hasStack then
        local toolStack = self._toolSlot:GetStack()
        local toolItem = toolStack:GetItem()

        if toolItem.isTool then

            local sourceStack = self._sourceSlot:GetStack()
            local sourceItem = sourceStack:GetItem()

            -- repair by an enchantment book
            if sourceItem.id == Reg.ItemID("enchanted_book") then
                local wasteLevel = 0.0
                for i = 0, toolStack.enchantmentCount - 1 do
                    local enchantment = toolStack:GetEnchantmentByIndex(i)
                    local enchantmentData = EnchantmentUtils.GetData(enchantment.id)

                    wasteLevel = wasteLevel + (enchantmentData.minCreatingLevel + enchantment.level) * 0.25
                end
                self._needExpLevel = math.max(1, math.ceil(wasteLevel))
            else
                local recipeID = RecipeUtils.SearchRecipe(Reg.RecipeConfigID("Repair"), self._tempSlots, 0, 2)
                if recipeID > 0 then
                    local recipe = RecipeUtils.GetRecipe(recipeID)
                    local recipeOutputSlot = recipe.outputs[1]
                    if recipeOutputSlot.hasStack then
                        local recipeInputToolElement = recipe.inputs[1]
                        local isFixDurable = false
                        local isCrafting = false
                        if recipeInputToolElement.type == RecipeInputSlotType.Item and
                                recipeInputToolElement.id == recipeOutputSlot:GetStack():GetItem().id then
                            isFixDurable = true
                        else
                            isCrafting = true
                        end
                        local outputStack
                        if isFixDurable then
                            local repairRate = recipe.exData.repairRate
                            outputStack = toolStack:Clone()
                            outputStack:AddDurable(toolItem.maxDurable * repairRate)
                        elseif isCrafting then
                            outputStack = recipeOutputSlot:GetStack():Clone()
                            local outputItem = outputStack:GetItem()
                            local rate
                            if toolItem.maxDurable > 0 then
                                rate = toolStack.durable / toolItem.maxDurable
                            else
                                rate = 1.0
                            end
                            outputStack:SetDurable(outputItem.maxDurable * rate)
                        end
                        self._outputSlot:PushStack(outputStack)
                    end
                end
            end

        end
    end

    self:_SendData()
end

function RepairContainerServer:_SendData()
    self:DetectAndSendChangeInteger(0, self._needExpLevel)
end

function RepairContainerServer:OnEvent(eventId, eventString)
    if eventId == UIData.EventID.PickOutput then
        self:TryPickOutput()
    elseif eventId == UIData.EventID.RecipeBookRequest then
        local recipeID = tonumber(eventString)
        self.recipeBookServer:FlushValidRecipe(recipeID)
    end
end

function RepairContainerServer:TryPickOutput()
    if not PlayerUtils.IsAlive(self.playerIndex) then
        return
    end
    local player = PlayerUtils.Get(self.playerIndex)
    local inventory = player.backpackInventory
    if self._outputSlot.hasStack then
        local outStack = inventory:AddItemStack(self._outputSlot:GetStack())
        if outStack:Valid() then
            player:DropItem(outStack)
        end
        self._outputSlot:ClearStack()
    end
    self._toolSlot:DecrStackSize(1)
    self._sourceSlot:DecrStackSize(1)
    self:OnChanged()

end

function RepairContainerServer:CanInteractWith(player)
    local ok = ContainerHelper.InInteractDistance(player, self.xi, self.yi)
    return ok
end

function RepairContainerServer:OnClose()
    ContainerHelper.CloseSendBackItems(self.playerIndex,
            self.xi, self.yi, self._tempSlots,
            { 0, 1 })
    self._outputSlot:ClearStack()
end

return RepairContainerServer