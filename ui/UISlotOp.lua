local UISlotOp = class("UISlotOp")
local MouseItemData = require("MouseItemData")
local SettingsData = require("settings.SettingsData")

local SLOT_TAG_SELECTING = -10000

---@param guiContainer any
---@param container Container
---@param slotIndex int
---@param slot Slot
---@param node UINode
---@param touch Touch
function UISlotOp.slotOnTouchDown(guiContainer, container, slotIndex, slot, node, touch)
    if SettingsData.isMobileOperation then
        -- Mobile
        UISlotOp.slotOnTouchShowTip(slot, node, touch)
    else
        -- PC
        local isLeftButtonPressed = Input.mouse.isLeftButtonPressed

        local mouseItemData = MouseItemData.getInstance()
        local mouseSlot = mouseItemData.slot
        if not mouseSlot.hasStack then
            -- Current: Mouse:[]
            if slot.hasStack then
                -- Current: Mouse:[]  Target:[item]
                if Input.keyboard:isKeyPressed(Keys.LeftShift) and guiContainer.checkSlotShiftMove ~= nil then
                    -- Pressing Shift

                    local targetContainer, targetIndexStart, targetCount = guiContainer:checkSlotShiftMove(slotIndex, slot:GetStack())
                    if targetContainer ~= nil then
                        local maxSlots = targetContainer:GetSlotCount()
                        local targetIndexEnd = math.min(maxSlots - 1, targetIndexStart + targetCount - 1)
                        for targetIndex = targetIndexStart, targetIndexEnd do
                            if not slot.hasStack then
                                break
                            end

                            ---@type Slot
                            local targetSlot = targetContainer:GetSlot(targetIndex)
                            if targetSlot.hasStack then
                                local fromStack = slot:GetStack()
                                local toStack = targetSlot:GetStack()
                                local merges = toStack:GetMergeCount(fromStack)
                                if merges > 0 then
                                    toStack:SetStackSize(toStack.stackSize + merges)
                                    slot:DecrStackSize(merges)
                                    container:CommandSlotMoveTo(container, slotIndex, targetContainer, targetIndex, merges)
                                end
                            end
                        end

                        if slot.hasStack then
                            for targetIndex = targetIndexStart, targetIndexEnd do
                                ---@type Slot
                                local targetSlot = targetContainer:GetSlot(targetIndex)
                                if not targetSlot.hasStack then
                                    targetSlot:SwapStack(slot)
                                    UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                                            targetContainer, targetIndex,
                                            container, slotIndex)
                                    break
                                end
                            end
                        end
                    end
                else
                    if isLeftButtonPressed then
                        mouseSlot:SwapStack(slot)
                        -- Current: Mouse:[item]  Target:[]
                        UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                                nil, -1,
                                container, slotIndex)
                    else
                        -- Get half of target slot items.
                        local pickOutNum = math.ceil(slot:GetStack().stackSize / 2.0)
                        if pickOutNum > 0 then
                            mouseSlot:PushStack(slot:GetStack():SplitStack(pickOutNum))
                            local checkEmpty = false
                            if slot:GetStack().stackSize == 0 then
                                slot:ClearStack()
                                checkEmpty = true
                            end
                            container:CommandEnsureSlotEmpty(nil, -1)
                            container:CommandSlotMoveTo(container, slotIndex,
                                    nil, -1,
                                    mouseSlot:GetStack().stackSize)
                            if checkEmpty then
                                container:CommandEnsureSlotEmpty(container, slotIndex)
                            end
                        end
                    end
                    mouseItemData.isPcCurrentPicking = true
                end
            else
                -- Current: Mouse:[]  Target:[]
                -- do nothing
            end
        else
            -- Current: Mouse:[item]
            if slot.hasStack then
                -- Current: Mouse:[item]  Target:[item]
                mouseSlot:SwapStack(slot)
                UISlotOp._EnsureSwapAndBothHasItem(container,
                            nil, -1,
                            container, slotIndex)
            else
                -- Current: Mouse:[item]  Target:[]
            end
            if isLeftButtonPressed then
                mouseItemData.pcIsAverageMode = true
            else
                mouseItemData.pcIsAverageMode = false
            end
        end
    end
end

