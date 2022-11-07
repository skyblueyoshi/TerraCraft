---@class TC.NeiUI:TC.UIWindow
local NeiUI = class("NeiUI", require("ui.UIWindow"))
local UIUtil = require("ui.UIUtil")
local UIDefault = require("ui.UIDefault")
local SettingsData = require("settings.SettingsData")
local RawHotkeyUIHelper = require("ui.RawHotkeyUIHelper")
local Locale = require("languages.Locale")

local ORE_DICTIONARY_FLUSH_TICKS = 40
local PREVIEW_INPUT_CNT_PRE_LINE = 3
local PREVIEW_OUTPUT_CNT_PRE_LINE = 1

---@class TC.NeiHistoryEntity
local NeiHistoryEntity = class("NeiHistoryEntity")

---__init
---@param itemStack ItemStack
---@param fromOutput boolean
---@param tabIndex int
---@param recipeIndexInTab int
function NeiHistoryEntity:__init(itemStack, fromOutput, tabIndex, recipeIndexInTab)
    self.itemStack = itemStack
    self.fromOutput = fromOutput
    self.tabIndex = tabIndex
    self.recipeIndexInTab = recipeIndexInTab
end

local NeiHistory = class("NeiHistory")
local MAX_HISTORY_SIZE = 100

function NeiHistory:__init()
    self._entities = {} ---@type TC.NeiHistoryEntity[]
end

---push
---@param entity TC.NeiHistoryEntity
function NeiHistory:push(entity)
    if #self._entities >= MAX_HISTORY_SIZE then
        table.remove(self._entities, 1)
    end
    table.insert(self._entities, entity)
end

