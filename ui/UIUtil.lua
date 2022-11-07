---@class TC.UIUtil
local UIUtil = class("UIUtil")
local UIDefault = require("UIDefault")
local UISpritePool = require("UISpritePool").getInstance()
local UISlotOp = require("UISlotOp")

---
---@param btn UIButton
---@param infoTable table
function UIUtil.doInfoTableForButton(btn, infoTable)
    UIUtil.doInfoTable(btn, infoTable)
    if infoTable ~= nil then
        if infoTable.targetSprite ~= nil then
            if infoTable.targetSprite.name ~= nil then
                btn.targetSprite = UISpritePool:get(infoTable.targetSprite.name)
            end
            UIUtil.doInfoTableForSprite(btn.targetSprite, infoTable.targetSprite)
        end
    end
end

---createButton
---@param name string
---@param caption string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
---@return UIButton
function UIUtil.createButton(name, caption, x, y, width, height, infoTable)
    assert(x ~= nil)
    assert(y ~= nil)
    assert(width ~= nil)
    assert(height ~= nil)
    local btn = UIButton.new(name, x, y, width, height)

    btn.targetSprite = UISpritePool:get("tc:button_normal")
    btn.highlightedSprite = UISpritePool:get("tc:button_highlight")
    --btn.highlightedSprite.positionOffset.y = -3
    btn.selectedSprite = UISpritePool:get("tc:button_highlight")
    btn.pressedSprite = UISpritePool:get("tc:button_pressed")
    btn.pressedSprite.positionOffset.y = 2
    if caption ~= nil and caption ~= "" then
        local lb = UIText.new("lb_caption")
        lb.outlineSize = 1
        lb:setMarginEnabled(true, true, true, true)
        lb.horizontalOverflow = TextHorizontalOverflow.Overflow
        --lb:setAutoStretch(true,true)
        lb.text = caption
        lb.fontSize = UIDefault.FontSize
        lb.horizontalAlignment = TextAlignment.HCenter
        lb.verticalAlignment = TextAlignment.VCenter
        btn:addChild(lb)
    end
    UIUtil.doInfoTableForButton(btn, infoTable)
    return btn
end

---createButtonWithImage
---@param name string
---@param uiSpriteName string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
---@param imgInfoTable table
---@return UIButton
function UIUtil.createButtonWithImage(name, uiSpriteName, x, y, width, height, infoTable, imgInfoTable)
    local btn = UIUtil.createButton(name, nil, x, y, width, height, infoTable)

    local image = UIImage.new("img")
    image:setMarginEnabled(true, true, true, true)
    image.sprite = UISpritePool:get(uiSpriteName)
    image.touchable = false
    btn:addChild(image)

    if imgInfoTable ~= nil then
        UIUtil.doInfoTableForImage(image, imgInfoTable)
    end

    return btn
end

function UIUtil.setSlotStyle(slot, cellStyle)
    cellStyle = cellStyle or 1

    local targetSpriteName = "tc:cell_empty"
    local highlightedSpriteName = "tc:cell_selected"
    local selectedSpriteName = "tc:cell_selected"
    local pressedSpriteName = "tc:cell_selected"

    if cellStyle > 1 then
        local postFix = string.format("_%d", cellStyle)
        targetSpriteName = targetSpriteName .. postFix
        highlightedSpriteName = highlightedSpriteName .. postFix
        selectedSpriteName = selectedSpriteName .. postFix
        pressedSpriteName = pressedSpriteName .. postFix
    end

    local btn = UIButton.cast(slot)
    btn.targetSprite = UISpritePool:get(targetSpriteName)
    btn.highlightedSprite = UISpritePool:get(highlightedSpriteName)
    btn.selectedSprite = UISpritePool:get(selectedSpriteName)
    btn.pressedSprite = UISpritePool:get(pressedSpriteName)
end

function UIUtil.innerCreateSlot(name, x, y, width, height, iconName, cellStyle)
    width = width or UIDefault.CellSize
    height = height or UIDefault.CellSize
    local btn = UIButton.new(name, x, y, width, height)

    if iconName then
        local image = UIImage.new("img")
        image:setMarginEnabled(true, true, true, true)
        image.sprite = UISpritePool:get(iconName)
        image.sprite.color = Color.new(255, 255, 255, 128)
        image.touchable = false
        btn:addChild(image)
    end

    UIUtil.setSlotStyle(btn, cellStyle)

    return btn
