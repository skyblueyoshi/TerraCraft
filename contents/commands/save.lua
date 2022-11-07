
function RunCommand(sourceCmd)
	MiscUtils.SaveAll()
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("save_ok")))
end