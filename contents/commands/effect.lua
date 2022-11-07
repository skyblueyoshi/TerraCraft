
function RunCommand(sourceCmd, effectID, x, y)
	EffectUtils.SendFromServer(effectID, x * 16, y * 16)
end