end

function UIUtil.createSlot(name, x, y, width, height, iconName)
    return UIUtil.innerCreateSlot(name, x, y, width, height, iconName)
end

function UIUtil.createSlotStyle(name, x, y, width, height, style)
    return UIUtil.innerCreateSlot(name, x, y, width, height, nil, style)
end

---hookSlotView
---@param slotNode UINode
---@param itemSlot Slot
---@param isClickShowTip boolean
function UIUtil.hookSlotView(slotNode, itemSlot, isClickShowTip)
    if isClickShowTip == nil then
        isClickShowTip = true
    end
    slotNode:getPostDrawLayer(0):addListener({ UISlotOp.slotOnRender, itemSlot })
    slotNode:getPostDrawLayer(1):addListener({ UISlotOp.slotOnRenderNum, itemSlot })
    slotNode:getPostDrawLayer(1):addListener({ UISlotOp.slotOnRenderDurableBar, itemSlot })
    slotNode:addMousePointedListener({ UISlotOp.slotOnMousePointed, itemSlot })
    slotNode:addMousePointedEnterListener({ UISlotOp.slotOnMousePointedEnter, itemSlot })
    slotNode:addMousePointedLeaveListener({ UISlotOp.slotOnMousePointedLeave, itemSlot })
    if isClickShowTip then
        slotNode:addTouchDownListener({ UISlotOp.slotOnTouchShowTip, itemSlot })
    end
end

---hookSlot
---@param slotNode UINode
---@param guiContainer GuiContainer
---@param slotIndex int
function UIUtil.hookSlot(slotNode, guiContainer, slotIndex)
    local slot = guiContainer.container:GetSlot(slotIndex)
    slotNode.allowDoubleClick = true
    UIUtil.hookSlotView(slotNode, slot, false)
    slotNode:addTouchDownListener({ UISlotOp.slotOnTouchDown, guiContainer, guiContainer.container, slotIndex, slot })
    slotNode:addTouchDoubleDownListener({ UISlotOp.slotOnTouchDoubleDown, guiContainer.container, slotIndex, slot })
    slotNode:addTouchMoveListener({ UISlotOp.slotOnTouchMove, guiContainer.container, slotIndex, slot })
    slotNode:addTouchPointedMoveListener({ UISlotOp.slotOnTouchPointedMove, guiContainer.container, slotIndex, slot })
    slotNode:addTouchPointedUpListener({ UISlotOp.slotOnTouchPointedUp, guiContainer.container, slotIndex, slot })
    slotNode:addTouchUpAfterMoveListener({ UISlotOp.slotOnTouchUp, guiContainer.container, slotIndex, slot })
end

---doInfoTableForSprite
---@param uiSprite UISprite
---@param infoTable table
function UIUtil.doInfoTableForSprite(uiSprite, infoTable)
    if infoTable ~= nil then
        if infoTable.color ~= nil then
            uiSprite.color = infoTable.color
        end
        if infoTable.style ~= nil then
            uiSprite.style = infoTable.style
        end
    end
end

---doInfoTable
---@param uiNode UINode
---@param infoTable table
function UIUtil.doInfoTable(uiNode, infoTable)
    if infoTable ~= nil then
        if infoTable.anchorPoint ~= nil then
            uiNode:setAnchorPoint(infoTable.anchorPoint[1], infoTable.anchorPoint[2])
        end
        if infoTable.positionY ~= nil then
            uiNode.positionY = infoTable.positionY
        end
        if infoTable.positionX ~= nil then
            uiNode.positionX = infoTable.positionX
        end
        if infoTable.size ~= nil then
            uiNode.size = infoTable.size
        end
        if infoTable.touchable ~= nil then
            uiNode.touchable = infoTable.touchable
        end
        if infoTable.margins ~= nil then
            local autoStretchWidth = nil
            local autoStretchHeight = nil
            if infoTable.margins[5] ~= nil then
                autoStretchWidth = infoTable.margins[5]
            end
            if infoTable.margins[6] ~= nil then
                autoStretchHeight = infoTable.margins[6]
            end
            UIUtil.setMargins(uiNode, infoTable.margins[1], infoTable.margins[2],
                    infoTable.margins[3], infoTable.margins[4], autoStretchWidth, autoStretchHeight)
        end
        if infoTable.marginsLR ~= nil then
            local autoStretch = nil
            if infoTable.marginsLR[3] ~= nil then
                autoStretch = infoTable.marginsLR[3]
            end
            UIUtil.setMarginsLR(uiNode, infoTable.marginsLR[1], infoTable.marginsLR[2], autoStretch)
        end
        if infoTable.marginsTB ~= nil then
            local autoStretch = false
            if infoTable.marginsTB[3] ~= nil then
                autoStretch = infoTable.marginsTB[3]
            end
            UIUtil.setMarginsTB(uiNode, infoTable.marginsTB[1], infoTable.marginsTB[2], autoStretch)
        end
        if infoTable.visible ~= nil then
            uiNode.visible = infoTable.visible
        end
    end
