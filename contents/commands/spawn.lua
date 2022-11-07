
function RunCommandFromPlayer(myPlayer)
	myPlayer:TeleportToSpawn()
	MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("spawn_ok"), myPlayer.name))
end