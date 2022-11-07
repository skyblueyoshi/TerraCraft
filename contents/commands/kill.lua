
function RunCommandFromPlayer(myPlayer)
	myPlayer:Strike(DEATH_REASON_SUICIDE, Attack.new(114514, 0, 0))
end

function RunCommand(sourceCmd, player)
	player:Strike(DEATH_REASON_UNKNOWN, Attack.new(114514, 0, 0))
end