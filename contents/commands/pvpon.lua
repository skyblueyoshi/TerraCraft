
function RunCommand(sourceCmd)
	MiscUtils.SetPVP(true)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("pvp_on_ok")))
end