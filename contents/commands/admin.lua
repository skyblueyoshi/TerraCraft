function RunCommand(sourceCmd, player)
    player:SetOP(OP_ADMIN)
    player:SetGameMode(GAME_MODE_CREATIVE)
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("admin_ok"), player.name))
end
