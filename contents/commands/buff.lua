function InnerRunCommand(player, buffID, buffTime)
    player:AddBuff(buffID, buffTime)
end

function RunCommandFromPlayer(myPlayer, buffID, buffTime)
    InnerRunCommand(myPlayer, buffID, buffTime)
    MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("buff_ok"), myPlayer.name,
        LangUtils.BuffName(buffID), math.floor(buffTime / 60)))
end

function RunCommand(sourceCmd, player, buffID, buffTime)
    InnerRunCommand(player, buffID, buffTime)
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("buff_ok"), player.name, LangUtils.BuffName(buffID),
                               math.floor(buffTime / 60)))
end
