---@API

---@class TextureLocation 描述一个纹理索引。
---@field isSingleTexture boolean 当前纹理索引是否不是来自合图。
---@field isAtlasArea boolean 当前纹理索引是否来自合图。
---@field spriteZoomInTimes number 当纹理索引用于精灵渲染时，表示渲染时纹理放大倍数。
---@field valid boolean 纹理是否有效。
local TextureLocation = {}

---创建一个纹理索引对象。
---@param format number
---@param id number
---@return TextureLocation 新的纹理索引对象。
function TextureLocation.new(format, id)
end

---克隆一个纹理索引对象。
---@param value TextureLocation 原始纹理索引对象。
---@return TextureLocation 新的纹理索引对象。
function TextureLocation.clone(value)
end

return TextureLocation