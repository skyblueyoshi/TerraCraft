local ValidChecker = class("ValidChecker")

function ValidChecker.checkValidFileName(s)
    local last = ""
    for i, sub, b in utf8string.chars(s) do
        ---@type string
        local c = sub
        if c:len() ~= 1 then
            return false
        end
        if c ~= "_" and c ~= " " and c:match("%W") then
            return false
        end
        last = c
    end
    -- blank cannot locate at the end
    if last == " " then
        return false
    end
    return true
end

return ValidChecker