---slotOnTouchDown
---@param container Container
---@param slotIndex int
---@param slot Slot
---@param touch Touch
---@param node UINode
function UISlotOp.slotOnTouchDoubleDown(container, slotIndex, slot, node, touch)
    if SettingsData.isMobileOperation then
        -- Mobile
        if slot.hasStack then
            local mouseItemData = MouseItemData.getInstance()
            local mouseSlot = mouseItemData.slot
            if not mouseSlot.hasStack then
                if slot:CanPick(slot:GetStack()) then
                    mouseSlot:PushStack(slot:GetStack():SplitStack(1))
                    if slot:GetStack().stackSize == 0 then
                        slot:ClearStack()
                    end
                    mouseItemData:startDragging(container, slotIndex)
                    mouseItemData.touchingPosition = touch.position
                    mouseItemData:startPicking()
                    SoundUtils.PlaySound(Reg.SoundID("pop"))
                end
            end
        end
    else
        -- PC
    end
end

function UISlotOp.slotOnMousePointed(slot, node)
    if not SettingsData.isMobileOperation then
        UISlotOp.ensureMousePointedShowTips(slot)
    end
end

function UISlotOp.ensureMousePointedShowTips(slot)
    local TipUI = require("TipUI")
    if slot.hasStack then
        local mouseItemData = MouseItemData.getInstance()
        mouseItemData:showTip(slot:GetStack(), Input.mouse.position, 4)
        mouseItemData:stopKeepingTip()
    end
end

function UISlotOp.slotOnMousePointedEnter(slot, node)
    if not SettingsData.isMobileOperation then
        -- PC
        UISlotOp.ensureMousePointedShowTips(slot)
    end
end

function UISlotOp.slotOnMousePointedLeave(slot, node)
    if not SettingsData.isMobileOperation then
        -- PC
    end
end

---slotOnTouchPointedMove
---@param container Container
---@param slotIndex int
---@param slot Slot
---@param node UINode
---@param touch Touch
---@param pos Vector2
function UISlotOp.slotOnTouchPointedMove(container, slotIndex, slot, node, touch, pos)
    local mouseItemData = MouseItemData.getInstance()
    if not SettingsData.isMobileOperation then
        -- PC
        if mouseItemData.isPcCurrentPicking then
            return
        end
        UISlotOp.addAndUpdateSelectingSlot(container, slotIndex, slot)
    end
end

function UISlotOp.isSlotSelecting(slot)
    return slot.tag < 0
end

---slotOnTouchMove
---@param container Container
---@param slotIndex int
---@param slot Slot
---@param node UINode
---@param touch Touch
---@param pos Vector2
function UISlotOp.slotOnTouchMove(container, slotIndex, slot, node, touch, pos)
    local mouseItemData = MouseItemData.getInstance()
    if SettingsData.isMobileOperation then
        -- Mobile
        local outOfCell = not (pos.x >= 0 and pos.y >= 0 and pos.x < node.width and pos.y < node.height)
        if outOfCell then
            if mouseItemData.pickingOneByOne then
                UISlotOp._stopMousePickingItem(container)
            end
            mouseItemData:closeTip()
        end
        if slot.hasStack then
            if outOfCell then
                local mouseSlot = mouseItemData.slot
                if not mouseSlot.hasStack then
                    -- Current: Mouse:[]  Target:[item]
                    if slot:CanPick(slot:GetStack()) then
                        -- touch is out of the origin slot, move the origin slot item to mouse item!
                        -- Do: Target:[item] --> Mouse:[]
                        mouseSlot:SwapStack(slot)
                        slot:OnPick(mouseSlot:GetStack())
                        -- Current: Mouse:[item]  Target:[]
                        UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                                nil, -1,
                                container, slotIndex)

                        mouseItemData:startDragging(container, slotIndex)
                        mouseItemData.touchingPosition = touch.position
                        mouseItemData:fixDisplayOffset()

                        SoundUtils.PlaySound(Reg.SoundID("pop"))
                    end
                end
            end
        end
        mouseItemData.touchingPosition = touch.position
    else
        -- PC
    end
end

