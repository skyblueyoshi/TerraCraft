-- Document
-- Shape Enum Class: https://blueyoshi.gitbook.io/terracraft/en/mod/api/type#shape
--
-- Shape枚举类: https://blueyoshi.gitbook.io/terracraft/cn/mod/api/type#shape
--
-- Copyright (c) 2021. BlueYoshi(blueyoshi@foxmail.com)

---@class Shape Enum class (Enum Format: `SHAPE_XXX`)
local Shape = {}

--- The shape of the hitbox is an axis-aligned rectangle.
---
--- 碰撞箱形状为轴对齐矩形。
---
---@type Shape
SHAPE_BOX = nil

--- The shape of the hitbox is a rotating rectangle.
---
--- 碰撞箱形状为旋转矩形。
---
---@type Shape
SHAPE_ROTATE_BOX = nil

return Shape