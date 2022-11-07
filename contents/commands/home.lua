
function RunCommandFromPlayer(myPlayer)
	local ok = myPlayer:GoHome()
	if ok then
		MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("home_ok"), myPlayer.name))
	else
		MiscUtils.UnicastUTF8(myPlayer, string.format(LangUtils.ModText("home_fail"), myPlayer.name))
	end
end