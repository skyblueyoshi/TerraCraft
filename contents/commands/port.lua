
function RunCommand(sourceCmd)
	local port = MiscUtils.GetPortNumber()
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("port_ok"), port))
end