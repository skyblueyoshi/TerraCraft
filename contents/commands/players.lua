
function RunCommand(sourceCmd)
	local onlinePlayers = MiscUtils.GetOnlinePlayerList()
	local count = onlinePlayers.length
	for i = 1, count do
		local player = onlinePlayers[i]
		local info = string.format(LangUtils.ModText("player_info"), i, player.name, player.ip, player.portNumber)
		sourceCmd:ResponseUTF8(info)
	end
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("players_ok"), count))
end