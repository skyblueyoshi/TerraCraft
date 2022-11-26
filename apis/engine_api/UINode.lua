---@API

---@class UINode 基本的UI节点，是所有类型UI节点的基类。
---@field name string 节点名字。
---@field anchorPoint Vector2 组件锚点。
---@field anchorPointX number 锚点横坐标。
---@field anchorPointY number 锚点纵坐标。
---@field position Vector2 节点在父节点空间的坐标。
---@field positionInCanvas Vector2 节点在画布空间的坐标。
---@field positionX number 节点在父节点空间的横坐标。
---@field positionY number 节点在父节点空间的纵坐标。
---@field size Size 节点尺寸。
---@field width number 节点宽度。
---@field height number 节点高度。
---@field visible boolean 节点是否可见。
---@field leftMargin number 节点到父节点的左侧边距。
---@field rightMargin number 节点到父节点的右侧边距。
---@field topMargin number 节点到父节点的上侧边距。
---@field bottomMargin number 节点到父节点的下侧边距。
---@field leftMarginEnabled boolean 是否启用节点到父节点的左侧边距。
---@field rightMarginEnabled boolean 是否启用节点到父节点的右侧边距。
---@field topMarginEnabled boolean 是否启用节点到父节点的上侧边距。
---@field bottomMarginEnabled boolean 是否启用节点到父节点的下侧边距。
---@field autoStretchWidth boolean 是否根据左右侧边距自动拉伸适配宽度，若为false，则为根据左右侧边距水平居中。
---@field autoStretchHeight boolean 是否根据上下侧边距自动拉伸适配高度，若为false，则为根据上下侧边距竖直居中。
---@field touchable boolean 节点是否可被触碰。
---@field tag number 节点附加值。
---@field childTag number 节点作为子节点时的附加值。
---@field isContainer boolean 节点是否作为裁切容器。
---@field allowDoubleClick boolean 节点是否允许进行双击。
---@field textBatchRendering boolean
---@field enableRenderTarget boolean 节点是否开启RenderTarget纹理缓存，开启后仅在内部节点更新时重绘纹理缓存。
---@field isTouching boolean 当前节点是否被触碰中。
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