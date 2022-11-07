function RunCommand(sourceCmd, dayTime)
    MiscUtils.SetDayTime(dayTime)
    local h, m, s = MiscUtils.GetDayTimeFormat()
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("day_ok"), h, m, s))
end
