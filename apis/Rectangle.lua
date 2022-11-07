-- Document
-- Rectangle Class: https://blueyoshi.gitbook.io/terracraft/en/mod/api/type#rectangle
--
-- Rectangle类: https://blueyoshi.gitbook.io/terracraft/cn/mod/api/type#rectangle
--
-- Copyright (c) 2021. BlueYoshi(blueyoshi@foxmail.com)

---@class Rectangle Represents an axis-aligned rectangle. (表示一个轴对齐矩形)
---@field public x int The x coordinate of the upper left corner of the rectangle. (矩形左上角横坐标)
---@field public y int The y coordinate of the upper left corner of the rectangle. (矩形左上角纵坐标)
---@field public width int The width of the rectangle. (矩形宽度)
---@field public height int The height of the rectangle. (矩形高度)
local Rectangle = {}

--- Set a new rectangle.
---
--- 设置新的矩形。
---@param x int
---@param y int
---@param width int
---@param height int
function Rectangle:Set(x, y, width, height)
end

return Rectangle