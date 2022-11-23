-- Document
-- SpriteEx Class: https://blueyoshi.gitbook.io/terracraft/en/mod/api/type#spriteex
--
-- SpriteEx类: https://blueyoshi.gitbook.io/terracraft/cn/mod/api/type#spriteex
--
-- Copyright (c) 2021. BlueYoshi(blueyoshi@foxmail.com)

---@class SpriteEx Sprite extension information, has the relevant parameters of drawing. (精灵绘制拓展信息，拥有决定绘制的相关参数)
---@field scaleRateX float @[ default `1.0` ] The horizontal zoom size when the sprite is drawn. (精灵绘制时的横向缩放尺寸)
---@field scaleRateY float @[ default `1.0` ] The vertical zoom size when the sprite is drawn. (精灵绘制时的纵向缩放尺寸)
---@field angle float @[ default `0.0` ] The rotation angle when the sprite is drawn. (精灵绘制时的旋转角度)
---@field rotateX float The center point X of the sprite's rotation. If the drawing object is an entity, the default is the center of the entity, otherwise the default is 0.0. (精灵的旋转中心点X。若绘制对象为实体，默认为实体中心，否则默认为0.0)
---@field rotateY float The center point Y of the sprite's rotation. If the drawing object is an entity, the default is the center of the entity, otherwise the default is 0.0. (精灵的旋转中心点Y。若绘制对象为实体，默认为实体中心，否则默认为0.0)
---@field flipHorizontal boolean @[ default `false` ] Whether to flip horizontally when the sprite is drawn. (精灵绘制时是否水平翻转)
---@field flipVertical boolean @[ default `false` ] Whether to flip vertically when the sprite is drawn. (精灵绘制时是否竖直翻转)
local SpriteEx = {}

--- Restore Defaults.
---
--- 恢复默认值。
function SpriteEx:SetDefault()
end

return SpriteEx