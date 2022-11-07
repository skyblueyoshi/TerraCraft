
function RunCommand(sourceCmd)
	MiscUtils.SetSafeBlow(false)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("safeblow_off_ok")))
end