function RunCommandFromPlayer(myPlayer, toPlayer, message)
    MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("msg_to_content"), toPlayer.name, message))
    MiscUtils.UnicastUTF8(toPlayer, string.format(LangUtils.ModText("msg_content"), myPlayer.name, message))
end

function RunCommand(sourceCmd, toPlayer, message)
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("msg_to_server_content"), toPlayer.name, message))
    MiscUtils.UnicastUTF8(toPlayer, string.format(LangUtils.ModText("msg_server_content"), message))
end
