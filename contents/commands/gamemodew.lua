function RunCommand(sourceCmd, gameMode)
    MiscUtils.SetGameMode(gameMode)
    local msg = ""
    if gameMode == GAME_MODE_SURVIVAL then
        msg = string.format(LangUtils.ModText("gamemodew_s_ok"))
    elseif gameMode == GAME_MODE_CREATIVE then
        msg = string.format(LangUtils.ModText("gamemodew_c_ok"))
    elseif gameMode == GAME_MODE_ADVENTURE then
        msg = string.format(LangUtils.ModText("gamemodew_a_ok"))
    end
    sourceCmd:ResponseUTF8(msg)
end
