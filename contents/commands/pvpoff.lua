
function RunCommand(sourceCmd)
	MiscUtils.SetPVP(false)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("pvp_off_ok")))
end