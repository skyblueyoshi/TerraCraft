
function RunCommand(sourceCmd)
	MiscUtils.SetWeatherTime(216000 * 100)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("wea_ok"), 100))
end