---
---@param container Container
---@param slotIndex int
---@param slot Slot
---@param touch Touch
---@param node UINode
function UISlotOp.slotOnTouchPointedUp(container, slotIndex, slot, node, touch)
    local mouseItemData = MouseItemData.getInstance()
    local mouseSlot = mouseItemData.slot  ---@type Slot
    if SettingsData.isMobileOperation then
        -- Mobile
        local originSlot = mouseItemData.originSlot
        if mouseSlot.hasStack then
            -- Current: Mouse:[item]
            if mouseItemData.pickingOneByOne then
                UISlotOp._stopMousePickingItem(container)
            end
            if not slot.hasStack then
                -- Current: Mouse:[item]  Target:[]
                if slot:CanPush(mouseSlot:GetStack()) then
                    -- Do: Mouse:[item] --> Target:[]
                    slot:SwapStack(mouseSlot)
                    slot:OnPush(slot:GetStack())
                    -- Current: Mouse:[]  Target:[item]
                    UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                            container, slotIndex,
                            nil, -1)
                    SoundUtils.PlaySound(Reg.SoundID("pop"))
                else
                    -- Current: Mouse:[item]  Target:[]
                    UISlotOp._solveMouseItemSendBackToOriginSlot(container)
                end
            else
                -- Current: Mouse:[item]  Target:[item]
                if slot:CanPush(mouseSlot:GetStack()) then
                    local merges = slot:GetStack():GetMergeCount(mouseSlot:GetStack())
                    if merges > 0 then
                        -- same item type, do merge
                        -- Mouse:[item] --> Target:[item]
                        slot:GetStack():SetStackSize(slot:GetStack().stackSize + merges)
                        mouseSlot:DecrStackSize(merges)
                        slot:OnPush(slot:GetStack())
                        container:CommandSlotMoveTo(nil, -1,
                                container, slotIndex,
                                merges)
                        SoundUtils.PlaySound(Reg.SoundID("pop"))
                        if mouseSlot.hasStack then
                            -- Current: Mouse:[item]  Target:[item]
                            UISlotOp._solveMouseItemSendBackToOriginSlot(container)
                        else
                            -- Current: Mouse:[]  Target:[item]
                            container:CommandEnsureSlotHasItem(container, slotIndex, slot:GetStack())
                            container:CommandEnsureSlotEmpty(nil, -1)
                        end
                    else
                        if originSlot ~= nil then
                            -- not same item type, do swap
                            if not originSlot.hasStack then
                                -- Current: Mouse:[item]  Target:[item]  Origin:[]
                                if originSlot:CanPush(slot:GetStack()) and slot:CanPick(slot:GetStack()) and slot:CanPush(mouseSlot:GetStack()) then
                                    -- Do: Target:[item] --> Origin:[]
                                    originSlot:SwapStack(slot)
                                    SoundUtils.PlaySound(Reg.SoundID("pop"))
                                    originSlot:OnPush(originSlot:GetStack())
                                    slot:OnPick(originSlot:GetStack())
                                    -- Current: Mouse:[item]  Target:[]  Origin:[item]
                                    UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                                            mouseItemData.originContainer, mouseItemData.originSlotIndex,
                                            container, slotIndex)
                                    -- Do: Mouse:[item] --> Target:[]
                                    slot:SwapStack(mouseSlot)
                                    slot:OnPush(slot:GetStack())
                                    -- Current: Mouse:[]  Target:[item]  Origin:[item]
                                    UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                                            container, slotIndex,
                                            nil, -1)
                                else
                                    UISlotOp._solveMouseItemSendBackToOriginSlot(container)
                                end
                            else
                                -- Current: Mouse:[item]  Target:[item]  Origin:[item]
                                -- TODO
                            end
                        else
                            -- never happened, in case
                            mouseSlot:ClearStack()
                        end
                    end
                end
            end
        end
    else
        -- PC
        if mouseItemData.isPcCurrentPicking then
            return
        end
        UISlotOp.addAndUpdateSelectingSlot(container, slotIndex, slot)
    end
end

---slotOnTouchUp
---@param container Container
---@param slotIndex int
---@param slot Slot
---@param node UINode
---@param touch Touch
function UISlotOp.slotOnTouchUp(container, slotIndex, slot, node, touch)
    local mouseItemData = MouseItemData.getInstance()
    if SettingsData.isMobileOperation then
        -- Mobile
        if mouseItemData.slot.hasStack then
            if mouseItemData.pickingOneByOne then
                UISlotOp._stopMousePickingItem(container)
            end
            -- the mouse has item, send back to the origin slot
            UISlotOp._solveMouseItemSendBackToOriginSlot(container)
        end
        mouseItemData:stopDragging()
        mouseItemData:stopKeepingTip()
    else
        -- PC
        if not mouseItemData.isPcCurrentPicking then
            UISlotOp.sendAllSelectingSlots(container)
        end
        mouseItemData.isPcCurrentPicking = false
    end
end

