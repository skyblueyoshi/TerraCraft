local Algorithm = class("Algorithm")

--- make an array random order
function Algorithm.Shuffle(array)
    --print("in", array)
    local n = #array
    for i = 1, n do
        local j = math.random(1, n)
        if i ~= j then
            local temp = array[i]
            array[i] = array[j]
            array[j] = temp
        end
    end
    --print("out", array)
end

function Algorithm.isRectTouch(x1, y1, w1, h1, x2, y2, w2, h2)
    if x1 < x2 + w2 and x1 + w1 > x2 and y1 + h1 > y2 and y1 < y2 + h2 then
        return true
    end
end

function Algorithm.isPointInPolygon(x, y, poly)
    -- poly is a Lua list of pairs like {x1, y1, x2, y2, ... xn, yn}
    -- see: https://love2d.org/forums/viewtopic.php?t=89699
    local x1, y1, x2, y2
    local len = #poly
    x2, y2 = poly[len - 1], poly[len]
    local wn = 0
    for idx = 1, len, 2 do
        x1, y1 = x2, y2
        x2, y2 = poly[idx], poly[idx + 1]

        if y1 > y then
            if (y2 <= y) and (x1 - x) * (y2 - y) < (x2 - x) * (y1 - y) then
                wn = wn + 1
            end
        else
            if (y2 > y) and (x1 - x) * (y2 - y) > (x2 - x) * (y1 - y) then
                wn = wn - 1
            end
        end
    end
    return wn % 2 ~= 0 -- even/odd rule
end

return Algorithm