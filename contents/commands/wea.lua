
function RunCommand(sourceCmd, weaTime)
	MiscUtils.SetWeatherTime(weaTime)
	local progress = math.floor(weaTime / 86400 * 100)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("wea_ok"), progress))
end