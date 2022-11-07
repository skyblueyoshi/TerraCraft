
function RunCommandFromPlayer(myPlayer)
	myPlayer:ClearBackpack()
	MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("clear_ok"), myPlayer.name))
end

function RunCommand(sourceCmd, player)
	player:ClearBackpack()
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("clear_ok"), player.name))
end