---addAndUpdateSelectingSlot
---@param container Container
---@param slotIndex int
---@param slot Slot
function UISlotOp.addAndUpdateSelectingSlot(container, slotIndex, slot)
    -- processed
    if UISlotOp.isSlotSelecting(slot) then
        return
    end

    -- check mouse item exist
    local mouseItemData = MouseItemData.getInstance()
    local mouseSlot = mouseItemData.slot
    if not mouseSlot.hasStack then
        return
    end

    -- reach max size
    if #mouseItemData.pcSelectingSlots >= mouseSlot:GetStack().stackSize then
        return
    end

    -- cannot merge
    if slot.hasStack and slot:GetStack():GetMergeCount(mouseSlot:GetStack()) == 0 then
        return
    end

    UISlotOp.setSelectedNum(slot, 0)
    table.insert(mouseItemData.pcSelectingSlots, slot)
    table.insert(mouseItemData.pcSelectingContainerAndSlotIndices, { container, slotIndex })
    UISlotOp.updateSelectingSlots()
end

---sendAllSelectingSlots
---@param container Container
function UISlotOp.sendAllSelectingSlots(container)
    local mouseItemData = MouseItemData.getInstance()
    local mouseSlot = mouseItemData.slot

    ---@param slot Slot
    for i, slot in ipairs(mouseItemData.pcSelectingSlots) do
        if not mouseSlot.hasStack then
            break
        end
        local targetContainerAndIndex = mouseItemData.pcSelectingContainerAndSlotIndices[i]
        local appends = UISlotOp.getSelectedNum(slot)
        local actualMoves = 0
        if appends > 0 then
            local mouseStack = mouseSlot:GetStack()
            if not slot.hasStack then
                local outStack = mouseStack:SplitStack(appends)
                slot:PushStack(outStack)
                actualMoves = appends
                if mouseStack.stackSize == 0 then
                    mouseSlot:ClearStack()
                end
            else
                local stack = slot:GetStack()
                local merges = stack:GetMergeCount(mouseStack)
                local actualAppends = math.min(merges, appends)
                if actualAppends > 0 then
                    stack:SetStackSize(stack.stackSize + actualAppends)
                    mouseSlot:DecrStackSize(actualAppends)
                    actualMoves = actualAppends
                end
            end
        end
        if actualMoves > 0 then
            container:CommandSlotMoveTo(nil, -1,
                    targetContainerAndIndex[1], targetContainerAndIndex[2],
                    actualMoves
            )
        end
    end

    for _, slot in ipairs(mouseItemData.pcSelectingSlots) do
        UISlotOp.clearSelected(slot)
    end
    UISlotOp.clearSelected(mouseItemData.slot)

    mouseItemData.pcSelectingSlots = {}
    mouseItemData.pcSelectingContainerAndSlotIndices = {}
end

function UISlotOp.updateSelectingSlots()
    local mouseItemData = MouseItemData.getInstance()
    local mouseSlot = mouseItemData.slot

    if not mouseSlot.hasStack then
        return
    end
    local mouseStack = mouseSlot:GetStack()
    local mouseStackSize = mouseStack.stackSize

    local slots = mouseItemData.pcSelectingSlots
    local totalSlots = #slots

    if totalSlots == 0 then
        return
    end

    local everyAppends = 1
    local actualAppends = 0
    if mouseItemData.pcIsAverageMode then
        everyAppends = math.floor(mouseStackSize / totalSlots)
    end

    ---@param slot Slot
    for _, slot in ipairs(slots) do
        local actual = 0
        if not slot.hasStack then
            actual = everyAppends
        else
            actual = math.min(slot:GetStack():GetMergeCount(mouseStack), everyAppends)
        end
        UISlotOp.setSelectedNum(slot, actual)
        actualAppends = actualAppends + actual
    end

    UISlotOp.setSelectedNum(mouseSlot, mouseStackSize - actualAppends)
end

function UISlotOp.getSelectedNum(slot)
    return slot.tag - SLOT_TAG_SELECTING
end

function UISlotOp.setSelectedNum(slot, num)
    slot.tag = SLOT_TAG_SELECTING + num
end

function UISlotOp.clearSelected(slot)
    slot.tag = 0
end

function UISlotOp._GetCommandTargetItemStack(container, slotIndex)
    return slotIndex == -1 and MouseItemData.getInstance().slot:GetStack() or container:GetSlot(slotIndex):GetStack()
end

---EnsureSwapAndFirstHasItem
---@param container Container
---@param containerA Container
---@param slotIndexA int
---@param containerB Container
---@param slotIndexB int
function UISlotOp._EnsureSwapAndFirstHasItemOnly(container, containerA, slotIndexA, containerB, slotIndexB)
    container:CommandSwapSlot(containerA, slotIndexA, containerB, slotIndexB)
    container:CommandEnsureSlotHasItem(containerA, slotIndexA, UISlotOp._GetCommandTargetItemStack(containerA, slotIndexA))
    container:CommandEnsureSlotEmpty(containerB, slotIndexB)