end

---doInfoTableForImage
---@param img UIImage
---@param infoTable table
function UIUtil.doInfoTableForImage(img, infoTable)
    UIUtil.doInfoTable(img, infoTable)
    if infoTable ~= nil then
        if infoTable.sprite ~= nil then
            if infoTable.sprite.name ~= nil then
                img.sprite = UISpritePool:get(infoTable.sprite.name)
            end
            UIUtil.doInfoTableForSprite(img.sprite, infoTable.sprite)
        end
    end
end
---@param panel UIPanel
---@param infoTable table
function UIUtil.doInfoTableForPanel(panel, infoTable)
    UIUtil.doInfoTable(panel, infoTable)
    if infoTable ~= nil then
        if infoTable.sprite ~= nil then
            if infoTable.sprite.name ~= nil then
                panel.sprite = UISpritePool:get(infoTable.sprite.name)
            end
            UIUtil.doInfoTableForSprite(panel.sprite, infoTable.sprite)
        end
    end
end

---createImage
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
function UIUtil.createImage(name, x, y, width, height, infoTable)
    local img = UIImage.new(name, x, y, width, height)
    UIUtil.doInfoTableForImage(img, infoTable)
    return img
end

---createImage
---@param name string
---@param infoTable table
function UIUtil.createImageNoPos(name, infoTable)
    local img = UIImage.new(name)
    UIUtil.doInfoTableForImage(img, infoTable)
    return img
end

---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
---@return UIPanel
function UIUtil.createPanel(name, x, y, width, height, infoTable)
    local panel = UIPanel.new(name, x, y, width, height)
    UIUtil.doInfoTableForPanel(panel, infoTable)
    return panel
end
---@param name string
---@param infoTable table
---@return UIPanel
function UIUtil.createPanelNoPos(name, infoTable)
    local panel = UIPanel.new(name)
    UIUtil.doInfoTableForPanel(panel, infoTable)
    return panel
end

---doInfoTableForSlider
---@param lb UISlider
---@param infoTable table
function UIUtil.doInfoTableForSlider(slider, infoTable)
    UIUtil.doInfoTable(slider, infoTable)
    if infoTable ~= nil then

    end
end

---createSlider
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
function UIUtil.createSlider(name, x, y, width, height, infoTable)
    local slider = UISlider.new(name, x, y, width, height)
    slider.barSprite = UISpritePool:get("tc:round_rect_white")
    slider.barSprite.color = Color.new(20, 20, 30)
    slider.activeBarSprite = UISpritePool:get("tc:round_rect_white")
    slider.activeBarSprite.color = Color.new(80, 80, 120)
    slider.sliderSprite = UISpritePool:get("tc:white_circle")
    slider.sliderSize = Size.new(24, 24)
    slider.sliderSprite.color = Color.new(140, 140, 180)
    UIUtil.doInfoTableForSlider(slider, infoTable)
    return slider
end

---doInfoTableForLabel
---@param lb UIText
---@param infoTable table
function UIUtil.doInfoTableForLabel(lb, infoTable)
    UIUtil.doInfoTable(lb, infoTable)
    if infoTable ~= nil then
        if infoTable.color ~= nil then
            lb.color = infoTable.color
        end
        if infoTable.fontSize ~= nil then
            lb.fontSize = infoTable.fontSize
        end
        if infoTable.isRichText ~= nil then
            lb.isRichText = infoTable.isRichText
        end
        if infoTable.autoAdaptSize ~= nil then
            lb.autoAdaptSize = infoTable.autoAdaptSize
        end
        if infoTable.horizontalOverflow ~= nil then
            lb.horizontalOverflow = infoTable.horizontalOverflow
        end
    end
