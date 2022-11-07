
function RunCommandFromPlayer(myPlayer, message)
	local msg = string.format("#H* %s %s", myPlayer.name, message)
	MiscUtils.BroadcastUTF8(msg)
end