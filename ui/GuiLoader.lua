local GuiLoader = class("GUILoader")
local proxiesList = require("GuiLoaderProxy")

local serverProxies, clientProxies = proxiesList[1], proxiesList[2]

function GuiLoader:GetServerGuiElement(id, player, xi, yi)
    local func = serverProxies[id]
    if func then
        return func(player, xi, yi)
    end
    return nil
end

function GuiLoader:GetClientGuiElement(id, player, xi, yi)
    local func = clientProxies[id]
    if func then
        return func(player, xi, yi)
    end
    return nil
end

return GuiLoader