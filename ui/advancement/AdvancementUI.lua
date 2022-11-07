---@class TC.AdvancementUI:GuiContainer
local AdvancementUI = class("AdvancementUI", GuiContainer)
local UIUtil = require("ui.UIUtil")
local UISlotOp = require("ui.UISlotOp")
local UIData = require("AdvancementUIData")
local HotkeyUIHelper = require("ui.HotkeyUIHelper")
local GuiID = require("ui.GuiID")
local SettingsData = require("settings.SettingsData")

---@param container TC.AdvancementContainerClient
function AdvancementUI:__init(container)
    AdvancementUI.super.__init(self, container)

    self.ui = require("ui.UIWindow").new(require("ui.UIDesign").getAdvancementUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self.currentContainer = container
    self._hkHelper = HotkeyUIHelper.new(Mod.current, GuiID.Advancement)
    self:_initContent()
end

function AdvancementUI:DoClose()
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player ~= nil and player:IsGuiOpened(Mod.current, GuiID.Advancement) then
        player:CloseGui(Mod.current, GuiID.Advancement)
    end
end

function AdvancementUI:_initContent()
    local scrollPanel = UIScrollView.cast(self.ui.root:getChild("scroll"))
    local basePanel = scrollPanel:getChild("panel")
    local panelOffsetX = 100
    local panelOffsetY = 100
    local originalWidth = scrollPanel.width
    local originalHeight = scrollPanel.height

    self.ui.root:getChild("btn_ok"):addTouchUpListener({ function(self)
        self:DoClose()
    end, self })

    local tree = self.currentContainer.tree
    local inWidth = panelOffsetX * 2 + tree.width
    local inHeight = panelOffsetY * 2 + tree.height

    if inWidth < originalWidth then
        panelOffsetX = math.ceil((originalWidth - tree.width) / 2)
        inWidth = originalWidth
    end

    if inHeight < originalHeight then
        panelOffsetY = math.ceil((originalHeight - tree.height) / 2)
        inHeight = originalHeight
    end

    basePanel:setSize(inWidth, inHeight)
    scrollPanel.viewSize = basePanel.size

    local lineColors = {
        [UIData.FINISH] = Color.new(90, 90, 90),
        [UIData.UNLOCK] = Color.new(70, 70, 70),
        [UIData.NEXT_UNLOCK] = Color.new(50, 50, 50),
        [UIData.FULL_LOCK] = Color.new(30, 30, 30),
    }
    local cellColors = {
        [UIData.FINISH] = Color.White,
        [UIData.UNLOCK] = Color.new(128, 128, 128),
        [UIData.NEXT_UNLOCK] = Color.new(64, 64, 64),
        [UIData.FULL_LOCK] = Color.new(32, 32, 32),
    }

    ---@param node TC.AdvancementTreeNode
    local function _DFSLine(node)
        if #node.children > 0 then
            local area = node.cellArea
            local lineColor = lineColors[node.displayState]
            local parentCenterX = area.centerX
            local parentCenterY = area.centerY
            local lineSize = 4
            local lineExtentHeight = UIData.LEVEL_OFFSET / 2
            local lineExtentY = parentCenterY + lineExtentHeight

            local lineParentDown = UIUtil.createImage("img_line",
                    panelOffsetX + parentCenterX - lineSize / 2, panelOffsetY + parentCenterY, lineSize, lineExtentHeight, {
                        sprite = {
                            name = "tc:white",
                            color = lineColor
                        }
                    })
            basePanel:addChild(lineParentDown)

            local lineExternMinX
            local lineExternMaxX
            for _, child in ipairs(node.children) do
                local childArea = child.cellArea
                local childCenterX = childArea.centerX
                local lineChildDown = UIUtil.createImage("img_line",
                        panelOffsetX + childCenterX - lineSize / 2, panelOffsetY + lineExtentY, lineSize, lineExtentHeight, {
                            sprite = {
                                name = "tc:white",
                                color = lineColor
                            }
                        })
                basePanel:addChild(lineChildDown)
                if lineExternMinX == nil then
                    lineExternMinX = childCenterX
                    lineExternMaxX = childCenterX
                else
                    lineExternMinX = math.min(lineExternMinX, childCenterX)
                    lineExternMaxX = math.max(lineExternMaxX, childCenterX)
                end
            end

            if lineExternMinX ~= nil and lineExternMinX < lineExternMaxX then
                local externWidth = lineExternMaxX - lineExternMinX
                local lineExtern = UIUtil.createImage("img_line",
                        panelOffsetX + lineExternMinX, panelOffsetY + lineExtentY - lineSize / 2, externWidth, lineSize, {
                            sprite = {
                                name = "tc:white",
                                color = lineColor
                            }
                        })
                basePanel:addChild(lineExtern)
            end
        end
        for _, child in ipairs(node.children) do
            _DFSLine(child)
        end
    end

    ---@param node TC.AdvancementTreeNode
    local function _DFSCell(node)
        local area = node.cellArea
        local cellColor = cellColors[node.displayState]

        local cell = UIUtil.createImage("cell", panelOffsetX + area.x, panelOffsetY + area.y, area.width, area.height, {
            sprite = {
                name = "tc:advancement_cell",
                color = cellColor
            }
        })
        if node.itemStack ~= nil then
            cell:getPostDrawLayer(0):addListener({ UISlotOp.itemStackOnRenderWithShadow, node.itemStack })
        end

        if SettingsData.isMobileOperation then
            cell:addTouchUpListener({ AdvancementUI.OnClickCell, self, node })
        else
            cell:addMousePointedListener({ AdvancementUI.OnPointedInCell, self, node })
        end
        basePanel:addChild(cell)
        for _, child in ipairs(node.children) do
            _DFSCell(child)
        end
    end
    _DFSLine(tree.root)
    _DFSCell(tree.root)
end

---OnClickCell
---@param node TC.AdvancementTreeNode
---@param touch Touch
function AdvancementUI:OnClickCell(node, _, touch)
    self:UpdateTips(touch.position, node)
end

function AdvancementUI:OnPointedInCell(node, _)
    self:UpdateTips(Input.mouse.position, node)
end

function AdvancementUI:UpdateTips(position, node)
    local TipUI = require("ui.TipUI")
    local advancement = AdvancementUtils.Get(node.data)
    local name = LangUtils.AdvancementName(node.data)
    local desc = LangUtils.AdvancementDescription(node.data)

    local contentTable
    if node.displayState == UIData.FINISH then
        contentTable = {
            --"量子科技",
            --"<c=#55FF55FF>制造出一颗量子电池！</c>",
            name,
            "<c=#55FF55FF>" .. desc .. "</c>",
            "<c=#FFFF00FF>已得到！</c>",
        }
    elseif node.displayState == UIData.UNLOCK then
        contentTable = {
            --"量子科技",
            --"<c=#55FF55FF>制造出一颗量子电池！</c>",
            name,
            "<c=#55FF55FF>" .. desc .. "</c>",
        }
    elseif node.displayState == UIData.NEXT_UNLOCK then
        local parentName = advancement.parentID > 0 and LangUtils.AdvancementName(advancement.parentID) or ""
        contentTable = {
            --"量子发电机",
            --"<c=#55FF55FF>需要完成: 量子科技</c>",
            name,
            "<c=#55FF55FF>需要完成: " .. parentName .. "</c>",
        }
    else
        contentTable = {
            "???",
            "<c=#55FF55FF>未解锁</c>",
        }
    end

    if SettingsData.isMobileOperation then
        TipUI.generate(contentTable)
    else
        if TipUI.isShowing() then
            TipUI.changeNewContent(contentTable)
            TipUI.resetKeepTime()
        else
            TipUI.generate(contentTable, 2)
        end
    end
    TipUI.adaptPosition(position)
end

function AdvancementUI:OnClose()
    self._hkHelper:destroy()
    self.ui:closeWindow()
end

return AdvancementUI