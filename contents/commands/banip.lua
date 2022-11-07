
function RunCommand(sourceCmd, ip)
	MiscUtils.Ban(ip)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("banip_ok"), ip))
end