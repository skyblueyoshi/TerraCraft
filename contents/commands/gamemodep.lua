
function InnerRunCommand(player, gameMode, changeFromSelf)
	player:SetGameMode(gameMode, changeFromSelf)
	local msg = ""
	if gameMode == GAME_MODE_SURVIVAL then
		msg = string.format(LangUtils.ModText("gamemodep_s_ok"), player.name)
	elseif gameMode == GAME_MODE_CREATIVE then
		msg = string.format(LangUtils.ModText("gamemodep_c_ok"), player.name)
	elseif gameMode == GAME_MODE_ADVENTURE then
		msg = string.format(LangUtils.ModText("gamemodep_a_ok"), player.name)
	end
	return msg
end

function RunCommandFromPlayer(myPlayer, gameMode)
	local msg = InnerRunCommand(myPlayer, gameMode, true)
	MiscUtils.UnicastUTF8(myPlayer, msg)
end

function RunCommand(sourceCmd, player, gameMode)
	local msg = InnerRunCommand(player, gameMode, false)
	MiscUtils.UnicastUTF8(player, msg)
	sourceCmd:ResponseUTF8(msg)
end