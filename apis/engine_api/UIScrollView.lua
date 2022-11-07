---@class UIScrollView:UINode
---@field sprite UISprite
---@field viewSize Size
---@field isScrollVertical boolean
---@field isScrollHorizontal boolean
---@field isScrollable boolean
---@field isScrolling boolean
local UIScrollView = {}

---new
---@overload fun(name:string):UIScrollView
---@param name string
---@param x number
---@param y number
---@param width number
---@param height number
---@return UIScrollView
function UIScrollView.new(name, x, y, width, height)
end

---
---@param value UIScrollView
---@return UIScrollView
function UIScrollView.clone(value)
end

---case
---@param uiNode UINode
---@return UIScrollView
function UIScrollView.cast(uiNode)
end

function UIScrollView:ScrollToTop()
end

function UIScrollView:ScrollToBottom()
end

function UIScrollView:ScrollToLeft()
end

function UIScrollView:ScrollToRight()
end

function UIScrollView:StopScrolling()
end

return UIScrollView