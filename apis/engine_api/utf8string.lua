---https://github.com/blitmap/lua-utf8-simple

---@class utf8string
local utf8string = {}

---maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)
---
--- i is the character/letter index within the string
---
--- c is the utf8 character (string of 1 or more bytes)
---
--- b is the byte index within the string
---
---`for i, c, b in utf8string.chars('Αγαπώ τηγανίτες') do`
---
---`    print(i, c, b)`
---
---`end`
---
---@overload fun(s:string):number, string, number
---@param s string
---@param no_subs boolean
---@return number, string, number
function utf8string.chars(s, no_subs)
end

---returns: (number) the number of utf8 characters in s (not the byte length)
---@param s string
---@return number
function utf8string.len(s)
end

---like string.sub() but i, j are utf8 strings
---
---a utf8-safe string.sub()
---@param s string
---@param i number
---@param j number
---@return string
function utf8string.sub(s, i, j)
end

---strip non-ascii characters from a utf8 string
---@param s string
---@return nil|string
function utf8string.strip(s)
end

---reverse a utf8 string
---@param s string
---@return string
function utf8string.reverse(s)
end

---replace all utf8 chars with mapping
---@param s string
---@return string
function utf8string.replace(s, map)
end

return utf8string