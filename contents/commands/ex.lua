
function InnerRunCommand(player, exValue)
	player:AddExperience(exValue)
end

function RunCommandFromPlayer(myPlayer, exValue)
	InnerRunCommand(myPlayer, exValue)
	MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("ex_ok"), myPlayer.name, exValue))
end

function RunCommand(sourceCmd, player, exValue)
	InnerRunCommand(player, exValue)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("ex_ok"), player.name, exValue))
end