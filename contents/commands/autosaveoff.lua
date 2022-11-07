
function RunCommand(sourceCmd)
	MiscUtils.SetAutoSaveEnabled(false)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("autosave_off_ok")))
end