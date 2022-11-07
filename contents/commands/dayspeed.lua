
function RunCommand(sourceCmd, daySpeed)
	MiscUtils.SetDaySpeed(daySpeed)
	daySpeed = MiscUtils.GetDaySpeed()
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("dayspeed_ok"), daySpeed))
end