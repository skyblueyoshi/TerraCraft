
function RunCommand(sourceCmd, player)
	local name = player.name
	MiscUtils.KickPlayer(name)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("kick_ok"), name))
end