end

---EnsureSwapAndBothHasItem
---@param container Container
---@param containerA Container
---@param slotIndexA int
---@param containerB Container
---@param slotIndexB int
function UISlotOp._EnsureSwapAndBothHasItem(container, containerA, slotIndexA, containerB, slotIndexB)
    container:CommandSwapSlot(containerA, slotIndexA, containerB, slotIndexB)
    container:CommandEnsureSlotHasItem(containerA, slotIndexA, UISlotOp._GetCommandTargetItemStack(containerA, slotIndexA))
    container:CommandEnsureSlotHasItem(containerB, slotIndexB, UISlotOp._GetCommandTargetItemStack(containerB, slotIndexB))
end

---stopMousePickingItem
---@param container Container
function UISlotOp._stopMousePickingItem(container)
    local mouseItemData = MouseItemData.getInstance()
    if mouseItemData.pickingOneByOne then
        local mouseSlot = mouseItemData.slot
        if mouseSlot.hasStack then
            container:CommandEnsureSlotEmpty(nil, -1)
            container:CommandSlotMoveTo(
                    mouseItemData.originContainer, mouseItemData.originSlotIndex,
                    nil, -1, mouseSlot:GetStack().stackSize)
            container:CommandEnsureSlotHasItem(
                    nil, -1, mouseSlot:GetStack())
            mouseItemData.originSlot:OnPick(mouseSlot:GetStack())
            if mouseItemData.originSlot.hasStack then
                -- Current: Mouse:[item]  Origin:[item]
                container:CommandEnsureSlotHasItem(
                        mouseItemData.originContainer, mouseItemData.originSlotIndex,
                        mouseItemData.originSlot:GetStack())
            else
                -- Current: Mouse:[item]  Origin:[]
                container:CommandEnsureSlotEmpty(mouseItemData.originContainer, mouseItemData.originSlotIndex)
            end
        end
        mouseItemData:stopPicking()
    end
end

---solveMouseItemSendBackToOriginSlot
---@param container Container
function UISlotOp._solveMouseItemSendBackToOriginSlot(container)
    local mouseItemData = MouseItemData.getInstance()
    local mouseSlot = mouseItemData.slot
    if mouseSlot.hasStack then
        local originSlot = mouseItemData.originSlot
        if originSlot ~= nil then
            -- mouse item left, send back to the origin slot
            container:CommandEnsureSlotHasItem(nil, -1, UISlotOp._GetCommandTargetItemStack(nil, -1))
            if not originSlot.hasStack then
                if originSlot:CanPush(mouseSlot:GetStack()) then
                    originSlot:SwapStack(mouseSlot)
                    originSlot:OnPush(originSlot:GetStack())

                    -- now the origin slot has item and mouse item is empty
                    UISlotOp._EnsureSwapAndFirstHasItemOnly(container,
                            mouseItemData.originContainer, mouseItemData.originSlotIndex,
                            nil, -1)
                    SoundUtils.PlaySound(Reg.SoundID("pop"))
                end
            else
                if originSlot:CanPush(mouseSlot:GetStack()) then
                    local merges = originSlot:GetStack():GetMergeCount(mouseSlot:GetStack())
                    if merges > 0 then
                        originSlot:GetStack():SetStackSize(originSlot:GetStack().stackSize + merges)
                        originSlot:OnPush(originSlot:GetStack())
                        mouseSlot:DecrStackSize(merges)
                        container:CommandSlotMoveTo(nil, -1,
                                mouseItemData.originContainer, mouseItemData.originSlotIndex,
                                merges)
                        SoundUtils.PlaySound(Reg.SoundID("pop"))
                    end
                end
            end
        else
            -- in case
            mouseSlot:ClearStack()
        end

        if mouseSlot.hasStack then
            -- TODO DROP OUT!
        end
    end
end

---slotOnTouchShowTip
---@param slot Slot
---@param node UINode
---@param touch Touch
function UISlotOp.slotOnTouchShowTip(slot, node, touch)
    if slot.hasStack then
        local mouseItemData = MouseItemData.getInstance()
        mouseItemData:showTip(slot:GetStack(), touch.position, 128)
        mouseItemData.touchingPosition = touch.position
        mouseItemData:stopKeepingTip()
    end
