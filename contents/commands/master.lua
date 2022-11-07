function RunCommand(sourceCmd, player)
    player:SetOP(OP_MASTER)
    player:SetGameMode(GAME_MODE_CREATIVE)
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("master_ok"), player.name))
end
