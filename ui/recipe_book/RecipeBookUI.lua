---@class TC.RecipeBookUI:TC.UIWindow
local RecipeBookUI = class("RecipeBookUI", require("ui.UIWindow"))
local UIUtil = require("ui.UIUtil")
local UIDefault = require("ui.UIDefault")

---__init
---@param recipeConfigID int
---@param attachFrameworkNode UINode
---@param showing boolean
---@param listenedSlots Slot[]
---@param onClickedCallback table
---@param searchMask string
function RecipeBookUI:__init(recipeConfigID, attachFrameworkNode, showing, listenedSlots, onClickedCallback, searchMask)
    RecipeBookUI.super.__init(self, require("ui.UIDesign").getRecipeBookUI())

    self.DISPLAY_CNT_PRE_LINE = 5

    self._recipeConfigID = recipeConfigID
    self._rootLayer = self.root
    self._panelList = self._rootLayer:getChild("panel_list")
    self._itemOffsetSize = Size.new(UIDefault.CellHugeOffset, UIDefault.CellHugeOffset)

    self.uiSize = self._rootLayer.size

    self._itemIDExistDict = {}
    self._recipeShowInventory = Inventory.new(0)
    self._onRecipeShowChangedListener = {}
    self._recipeCacheItemData = {}
    self._validItemCount = 0
    self._invalidItemCount = 0
    self._totalItemCount = 0

    self._attachFrameworkNode = attachFrameworkNode
    self._listenedSlots = listenedSlots

    self._onClickedCallback = onClickedCallback
    self._searchMask = searchMask

    self.showing = showing

    self:_initContent()
end

function RecipeBookUI:_initContent()
    local player = PlayerUtils.GetCurrentClientPlayer()
    require("player.GPlayer").GetInstance(player).recipeBookHookUI = self
    self:RefreshDisplayState()
end

function RecipeBookUI:SetDisplayState(showing)
    self.showing = showing
    self:RefreshDisplayState()
end

function RecipeBookUI:RefreshDisplayState()
    self._rootLayer.visible = self.showing
    if self.showing then
        local OFFSET = 8
        local totalWidth = self._attachFrameworkNode.width + self.uiSize.width + OFFSET
        self._rootLayer.positionX = GameWindow.displayResolution.width / 2 - totalWidth / 2
        self._attachFrameworkNode.positionX = self._rootLayer.positionX + self.uiSize.width + OFFSET
        self:_refreshData()
        self:_resetTable()
    else
        self._attachFrameworkNode.positionX = GameWindow.displayResolution.width / 2 - self._attachFrameworkNode.width / 2
    end
end

function RecipeBookUI:SetOnRecipeChangedListener(callback, caller)
    self._onRecipeShowChangedListener = { callback, caller }
end

function RecipeBookUI:_resetTable()
    UIUtil.setTable(self._panelList, self, true, self.DISPLAY_CNT_PRE_LINE)
end

function RecipeBookUI:_getTableElementCount()
    return self._recipeShowInventory.slotCount
end

function RecipeBookUI:_getTableElementPositionOffset()
    return self._itemOffsetSize
end

---_setTableElement
---@param node UINode
---@param index number
function RecipeBookUI:_setTableElement(node, index)
    node.tag = index
    if index <= self._recipeShowInventory.slotCount then
        local slot = self._recipeShowInventory:GetSlot(index - 1)
        if slot.hasStack then
            local itemID = slot:GetStack():GetItem().id
            local data = self._recipeCacheItemData[itemID]
            local validRecipeID = 0
            if data ~= nil and #data.validRecipeIDs > 0 then
                validRecipeID = data.validRecipeIDs[1]
            end

            UIUtil.setSlotStyle(node, validRecipeID > 0 and 4 or 3)
            UIUtil.hookSlotView(node, slot)

            if validRecipeID > 0 then
                node:addTouchUpListener({ RecipeBookUI._OnValidRecipeClicked, self, validRecipeID })
            else
                node:addTouchUpListener({ RecipeBookUI._OnInvalidRecipeClicked, self, slot })
            end
        end
    end
