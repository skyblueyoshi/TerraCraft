local LocaleHelper = class("LocaleHelper")

function LocaleHelper.reload(locale)
    for name, _ in pairs(locale) do
        local modText = LangUtils.ModText(name)
        if modText ~= nil and modText ~= "" then
            locale[name] = modText
        end
        local content = locale[name]
        if content == "" then
            locale[name] = string.format("@[%s]", name)
            print("Locale Missing: " .. locale[name])
        end
    end
end

return LocaleHelper