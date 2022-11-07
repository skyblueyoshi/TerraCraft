function InnerRunCommand(player, x, y)
    player:Teleport(x * 16, y * 16)
end

function RunCommandFromPlayer(myPlayer, x, y)
    InnerRunCommand(myPlayer, x, y)
    MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("tp_ok"), myPlayer.name, x, y))
end

function RunCommand(sourceCmd, player, x, y)
    InnerRunCommand(player, x, y)
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("tp_ok"), player.name, x, y))
end