function NeiHistory:pop()
    if #self._entities > 0 then
        return table.remove(self._entities, #self._entities)
    end
    return nil
end

---@class TC.SearchRequest
local SearchRequest = class("SearchRequest")

---__init
---@param itemStack ItemStack
---@param itemID int
---@param fromOutput boolean
function SearchRequest:__init(itemStack, itemID, fromOutput)
    self.itemStack = itemStack
    self.itemID = itemID
    self.fromOutput = fromOutput

    self._relateOreDictionaryIDs = ItemRegistry.GetItemByID(itemID).oreDictionaryIDs
end

---isSameRequest
---@param itemStack ItemStack
---@param fromOutput boolean
function SearchRequest:isSameRequest(itemStack, fromOutput)
    if fromOutput == self.fromOutput then
        if itemStack:GetItem().id == self.itemID then
            return true
        end
    end
    return false
end

function SearchRequest:_fixInputTypeAndID(type, id)
    if not self.fromOutput and type == RecipeInputSlotType.OreDictionary then
        for _, oreDictionaryID in each(self._relateOreDictionaryIDs) do
            if id == oreDictionaryID then
                return RecipeInputSlotType.Item, self.itemID
            end
        end
    end
    return type, id
end

---@class TC.PreviewRecipeData
local PreviewRecipeData = class("PreviewRecipeData")

---__init
---@param validInputCache table
---@param validOutputSlots Slot[]
function PreviewRecipeData:__init(validInputCache, validOutputSlots)
    self.validInputCache = validInputCache
    self.validOutputSlots = validOutputSlots
end

---@class TC.OreDictionaryRecord
local OreDictionaryRecord = class("OreDictionaryRecord")

function OreDictionaryRecord:__init(oreDictionaryID, stackSize, slotIndex)
    self.oreDictionaryID = oreDictionaryID
    self.stackSize = stackSize
    self.slotIndex = slotIndex
    self.cursor = 1
end

function OreDictionaryRecord:getCurrentItemID()
    local ids = ItemUtils.GetOreDictionaryItemIDs(self.oreDictionaryID)
    return ids[self.cursor]
end

function OreDictionaryRecord:nextCursor()
    local ids = ItemUtils.GetOreDictionaryItemIDs(self.oreDictionaryID)
    if self.cursor >= ids.count then
        self.cursor = 1
    else
        self.cursor = self.cursor + 1
    end
end

function NeiUI:__init()
    NeiUI.super.__init(self, require("ui.UIDesign").getNeiUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self._searchListInventory = Inventory.new(0)
    self._searchPanelCells = self.root:getChild("panel_search.panel_cells")
    self._searchBaseCell = self.root:getChild("panel_search.panel_cell")
    self._lbSearchListPage = UIText.cast(self.root:getChild("panel_search.lb_page"))
    self._baseInfoPanel = UIPanel.cast(self.root:getChild("layer"))
    self._tabsNode = UIPanel.cast(self._baseInfoPanel:getChild("panel_tabs"))
    self._baseTabNode = UIPanel.cast(self._baseInfoPanel:getChild("panel_tab"))
    self._previewPanelList = self._baseInfoPanel:getChild("panel_list")
    self._positionPanelDetail = UIPanel.cast(self._baseInfoPanel:getChild("panel_position_detail"))
    self._lbInfoTitle = UIText.cast(self._baseInfoPanel:getChild("lb_recipe_name"))
    self._panelDetail = UIPanel.cast(self._positionPanelDetail:getChild("panel_detail"))
    self._btnSearchMode = UIButton.cast(self.root:getChild("btn_search_mode"))
    self._btnBackHistory = UIButton.cast(self.root:getChild("btn_back_history"))

    self._dataProxy = require("NeiDataProxy").new()
    self._isCurrentSearchFromOutput = true

    self._oreDictionaryFlushTicks = ORE_DICTIONARY_FLUSH_TICKS
    self._isDisplayAll = true
    self._currentItemRootGroupID = 1
    self._displayLines = 1
    self._displayCntPreLine = 1
    self._displayCellCntPrePage = 1
    self._currentPageIndex = 0
    self._totalPageCnt = 1
    self._searchTotalDisplayCnt = 0
    self._history = NeiHistory.new()

    ---@type TC.SearchRequest
    self._currentSearchRequest = nil
    ---@type ItemStack
    self._nextSearchRequestStack = nil
    self._currentSearchData = {}
    self._tabRecipeConfigs = {}
    self._currentTabIndex = 0
    self._currentRecipeIndexInTab = 0
    self._tabCount = 0
    self._tabInventory = Inventory.new(0)
    self._detailData = nil

    self._previewInventory = Inventory.new(0)
    self._detailInventory = Inventory.new(0)
    self._previewOreDictionaryRecords = {}  ---@type TC.OreDictionaryRecord[]
    self._detailOreDictionaryRecords = {}  ---@type TC.OreDictionaryRecord[]
    ---@type UINode[]
    self._previewNodes = {}

    self._hkHelper = RawHotkeyUIHelper.new(self)
    self:_initContent()
end

function NeiUI:_initContent()
    self._baseInfoPanel.visible = false
    self._baseTabNode.visible = false
    self._searchBaseCell.visible = false
    self.root:addTouchUpListener({ function(self)
        self:closeWindow()
    end, self })

    self._btnSearchMode.visible = SettingsData.isMobileOperation
    self._btnSearchMode:addTouchUpListener({ NeiUI._onSearchModeBtnClicked, self })
    self._btnBackHistory:addTouchUpListener({ NeiUI._onBackHistoryClicked, self })
    self:initUpdateFunc({ NeiUI._onUpdateTick, self })

    self.root:getChild("panel_search.btn_next"):addTouchUpListener({ NeiUI._onSearchListNextPageClicked, self })
    self.root:getChild("panel_search.btn_prev"):addTouchUpListener({ NeiUI._onSearchListPrevPageClicked, self })

    self:_refreshSearchListData()
end

function NeiUI:_onUpdateTick()

    if self._oreDictionaryFlushTicks > 0 then
        self._oreDictionaryFlushTicks = self._oreDictionaryFlushTicks - 1
    end

    if self._oreDictionaryFlushTicks == 0 then
        self._oreDictionaryFlushTicks = ORE_DICTIONARY_FLUSH_TICKS

        self:flushOreDictionaryItems(self._previewOreDictionaryRecords, self._previewInventory)
        self:flushOreDictionaryItems(self._detailOreDictionaryRecords, self._detailInventory)
    end

    if self._detailData ~= nil and self._detailData.onUpdateTick ~= nil then
        self._detailData:onUpdateTick()
    end

    if self._nextSearchRequestStack ~= nil then
        local stack = self._nextSearchRequestStack
        self._nextSearchRequestStack = nil
        self:_checkPCSearchOperation()
        self:_trySearch(stack, self._isCurrentSearchFromOutput, true)
    end
end

function NeiUI:_onBackHistoryClicked()
    local historyEntity = self._history:pop()
    if historyEntity == nil then
        return
    end
    self:_trySearch(historyEntity.itemStack, historyEntity.fromOutput, false)
    self:_onInfoTabClicked(historyEntity.tabIndex)
    self:_onPreviewItemClicked(historyEntity.recipeIndexInTab)
    self.manager:playClickSound()
end

function NeiUI:flushOreDictionaryItems(records, inventory)
    for _, record in ipairs(records) do
        record:nextCursor()
        local slot = inventory:GetSlot(record.slotIndex)

        local itemID = record:getCurrentItemID()
        local stack = ItemStack.new(ItemRegistry.GetItemByID(itemID), record.stackSize)
        slot:PushStack(stack)
    end
end

---_initInputSlot
---@param node UINode
---@param records TC.OreDictionaryRecord[]
---@param inventory Inventory
---@param slotIndex int
---@param type int
---@param id int
---@param stackSize int
function NeiUI:_initInputSlot(node, records, inventory, slotIndex, type, id, stackSize)
    local slot = inventory:GetSlot(slotIndex)
    if type == RecipeInputSlotType.Empty then
        slot:ClearStack()
    else
        local itemID
        if type == RecipeInputSlotType.OreDictionary then
            local record = OreDictionaryRecord.new(id, stackSize, slotIndex)
            table.insert(records, record)
            itemID = record:getCurrentItemID()
        else
            itemID = id
        end
        local stack = ItemStack.new(ItemRegistry.GetItemByID(itemID), stackSize)
        slot:PushStack(stack)
    end
    UIUtil.hookSlotView(node, slot, true)
    node:addTouchUpListener({ NeiUI._onDetailCellClicked, self, slot })
end

---_initOutputSlot
---@param node UINode
---@param slot Slot
function NeiUI:_initOutputSlot(node, slot)
    UIUtil.hookSlotView(node, slot, true)
    node:addTouchUpListener({ NeiUI._onDetailCellClicked, self, slot })
end

---_onDetailCellClicked
---@param slot Slot
function NeiUI:_onDetailCellClicked(slot)
    if slot.hasStack then
        self.manager:playClickSound()
        self._nextSearchRequestStack = slot:GetStack()
    end
end

function NeiUI:_onSearchModeBtnClicked()
    self.manager:playClickSound()
    self._isCurrentSearchFromOutput = not self._isCurrentSearchFromOutput
    local name
    if self._isCurrentSearchFromOutput then
        name = Locale.SEARCH_FROM_OUTPUT
    else
        name = Locale.SEARCH_FROM_INPUT
    end
    UIText.cast(self._btnSearchMode:getChild("lb_caption")).text = name
end

function NeiUI:_checkPCSearchOperation()
    if not SettingsData.isMobileOperation then
        self._isCurrentSearchFromOutput = not Input.mouse.isRightButtonInstantUp
    end
end

function NeiUI:_onSearchListNextPageClicked()
    self.manager:playClickSound()
    self._currentPageIndex = self._currentPageIndex + 1
    if self._currentPageIndex >= self._totalPageCnt then
        self._currentPageIndex = 0
    end
    self:_resetSearchListUI()
end

function NeiUI:_onSearchListPrevPageClicked()
    self.manager:playClickSound()
    if self._currentPageIndex == 0 then
        self._currentPageIndex = self._totalPageCnt - 1
    else
        self._currentPageIndex = self._currentPageIndex - 1
    end
    self:_resetSearchListUI()
end

function NeiUI:_refreshSearchListData()

    local width, height = self._searchPanelCells.width, self._searchPanelCells.height
    local cellWidth, cellHeight = self._searchBaseCell.width, self._searchBaseCell.height
    self._displayCntPreLine = math.max(1, math.floor(width / cellWidth))
    self._displayLines = math.max(1, math.floor(height / cellHeight))
    self._displayCellCntPrePage = self._displayLines * self._displayCntPreLine

    local groupIDs = ItemUtils.GetGroupIDsFromRootID(self._currentItemRootGroupID)
    self._searchTotalDisplayCnt = 0
    for _, groupID in each(groupIDs) do
        self._searchTotalDisplayCnt = self._searchTotalDisplayCnt + ItemUtils.GetGroupItemIDs(groupID).count
    end
    self._searchListInventory:SetSlotCount(self._searchTotalDisplayCnt)
    local index = 0
    for _, groupID in each(groupIDs) do
        local itemIDs = ItemUtils.GetGroupItemIDs(groupID)
        for _, itemID in each(itemIDs) do
            local item = ItemRegistry.GetItemByID(itemID)
            self._searchListInventory:GetSlot(index):PushStack(ItemStack.new(item))
            index = index + 1
        end
    end
    self._totalPageCnt = math.ceil(self._searchTotalDisplayCnt / self._displayCellCntPrePage)
    self._currentPageIndex = 0

    print("Total:", self._searchTotalDisplayCnt, "Pages:", self._totalPageCnt)

    self:_resetSearchListUI()
end

function NeiUI:_resetSearchListUI()
    local cellWidth, cellHeight = self._searchBaseCell.width, self._searchBaseCell.height

    self._searchPanelCells:removeAllChildren()

    local itemSlotIndexStart = self._currentPageIndex * self._displayCellCntPrePage
    for index = 0, self._displayCellCntPrePage - 1 do
        local slotIndex = itemSlotIndexStart + index
        if slotIndex >= self._searchTotalDisplayCnt then
            break
        end
        local slot = self._searchListInventory:GetSlot(slotIndex)
        node = self._searchBaseCell:clone()
        node.name = string.format("cell_%d", index)
        self._searchPanelCells:addChild(node, index)

        node.visible = true
        local xi = index % self._displayCntPreLine
        local yi = math.floor(index / self._displayCntPreLine)
        node:setPosition(xi * cellWidth, yi * cellHeight)

        UIUtil.hookSlotView(node, slot)
        node:addTouchUpListener({ NeiUI._onSearchCellClicked, self, slotIndex })
    end

    self._lbSearchListPage.text = string.format("%d/%d", self._currentPageIndex + 1, self._totalPageCnt)
end

function NeiUI:_onSearchCellClicked(slotIndex)
    if slotIndex >= self._searchListInventory.slotCount then
        return
    end
    local slot = self._searchListInventory:GetSlot(slotIndex)
    if not slot.hasStack then
        return
    end
    local stack = slot:GetStack()
    self:_checkPCSearchOperation()
    self:_trySearch(stack, self._isCurrentSearchFromOutput, true)
    self.manager:playClickSound()
end

function NeiUI:_resetInfoUI()
    if next(self._currentSearchData) == nil then
        self._baseInfoPanel.visible = false
        return
    end
    self._baseInfoPanel.visible = true
    self._tabRecipeConfigs = {}
    self._tabsNode:removeAllChildren()
    self._currentTabIndex = 0

    local tabIndex = 0
    for configID, _ in pairs(self._currentSearchData) do
        local tabNode = self._baseTabNode:clone()
        self._tabRecipeConfigs[tabIndex + 1] = configID
        self._tabsNode:addChild(tabNode, tabIndex)
        tabNode:setPosition(tabIndex * tabNode.width, 0)
        tabNode.visible = true

        tabNode:addTouchUpListener({ NeiUI._onInfoTabClicked, self, tabIndex })
        tabIndex = tabIndex + 1
    end
    self._tabCount = tabIndex

    self._tabInventory:SetSlotCount(self._tabCount)
    for i = 0, self._tabCount - 1 do
        local configID = self._tabRecipeConfigs[i + 1]
        local config = RecipeUtils.GetConfig(configID)

        if config.iconItemID > 0 then
            local tabNode = self._tabsNode:getChildByTag(i)
            local item = ItemRegistry.GetItemByID(config.iconItemID)
            local slot = self._tabInventory:GetSlot(i)
            slot:PushStack(ItemStack.new(item))
            UIUtil.hookSlotView(tabNode, slot, false)
        end
    end

    self:_resetTabState()
    self:_resetInfoPanel()
end

function NeiUI:_onInfoTabClicked(tabIndex)
    if tabIndex == self._currentTabIndex then
        return
    end
    self.manager:playClickSound()
    self._currentTabIndex = tabIndex
    self:_resetTabState()
    self:_resetInfoPanel()
end

function NeiUI:_resetTabState()
    local UISpritePool = require("ui.UISpritePool")
    for i = 0, self._tabCount - 1 do
        local tabNode = UIPanel.cast(self._tabsNode:getChildByTag(i))
        local spriteName = "tc:tab"
        if i == self._currentTabIndex then
            spriteName = "tc:tab_clicked"
        end
        tabNode.sprite = UISpritePool.getInstance():get(spriteName)
    end
end

function NeiUI:_resetInfoPanel()
    local configID = self._tabRecipeConfigs[self._currentTabIndex + 1]
    local recipeIDs = self._currentSearchData[configID]
    local recipeCount = #recipeIDs
    ---@type TC.PreviewRecipeData[]
    local previews = {}
    for _, recipeID in ipairs(recipeIDs) do
        table.insert(previews, self:_getPreviewRecipeData(recipeID))
    end

    local totalSlotCount = 0
    for _, preview in ipairs(previews) do
        totalSlotCount = totalSlotCount + #preview.validInputCache
    end
    self._previewInventory:SetSlotCount(totalSlotCount)
    self._previewOreDictionaryRecords = {}
    self._currentRecipeIndexInTab = 0
    self._previewNodes = {}

    ---@param preview TC.PreviewRecipeData
    local function _getPreviewLineData(preview)
        local inputLines = math.ceil(#preview.validInputCache / PREVIEW_INPUT_CNT_PRE_LINE)
        local outputLines = math.ceil(#preview.validOutputSlots / PREVIEW_OUTPUT_CNT_PRE_LINE)
        local maxLines = math.max(inputLines, outputLines)
        return inputLines, outputLines, maxLines
    end

    local slotCursor = 0
    local proxy = {
        _getTableElementCount = function()
            return recipeCount
        end,
        _getTableElementSize = function(_, index)
            local _, _, maxLines = _getPreviewLineData(previews[index])

            local height = 16 + maxLines * UIDefault.CellSize
            return Size.new(self._previewPanelList.width, height)
        end,
        _setTableElement = function(_, node, index)
            local preview = previews[index]
            local inputLines, outputLines, maxLines = _getPreviewLineData(preview)

            local inputX = 8
            local outputX = inputX + (PREVIEW_INPUT_CNT_PRE_LINE + 1) * UIDefault.CellSize
            local inputY = 8 + (maxLines - inputLines) * UIDefault.CellSize / 2
            local outputY = 8 + (maxLines - outputLines) * UIDefault.CellSize / 2

            ---@type UINode
            local baseCellNode = node:getChild("panel_preview_cell")
            baseCellNode.visible = false

            ---@type UINode
            local imgArrow = node:getChild("img_arrow")
            imgArrow:setPosition(
                    inputX + PREVIEW_INPUT_CNT_PRE_LINE * UIDefault.CellSize + (UIDefault.CellSize - 32) / 2,
                    (node.height - 24) / 2
            )

            for i, cache in ipairs(preview.validInputCache) do
                local cellNode = baseCellNode:clone()
                cellNode.visible = true
                node:addChild(cellNode)
                cellNode:setPosition(
                        inputX + ((i - 1) % PREVIEW_INPUT_CNT_PRE_LINE) * UIDefault.CellSize,
                        inputY + math.floor((i - 1) / PREVIEW_INPUT_CNT_PRE_LINE) * UIDefault.CellSize
                )
                cellNode.touchable = false
                local type, id, stackSize = cache[1], cache[2], cache[3]
                self:_initInputSlot(cellNode, self._previewOreDictionaryRecords, self._previewInventory, slotCursor, type, id, stackSize)

                slotCursor = slotCursor + 1
            end

            for i, e in ipairs(preview.validOutputSlots) do
                local cellNode = baseCellNode:clone()
                cellNode.visible = true
                node:addChild(cellNode)

                cellNode:setPosition(
                        outputX + ((i - 1) % PREVIEW_OUTPUT_CNT_PRE_LINE) * UIDefault.CellSize,
                        outputY + math.floor((i - 1) / PREVIEW_OUTPUT_CNT_PRE_LINE) * UIDefault.CellSize
                )
                cellNode.touchable = false
                self:_initOutputSlot(cellNode, e)
            end
            node:addTouchUpListener({ NeiUI._onPreviewItemClicked, self, index })
            table.insert(self._previewNodes, node)
        end
    }
    UIUtil.setTable(self._previewPanelList, proxy, true, 1)
    self:_setDetailPanel(1)
end

function NeiUI:_resetPreviewBg(index)
    local UISpritePool = require("ui.UISpritePool")
    for i, node in ipairs(self._previewNodes) do
        local panel = UIPanel.cast(node)
        local spriteName
        if i == index then
            spriteName = "tc:base_list_cell_highlight"
        else
            spriteName = "tc:base_list_cell"
        end
        panel.sprite = UISpritePool.getInstance():get(spriteName)
    end
end

function NeiUI:_onPreviewItemClicked(index)
    if index == self._currentRecipeIndexInTab then
        return
    end
    self.manager:playClickSound()
    self:_setDetailPanel(index)
end

function NeiUI:_setDetailPanel(index)
    if index == self._currentRecipeIndexInTab then
        return
    end
    local configID = self._tabRecipeConfigs[self._currentTabIndex + 1]
    local recipeIDs = self._currentSearchData[configID]
    if index > #recipeIDs then
        return
    end
    self:_resetPreviewBg(index)
    self._currentRecipeIndexInTab = index
    local recipeID = recipeIDs[index]

    local config = RecipeUtils.GetConfig(configID)
    local recipe = RecipeUtils.GetRecipe(recipeID)

    local data = self._dataProxy:getData(configID)
    self._detailData = data

    self._panelDetail:removeAllChildren()
    self._detailOreDictionaryRecords = {}

    if data.getPanelSize == nil then
        self._panelDetail:setSize(self._positionPanelDetail.width, self._positionPanelDetail.height)
    else
        self._panelDetail.size = data:getPanelSize()
    end
    self._panelDetail:applyMargin(false)

    if data.getTitle == nil then
        self._lbInfoTitle.text = ""
    else
        self._lbInfoTitle.text = data:getTitle()
    end

    data:createUI(self._panelDetail, recipeID)

    local inputs = recipe.inputs
    local outputs = recipe.outputs

    self._detailInventory:SetSlotCount(config.inputCount + config.outputCount)

    local slotIndex = 0
    for i = 0, config.inputCount - 1 do
        local node = self._panelDetail:getChildByTag(i)
        if node:valid() then
            local e = inputs[i + 1]
            local type, id = self._currentSearchRequest:_fixInputTypeAndID(e.type, e.id)
            self:_initInputSlot(node, self._detailOreDictionaryRecords, self._detailInventory, slotIndex, type, id, e.stackSize)
        end
        slotIndex = slotIndex + 1
    end
    for i = 0, config.outputCount - 1 do
        local node = self._panelDetail:getChildByTag(config.inputCount + i)
        if node:valid() then
            local e = outputs[i + 1]
            self:_initOutputSlot(node, e)
        end
        slotIndex = slotIndex + 1
    end

end

function NeiUI:_getPreviewRecipeData(recipeID)
    local recipe = RecipeUtils.GetRecipe(recipeID)

    local inputCache = {}
    local outputValidCells = {}

    ---@param e RecipeInputSlot
    for _, e in each(recipe.inputs) do
        if e.type ~= RecipeInputSlotType.Empty then
            local type, id = self._currentSearchRequest:_fixInputTypeAndID(e.type, e.id)
            local isExistInCache = false
            for _, c in ipairs(inputCache) do
                if c[1] == type and c[2] == id then
                    c[3] = c[3] + e.stackSize
                    isExistInCache = true
                    break
                end
            end
            if not isExistInCache then
                table.insert(inputCache, { type, id, e.stackSize })
            end
        end
    end
    ---@param e Slot
    for _, e in each(recipe.outputs) do
        if e.hasStack then
            table.insert(outputValidCells, e)
        end
    end
    return PreviewRecipeData.new(inputCache, outputValidCells)
end

function NeiUI:trySearch(itemStack, fromOutput)
    self:_trySearch(itemStack, fromOutput, true)
end

---_trySearch
---@param itemStack ItemStack
---@param fromOutput boolean
---@param saveHistory boolean
function NeiUI:_trySearch(itemStack, fromOutput, saveHistory)
    if self._currentSearchRequest then
        if itemStack:GetItem().id == self._currentSearchRequest.itemID and fromOutput == self._currentSearchRequest.fromOutput then
            return
        end
    end
    local data = NeiUI.doSearch(itemStack, fromOutput)
    if next(data) == nil then
        return
    end
    if saveHistory and self._currentSearchRequest then
        local historyEntity = NeiHistoryEntity.new(
                self._currentSearchRequest.itemStack,
                self._currentSearchRequest.fromOutput,
                self._currentTabIndex,
                self._currentRecipeIndexInTab
        )
        self._history:push(historyEntity)
    end
    self._currentSearchRequest = SearchRequest.new(itemStack, itemStack:GetItem().id, fromOutput)
    self._currentSearchData = data
    self:_resetInfoUI()
end

function NeiUI.doSearch(itemStack, fromOutput)
    local res = {}
    local maxConfigID = Reg.MaxRecipeConfigID()
    for configID = 1, maxConfigID do
        local recipeIDs = NeiUI.doSearchByRecipeConfig(configID, itemStack, fromOutput)
        if #recipeIDs > 0 then
            res[configID] = recipeIDs
        end
    end
    return res
end

function NeiUI.doSearchByRecipeConfig(recipeConfigID, itemStack, fromOutput)
    if fromOutput then
        return RecipeUtils.SearchRecipeHasOutputItem(recipeConfigID, itemStack, 0)
    else
        return RecipeUtils.SearchRecipeHasInputItem(recipeConfigID, itemStack)
    end
end

function NeiUI:onWindowResize()
    NeiUI.super.onWindowResize(self)
    self:_refreshSearchListData()
end

function NeiUI:closeWindow()
    self._hkHelper:destroy()
    NeiUI.super.closeWindow(self)
end

return NeiUI