end

---createLabel
---@param name string
---@param content string
---@param x number
---@param y number
---@param width number
---@param height number
---@param horizontalAlignment TextAlignment_Value
---@param verticalAlignment TextAlignment_Value
---@param infoTable table
---@return UIText
function UIUtil.createLabel(name, content, x, y, width, height, horizontalAlignment, verticalAlignment, infoTable)
    if horizontalAlignment == nil then
        horizontalAlignment = TextAlignment.Left
    end
    if verticalAlignment == nil then
        verticalAlignment = TextAlignment.Top
    end
    local lb = UIText.new(name, x, y, width, height)
    lb.outlineSize = 1
    lb.text = content
    lb.fontSize = UIDefault.FontSize
    lb.horizontalAlignment = horizontalAlignment
    lb.verticalAlignment = verticalAlignment
    lb.horizontalOverflow = TextHorizontalOverflow.Overflow
    UIUtil.doInfoTableForLabel(lb, infoTable)
    return lb
end

---createLabelNoPos
---@param name string
---@param content string
---@param horizontalAlignment TextAlignment_Value
---@param verticalAlignment TextAlignment_Value
---@param infoTable table
---@return UIText
function UIUtil.createLabelNoPos(name, content, horizontalAlignment, verticalAlignment, infoTable)
    local lb = UIUtil.createLabel(name, content, 0, 0, 32, 32,
            horizontalAlignment, verticalAlignment, infoTable)
    return lb
end

---
---@param panelList UIScrollView
---@param infoTable table
function UIUtil.doInfoTableForScrollView(panelList, infoTable)
    UIUtil.doInfoTable(panelList, infoTable)
    if infoTable ~= nil then
        if infoTable.sprite ~= nil then
            if infoTable.sprite.name ~= nil then
                panelList.sprite = UISpritePool:get(infoTable.sprite.name)
                UIUtil.doInfoTableForSprite(panelList.sprite, infoTable.sprite)
            end
        end
    end
end

---createScrollView
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
---@return UIScrollView
function UIUtil.createScrollView(name, x, y, width, height, infoTable)
    local panelList = UIScrollView.new(name, x, y, width, height)
    panelList.viewSize = Size.new(panelList.size.width, 600)
    UIUtil.doInfoTableForScrollView(panelList, infoTable)
    return panelList
end

---createScrollView
---@param name string
---@param infoTable table
function UIUtil.createScrollViewNoPos(name, infoTable)
    local panelList = UIScrollView.new(name)
    UIUtil.doInfoTableForScrollView(panelList, infoTable)
    panelList.viewSize = Size.new(panelList.size.width, 600)
    return panelList
end

---
---@param panel UIPanel
---@param infoTable table
function UIUtil.doInfoTableForPanel(panel, infoTable)
    UIUtil.doInfoTable(panel, infoTable)
    if infoTable ~= nil then
        if infoTable.sprite ~= nil then
            if infoTable.sprite.name ~= nil then
                panel.sprite = UISpritePool:get(infoTable.sprite.name)
                UIUtil.doInfoTableForSprite(panel.sprite, infoTable.sprite)
            end
        end
    end
end

---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
function UIUtil.createPanel(name, x, y, width, height, infoTable)
    local panel = UIPanel.new(name, x, y, width, height)
    UIUtil.doInfoTableForPanel(panel, infoTable)
    return panel
end

---
---@param sw UISwitch
---@param infoTable table
function UIUtil.doInfoTableForSwitch(sw, infoTable)
    UIUtil.doInfoTable(sw, infoTable)
    if infoTable ~= nil then
        if infoTable.selected ~= nil then
            sw:setSelected(infoTable.selected, false)
        end
    end
end

---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@param infoTable table
function UIUtil.createSwitch(name, x, y, width, height, infoTable)
    local sw = UISwitch.new(name, x, y, width, height)
    sw.offBackgroundSprite = UISpritePool:get("tc:round_rect_white")
    sw.offBackgroundSprite.color = Color.new(20, 20, 30)
    sw.onBackgroundSprite = UISpritePool:get("tc:round_rect_white")
    sw.onBackgroundSprite.color = Color.new(80, 80, 120)
    sw.offSliderSprite = UISpritePool:get("tc:white_circle")
    sw.offSliderSprite.color = Color.new(140, 140, 180)
    sw.fadeTime = 0.25
    sw.sliderSize = Size.new(24, 24)
    UIUtil.doInfoTableForSwitch(sw, infoTable)
    return sw
