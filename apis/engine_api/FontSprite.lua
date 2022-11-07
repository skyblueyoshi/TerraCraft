---@class FontSprite
local FontSprite = {}

---drawText
---@param text string
---@param pos Vector2
---@param size Size
---@param textStyle TextStyle
function FontSprite.drawText(text, pos, size, textStyle)
end

---drawTextBuffer
---@param pos Vector2
---@param textBuffer TextBuffer
function FontSprite.drawTextBuffer(pos, textBuffer)
end

---getBuffer
---@param text string
---@param size Size
---@param textStyle TextStyle
---@return TextBuffer
function FontSprite.getBuffer(text, size, textStyle)
end

return FontSprite