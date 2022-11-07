
function RunCommand(sourceCmd, player)
    player:SetOP(OP_ANY)
    local gameMode = MiscUtils.GetGameMode()
    player:SetGameMode(gameMode)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("nomaster_ok"), player.name))
end