end

function RecipeBookUI:_OnValidRecipeClicked(recipeID)
    self.manager:playClickSound()
    print("Valid:", recipeID)

    if self._onClickedCallback ~= nil and #self._onClickedCallback == 2 then
        local func = self._onClickedCallback[1]
        local obj = self._onClickedCallback[2]
        func(obj, recipeID)
    end
end

---_OnInvalidRecipeClicked
---@param slot Slot
function RecipeBookUI:_OnInvalidRecipeClicked(slot)
    self.manager:playClickSound()
    if slot.hasStack then
        local stack = slot:GetStack()
        local nei = require("ui.nei.NeiUI").new()
        nei:trySearch(stack, true)
    end
end

function RecipeBookUI:OnUpdate()
    --print("BackpackUI:OnUpdate!!")
end

function RecipeBookUI:OnClose()
    require("player.GPlayer").GetInstance().recipeBookHookUI = nil
    self.ui:closeWindow()
end

function RecipeBookUI:_refreshData()
    local tempItemIDAndSizes = {}

    ---@param slot Slot
    for _, slot in ipairs(self._listenedSlots) do
        if slot.hasStack then
            local itemID = slot:GetStack():GetItem().id
            if tempItemIDAndSizes[itemID] == nil then
                tempItemIDAndSizes[itemID] = slot:GetStack().stackSize
            else
                tempItemIDAndSizes[itemID] = tempItemIDAndSizes[itemID] + slot:GetStack().stackSize
            end
        end
    end

    local needToSearch = false
    local tempCount = 0
    local oldCount = 0
    for _, _ in pairs(tempItemIDAndSizes) do
        tempCount = tempCount + 1
    end
    for _, _ in pairs(self._itemIDExistDict) do
        oldCount = oldCount + 1
    end

    if tempCount ~= oldCount then
        needToSearch = true
    else
        for id, size in pairs(tempItemIDAndSizes) do
            if not self._itemIDExistDict[id] then
                needToSearch = true
                break
            elseif self._itemIDExistDict[id] ~= size then
                needToSearch = true
                break
            end
        end
    end
    if needToSearch then
        self._validItemCount = 0
        self._invalidItemCount = 0
        self._totalItemCount = 0
        self._recipeCacheItemData = {}
        self._itemIDExistDict = tempItemIDAndSizes
        local allRecipeIDExists = {}

        -- search all recipe by every slot
        local configID = self._recipeConfigID
        ---@param slot Slot
        for _, slot in ipairs(self._listenedSlots) do
            if slot.hasStack then
                local results = RecipeUtils.SearchRecipeHasInputItem(configID, slot:GetStack())
                for _, recipeID in pairs(results) do
                    local recipe = RecipeUtils.GetRecipe(recipeID)
                    if recipe:IsValidByMask(self._searchMask) then
                        allRecipeIDExists[recipeID] = true
                    end
                end
            end
        end

        local validRecipeIDs = {}
        local invalidRecipeIDs = {}
        for recipeID, _ in pairs(allRecipeIDExists) do
            local temps = clone(self._itemIDExistDict)
            local recipe = RecipeUtils.GetRecipe(recipeID)
            local valid = true
            -- first, check the fix item input
            ---@param ie RecipeInputSlot
            for _, ie in each(recipe.inputs) do
                if ie.type == RecipeInputSlotType.Item then
                    local itemID = ie.itemStack:GetItem().id
                    local size = ie.itemStack.stackSize
                    local tempSize = temps[itemID]
                    if tempSize == nil then
                        valid = false
                        break
                    elseif tempSize > size then
                        temps[itemID] = tempSize - size
                    elseif tempSize == size then
                        temps[itemID] = nil
                    else
                        valid = false
                        break
                    end
                end
            end
            if valid then
                -- second, check the ore dictionary
                ---@param ie RecipeInputSlot
                for _, ie in each(recipe.inputs) do
                    if ie.type == RecipeInputSlotType.OreDictionary then
                        local ids = ItemUtils.GetOreDictionaryItemIDs(ie.id)
                        local checkSize = ie.stackSize
                        for _, subItemID in each(ids) do
                            local tempSize = temps[subItemID]
                            if tempSize ~= nil then
                                if tempSize > checkSize then
                                    temps[subItemID] = tempSize - checkSize
                                    checkSize = 0
                                elseif tempSize == checkSize then
                                    temps[subItemID] = nil
                                    checkSize = 0
                                else
                                    checkSize = checkSize - tempSize
                                    temps[subItemID] = nil
                                end
                            end
                            if checkSize <= 0 then
                                break
                            end
                        end
                        if checkSize > 0 then
                            valid = false
                            break
                        end
                    end
                end
            end
            if valid then
                table.insert(validRecipeIDs, recipeID)
            else
                local canDisplay = false
                -- check if contains recipe important input element
                ---@param ie RecipeInputSlot
                for _, ie in each(recipe.inputs) do
                    if ie.isImportant then
                        if ie.type == RecipeInputSlotType.Item then
                            local itemID = ie.itemStack:GetItem().id
                            if self._itemIDExistDict[itemID] ~= nil then
                                canDisplay = true
                                break
                            end
                        elseif ie.type == RecipeInputSlotType.OreDictionary then
                            local ids = ItemUtils.GetOreDictionaryItemIDs(ie.id)
                            for _, subItemID in each(ids) do
                                if self._itemIDExistDict[subItemID] ~= nil then
                                    canDisplay = true
                                    break
                                end
                            end
                            if canDisplay then
                                break
                            end
                        end
                    end
                end
                if canDisplay then
                    table.insert(invalidRecipeIDs, recipeID)
                end
            end
        end

        local validItemStacks = {}
        local validItemCount = 0
        local invalidItemStacks = {}
        local invalidItemCount = 0
        local function doCacheData(recipeID, isCacheValidItem)
            local recipe = RecipeUtils.GetRecipe(recipeID)
            local stack = recipe.outputs[1]:GetStack()
            local itemID = stack:GetItem().id
            if self._recipeCacheItemData[itemID] == nil then
                local resStack = stack:Clone()
                resStack:SetStackSize(1)
                if isCacheValidItem then
                    validItemStacks[itemID] = resStack
                    validItemCount = validItemCount + 1
                else
                    invalidItemStacks[itemID] = resStack
                    invalidItemCount = invalidItemCount + 1
                end
                self._recipeCacheItemData[itemID] = {
                    itemStack = resStack,
                    validRecipeIDs = {},
                    invalidRecipeIDs = {}
                }
            end
            if isCacheValidItem then
                table.insert(self._recipeCacheItemData[itemID].validRecipeIDs, recipeID)
            else
                table.insert(self._recipeCacheItemData[itemID].invalidRecipeIDs, recipeID)
            end
        end
        for _, recipeID in pairs(validRecipeIDs) do
            doCacheData(recipeID, true)
        end
        for _, recipeID in pairs(invalidRecipeIDs) do
            doCacheData(recipeID, false)
        end

        self._recipeShowInventory:SetSlotCount(validItemCount + invalidItemCount)
        local index = 0
        for _, itemStack in pairs(validItemStacks) do
            self._recipeShowInventory:GetSlot(index):PushStack(itemStack)
            index = index + 1
        end
        self._recipeShowInventory:Sort(0, validItemCount)
        for _, itemStack in pairs(invalidItemStacks) do
            self._recipeShowInventory:GetSlot(index):PushStack(itemStack)
            index = index + 1
        end
        self._recipeShowInventory:Sort(validItemCount, invalidItemCount)

        self._validItemCount = validItemCount
        self._invalidItemCount = invalidItemCount
        self._totalItemCount = self._validItemCount + self._invalidItemCount
        --self._recipeShowInventory:Sort(0, self._totalItemCount)

        if #self._onRecipeShowChangedListener == 2 then
            local caller = self._onRecipeShowChangedListener[2]
            local callback = self._onRecipeShowChangedListener[1]
            callback(caller)
        end

        print("Valid:", validItemCount, "Invalid:", invalidItemCount)
    end
end

return RecipeBookUI