
function RunCommand(sourceCmd)
	MiscUtils.SetDaySpeed(1.0)
	daySpeed = MiscUtils.GetDaySpeed()
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("dayspeed_ok"), daySpeed))
end