end

---setMargins
---@param node UINode
---@param left number
---@param top number
---@param right number
---@param bottom number
---@param autoStretchWidth boolean
---@param autoStretchHeight boolean
function UIUtil.setMargins(node, left, top, right, bottom, autoStretchWidth, autoStretchHeight)
    if left ~= nil then
        node:setLeftMargin(left, true)
    else
        node:setLeftMargin(0, false)
    end
    if top ~= nil then
        node:setTopMargin(top, true)
    else
        node:setTopMargin(0, false)
    end
    if right ~= nil then
        node:setRightMargin(right, true)
    else
        node:setRightMargin(0, false)
    end
    if bottom ~= nil then
        node:setBottomMargin(bottom, true)
    else
        node:setBottomMargin(0, false)
    end
    if autoStretchWidth == nil then
        if left ~= nil and right ~= nil then
            autoStretchWidth = true
        else
            autoStretchWidth = false
        end
    end
    if autoStretchHeight == nil then
        if top ~= nil and bottom ~= nil then
            autoStretchHeight = true
        else
            autoStretchHeight = false
        end
    end
    node.autoStretchWidth = autoStretchWidth
    node.autoStretchHeight = autoStretchHeight
end

---setMarginsLR
---@param node UINode
---@param left number
---@param right number
---@param autoStretch boolean
function UIUtil.setMarginsLR(node, left, right, autoStretch)
    UIUtil.setMargins(node, left, nil, right, nil, autoStretch, nil)
end

---setMarginsTB
---@param node UINode
---@param top number
---@param bottom number
---@param autoStretch boolean
function UIUtil.setMarginsTB(node, top, bottom, autoStretch)
    UIUtil.setMargins(node, nil, top, nil, bottom, nil, autoStretch)
end

---setTable
---@param panelList UINode
---@param proxy any
---@param isVertical boolean
---@param countPreLine number
---@return boolean
function UIUtil.setTable(panelList, proxy, isVertical, countPreLine)
    if not panelList:getChild("panel_item"):valid() then
        return false
    end
    isVertical = isVertical or true
    countPreLine = countPreLine or 1

    local sv = UIScrollView.cast(panelList)
    sv:ScrollToLeft()
    sv:ScrollToTop()

    local count = 0
    local panelItem = panelList:getChild("panel_item")
    panelItem.visible = false
    local lastCount = panelList:getChildrenCount()
    local childrenToRemoved = {}
    for i = 1, lastCount do
        local child = panelList:getChildByIndex(i - 1)
        if child.name ~= "panel_item" then
            table.insert(childrenToRemoved, child)
        end
    end
    ---@param child UINode
    for _, child in pairs(childrenToRemoved) do
        panelList:removeChild(child)
    end
    childrenToRemoved = {}

    if proxy._getTableElementCount == nil then
        count = 0
    else
        count = proxy:_getTableElementCount()
    end
    local offsetX = 0
    local offsetY = 0
    local maxX = 0
    local maxY = 0
    local indexPreLine = 1
    for i = 1, count do
        local itemName = string.format("panel_item_%d", i)
        local tempItem = panelList:getChild(itemName)
        local needCreate = false

        if tempItem:valid() then
            panelList:removeChild(tempItem)
            needCreate = true
        else
            needCreate = true
        end

        if needCreate then
            tempItem = panelItem:clone()
            tempItem.name = itemName
            panelList:addChild(tempItem, i)
        end
        tempItem:setAnchorPoint(0, 0)
        tempItem.visible = true
        if proxy._getTableElementSize ~= nil then
            local size = proxy:_getTableElementSize(i)
            if size ~= nil then
                tempItem.size = size
                tempItem:applyMargin()
            end
        end
        tempItem:setPosition(offsetX, offsetY)
        if proxy._setTableElement ~= nil then
            proxy:_setTableElement(tempItem, i)
        end
        local offsetWidth = tempItem.width
        local offsetHeight = tempItem.height
        if proxy._getTableElementPositionOffset ~= nil then
            local size = proxy:_getTableElementPositionOffset(i)
            offsetWidth, offsetHeight = size.width, size.height
        end
        maxX = tempItem.positionX + offsetWidth
        maxY = tempItem.positionY + offsetHeight
        if indexPreLine >= countPreLine then
            indexPreLine = 1
            if isVertical then
                offsetY = offsetY + offsetHeight
                offsetX = 0
            else
                offsetX = offsetX + offsetWidth
                offsetY = 0
            end
        else
            indexPreLine = indexPreLine + 1
            if isVertical then
                offsetX = offsetX + offsetWidth
            else
                offsetY = offsetY + offsetHeight
            end
        end
    end
    maxX = math.max(maxX, sv.width)
    maxY = math.max(maxY, sv.height)
    sv.viewSize = Size.new(maxX, maxY)

    sv:ScrollToLeft()
    sv:ScrollToTop()

    return true
