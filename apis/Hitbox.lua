-- Document
-- Hitbox Class: https://blueyoshi.gitbook.io/terracraft/en/mod/api/type#hitbox
--
-- Hitbox类: https://blueyoshi.gitbook.io/terracraft/cn/mod/api/type#hitbox
--
-- Copyright (c) 2021. BlueYoshi(blueyoshi@foxmail.com)

---@class Hitbox Represents a collision box. If the angle attribute is 0, it means axis aligned collision box (AABB). Otherwise, it represents a collision box rotating around the center point. (表示一个碰撞箱。若angle属性为0，表示轴对齐碰撞箱（AABB）。否则表示一个绕中心点旋转的碰撞箱。)
---@field x double The x coordinate of the upper left corner of the hitbox when the rotation angle is 0. (碰撞箱在旋转角度为0时左上角x坐标)
---@field y double The y coordinate of the upper left corner of the hitbox when the rotation angle is 0. (碰撞箱在旋转角度为0时左上角y坐标)
---@field width int The width of the hitbox. (碰撞箱宽度)
---@field height int The height of the hitbox. (碰撞箱高度)
---@field centerX double @[ Read-only ] Returns the center x coordinate of the hitbox. (返回碰撞箱正中间x坐标)
---@field centerY double @[ Read-only ] Returns the center y coordinate of the hitbox. (返回碰撞箱正中间y坐标)
---@field angle double @[ Read-only ] Returns the rotation angle of the collision box if the collision box can be rotated. (若碰撞箱可以旋转，表示碰撞箱的旋转角度)
local Hitbox = {}

--- Returns whether the current hitbox overlaps with another hitbox.
---
--- 返回当前碰撞箱与另一个碰撞箱是否重叠。
---@param other Hitbox The other hitbox. (另一个碰撞箱)
---@return boolean
function Hitbox:Overlap(other)
end

--- Returns whether the current axis-aligned rectangle overlaps with another axis-aligned rectangle.
---
--- 返回当前轴对齐矩形与另一个轴对齐矩形是否重叠。
---@param other Hitbox The other hitbox. (另一个碰撞箱)
---@return boolean
function Hitbox:OverlapAABB(other)
end

return Hitbox