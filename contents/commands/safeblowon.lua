
function RunCommand(sourceCmd)
	MiscUtils.SetSafeBlow(true)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("safeblow_on_ok")))
end