end

---getTableElement
---@param uiTable UIScrollView
---@param index number
function UIUtil.getTableElement(uiTable, index)
    return uiTable:getChildByTag(index)
end

---createBlackFullScreenLayer
---@param name string
---@return UIPanel
function UIUtil.createBlackFullScreenLayer(name)
    local cover = UIPanel.new(name)
    cover.size = GameWindow.displayResolution
    cover:setMarginEnabled(true, true, true, true)
    cover:setAutoStretch(true, true)
    cover.sprite = UISpritePool:get("tc:black")
    cover.sprite.color = Color.new(255, 255, 255, 192)
    return cover
end

---createWindowPattern
---@param root UINode
---@param windowSize Size
---@param cfgTable table
---@return UIPanel
function UIUtil.createWindowPattern(root, windowSize, cfgTable)
    local panel = UIPanel.new("layer", 0, 0, windowSize.width, windowSize.height)
    UIUtil.setMargins(panel, 0, 0, 0, 0, false, false)
    if root ~= nil then
        root:addChild(panel)
    end

    if cfgTable and cfgTable.style then
        if cfgTable.style == "Gray" then
            local bg = UIImage.new("bg")
            bg.sprite = UISpritePool:get("tc:base")
            UIUtil.setMargins(bg, 0, 0, 0, 0)
            panel:addChild(bg)
        end
    else
        local bg_frame = UIImage.new("bg_frame")
        bg_frame.sprite = UISpritePool:get("tc:window_frame_01")
        bg_frame.sprite.color = Color.new(255, 255, 255, 160)
        UIUtil.setMargins(bg_frame, 0, 0, 0, 0)
        panel:addChild(bg_frame)

        local bg = UIImage.new("bg")
        UIUtil.setMargins(bg, 2, 2, 2, 2)
        bg.sprite = UISpritePool:get("tc:window_bg_01")
        bg.sprite.style = UISpriteStyle.Filled
        bg.sprite.color = Color.new(255, 255, 255, 30)
        bg_frame:addChild(bg)
    end

    return panel
end

---renderProgress
---@param source string|TextureLocation
---@param pos Vector2
---@param steps int
---@param totalSteps int
---@param dirX int  L->R: 1  R->L: -1
---@param dirY int  T->B  1  B->T: -1
function UIUtil.renderProgress(source, pos, steps, totalSteps, dirX, dirY)
    if steps <= 0 or totalSteps <= 0 then
        return
    end
    if dirX == nil then
        dirX = 0
    end
    if dirY == nil then
        dirY = 0
    end
    if dirX == 0 and dirY == 0 then
        return
    end
    local texture
    if type(source) == 'string' then
        texture = UISpritePool:get(source).textureLocation
    else
        texture = source
    end
    local sourceRect = TextureManager.getSourceRect(texture)
    local sw = sourceRect.width
    local sh = sourceRect.height
    local offsetX = 0
    local offsetY = 0
    local rate = steps * 1.0 / totalSteps
    local rectCut

    if dirX ~= 0 then
        local pw = math.floor(sw * rate)
        if dirX > 0 then
            rectCut = Rect.new(0, 0, pw, sh)
        else
            offsetX = sw - pw
            rectCut = Rect.new(offsetX, 0, pw, sh)
        end
    else
        local ph = math.floor(sh * rate)
        if dirY > 0 then
            rectCut = Rect.new(0, 0, sw, ph)
        else
            offsetY = sh - ph
            rectCut = Rect.new(0, offsetY, sw, ph)
        end
    end
    local drawPos = Vector2.new(pos.x + offsetX, pos.y + offsetY)
    Sprite.draw(texture, drawPos, rectCut, Color.White)
end

return UIUtil