function InnerRunCommand(player, itemID, itemCount)
    local imax = ItemUtils.GetMaxCount(itemID)
    if itemCount > imax then
        itemCount = imax
    end
    player:AddBackpack(itemID, itemCount)
    return itemCount
end

function RunCommandFromPlayer(myPlayer, itemID, itemCount)
    itemCount = InnerRunCommand(myPlayer, itemID, itemCount)
    MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("give_ok"), myPlayer.name,
        LangUtils.ItemName(itemID), itemCount))
end

function RunCommand(sourceCmd, player, itemID, itemCount)
    itemCount = InnerRunCommand(player, itemID, itemCount)
    sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("give_ok"), player.name, LangUtils.ItemName(itemID),
                               itemCount))
end
