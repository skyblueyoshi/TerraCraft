local StringUtils = class("StringUtils")

local STR_ROMANS = {
    "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"
}
local ROMAN_VALUES = {
    1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
}

function StringUtils.NumberToRoman(n)
    local result = ""
    for i = 1, 13 do
        while n - ROMAN_VALUES[i] >= 0 do
            result = result .. STR_ROMANS[i]
            n = n - ROMAN_VALUES[i]
        end
    end
    return result
end

function StringUtils.TicksToTimeFormat(ticks)
    local seconds = math.ceil(ticks / 60)
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%02d:%02d", m, s)
end

return StringUtils