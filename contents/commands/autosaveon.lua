
function RunCommand(sourceCmd)
	MiscUtils.SetAutoSaveEnabled(true)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("autosave_on_ok")))
end