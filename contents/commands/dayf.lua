
function RunCommand(sourceCmd, h, m, s)
	MiscUtils.SetDayTimeFormat(h, m, s)
	h, m, s = MiscUtils.GetDayTimeFormat()
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("day_ok"), h, m, s))
end