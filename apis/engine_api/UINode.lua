---@class UINode
---@field anchorPoint Vector2
---@field anchorPointX number
---@field anchorPointY number
---@field position Vector2
---@field positionInCanvas Vector2
---@field positionX number
---@field positionY number
---@field size Size
---@field width number
---@field height number
---@field visible boolean
---@field leftMargin number
---@field rightMargin number
---@field topMargin number
---@field bottomMargin number
---@field leftMarginEnabled boolean
---@field rightMarginEnabled boolean
---@field topMarginEnabled boolean
---@field bottomMarginEnabled boolean
---@field autoStretchWidth boolean
---@field autoStretchHeight boolean
---@field touchable boolean
---@field name string
---@field tag number
---@field childTag number
---@field isContainer boolean
---@field allowDoubleClick boolean
---@field textBatchRendering boolean
---@field enableRenderTarget boolean
---@field isTouching boolean
local UINode = {}

---new
---@return UINode
function UINode.new()
end

---clone
---@return UINode
function UINode:clone()
end

---@return boolean
function UINode:valid()
end

---setAnchorPoint
---@param x number
---@param y number
function UINode:setAnchorPoint(x, y)
end

---setPosition
---@param x number
---@param y number
function UINode:setPosition(x, y)
end

---setLocation
---@param x number
---@param y number
---@param width number
---@param height number
function UINode:setLocation(x, y, width, height)
end

---setSize
---@param width number
---@param height number
function UINode:setSize(width, height)
end

---addChild
---@overload fun(node:UINode)
---@param node UINode
---@param childTag number
function UINode:addChild(node, childTag)
end

---removeChild
---@param node UINode
function UINode:removeChild(node)
end

function UINode:removeAllChildren()
end

---applyMargin
---@param applyAllChildren boolean
function UINode:applyMargin(applyAllChildren)
end

---setLeftMargin
---@param offset number
---@param enabled boolean
function UINode:setLeftMargin(offset, enabled)
end

---setRightMargin
---@param offset number
---@param enabled boolean
function UINode:setRightMargin(offset, enabled)
end

---setTopMargin
---@param offset number
---@param enabled boolean
function UINode:setTopMargin(offset, enabled)
end

---setBottomMargin
---@param offset number
---@param enabled boolean
function UINode:setBottomMargin(offset, enabled)
end

---setMarginEnabled
---@param left boolean
---@param top boolean
---@param right boolean
---@param bottom boolean
function UINode:setMarginEnabled(left, top, right, bottom)
end

---setAutoStretch
---@param widthEnabled boolean
---@param heightEnabled boolean
function UINode:setAutoStretch(widthEnabled, heightEnabled)
end

---getChildByTag
---@param childTag number
---@return UINode
function UINode:getChildByTag(childTag)
end

---getChild
---@param name string
---@return UINode
function UINode:getChild(name)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchDownListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchDownListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchDoubleDownListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchDoubleDownListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchMoveListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchMoveListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchPointedMoveListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchPointedMoveListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchUpListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchUpListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchUpAfterMoveListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchUpAfterMoveListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addTouchPointedUpListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeTouchPointedUpListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addMousePointedListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeMousePointedListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addMousePointedEnterListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeMousePointedEnterListener(listenerID)
end

---
---@param listener table|function
---@return ListenerID
function UINode:addMousePointedLeaveListener(listener)
end

---
---@param listenerID ListenerID
function UINode:removeMousePointedLeaveListener(listenerID)
end

---getPreDrawLayer
---@param layer number
---@return UINodeDrawLayer
function UINode:getPreDrawLayer(layer)
end

---getPostDrawLayer
---@param layer number
---@return UINodeDrawLayer
function UINode:getPostDrawLayer(layer)
end

---@return number
function UINode:getChildrenCount()
end

---getChildByIndex
---@param index number
---@return UINode
function UINode:getChildByIndex(index)
end

---getPointedNode
---@overload fun(canvasPosition:Vector2):UINode
---@param canvasPosition Vector2
---@param isTouching boolean
---@return UINode
function UINode:getPointedNode(canvasPosition, isTouching)
end

function UINode:flushRender()
end

return UINode