end

---
---@param stack ItemStack
---@param node UINode
---@param canvasPos Vector2
function UISlotOp.itemStackOnRenderWithShadow(stack, node, canvasPos)
    local SHADOW_OFFSET = 2
    local SHADOW_OFFSET_HALF = SHADOW_OFFSET / 2
    local pos = node.positionInCanvas + canvasPos +
            Vector2.new(node.width / 2 + SHADOW_OFFSET_HALF, node.height / 2 + SHADOW_OFFSET_HALF)
    local exData = SpriteExData.new()
    exData.origin = Vector2.new(16, 16)
    stack:Render(pos, Color.Black, exData)

    pos.x = pos.x - SHADOW_OFFSET
    pos.y = pos.y - SHADOW_OFFSET
    stack:Render(pos, Color.White, exData)
end

---
---@param stack ItemStack
---@param node UINode
---@param canvasPos Vector2
function UISlotOp.itemStackOnRender(stack, node, canvasPos)
    local pos = node.positionInCanvas + canvasPos + Vector2.new(node.width / 2, node.height / 2)
    local exData = SpriteExData.new()
    exData.origin = Vector2.new(16, 16)
    stack:Render(pos, Color.White, exData)
end

---slotOnRender
---@param slot Slot
---@param node UINode
---@param canvasPos Vector2
function UISlotOp.slotOnRender(slot, node, canvasPos)
    if slot.hasStack then
        UISlotOp.itemStackOnRender(slot:GetStack(), node, canvasPos)
    elseif slot.tag < 0 then
        local mouseItemData = MouseItemData.getInstance()
        local mouseSlot = mouseItemData.slot
        if mouseSlot.hasStack then
            UISlotOp.itemStackOnRender(mouseSlot:GetStack(), node, canvasPos)
        end
    end
end

---slotOnRenderNum
---@param slot Slot
---@param node UINode
---@param canvasPos Vector2
function UISlotOp.slotOnRenderNum(slot, node, canvasPos)
    if slot.hasStack or slot.tag < 0 then
        local stack
        local useCustomNum = slot.tag < 0
        if slot.hasStack then
            stack = slot:GetStack()
        else
            local mouseItemData = MouseItemData.getInstance()
            local mouseSlot = mouseItemData.slot
            if mouseSlot.hasStack then
                stack = mouseSlot:GetStack()
            end
        end
        if stack == nil then
            return
        end

        local pos = node.positionInCanvas + canvasPos + Vector2.new(node.width / 2, node.height / 2)
        local exData = SpriteExData.new()
        exData.origin = Vector2.new(16, 16)

        if useCustomNum then
            stack:RenderCustomNum(UISlotOp.getSelectedNum(slot), pos, Color.Yellow, exData)
        else
            stack:RenderNum(pos, Color.White, exData)
        end
    end
end

---@param slot Slot
---@param node UINode
---@param canvasPos Vector2
function UISlotOp.slotOnRenderDurableBar(slot, node, canvasPos)
    if not slot.hasStack then
        return
    end
    local stack = slot:GetStack()
    local item = stack:GetItem()
    if item.maxDurable <= 0 or stack.durable >= item.maxDurable then
        return
    end

    local rate = stack.durable * 1.0 / item.maxDurable
    --local rate = 0.8
    local UIManager = require("ui.UIManager")
    local texture = UIManager.getInstance().durableBarTexture
    local cutRect = Rect.new(0, 0, 32, 12)
    local cutRectContent = Rect.new(0, 12, math.floor(32 * rate), 12)
    local pos = node.positionInCanvas + canvasPos + Vector2.new(node.width / 2 - 16, node.height / 2 + 10)
    Sprite.draw(texture, pos, cutRect, Color.White)
    local colorContent = Color.new(220 * (1 - rate), 220 * rate, 0, 255)
    Sprite.draw(texture, pos, cutRectContent, colorContent)
end

function UISlotOp.onCheckPCDropOutItem()
    if SettingsData.isMobileOperation then
        return false
    end

    local mouseItemData = MouseItemData.getInstance()
    local mouseSlot = mouseItemData.slot
    if mouseSlot.hasStack then
        local NetworkProxy = require("network.NetworkProxy")
        local RPC_ID = require("network.RPC_ID")
        NetworkProxy.RPCSendServerBound(Mod.GetByID("tc"), RPC_ID.SB_DROP_ITEM_MOUSE)
        mouseSlot:ClearStack()
        return true
    end
    return false
end

return UISlotOp