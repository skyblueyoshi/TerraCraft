
function RunCommand(sourceCmd, npcID, x, y)
	NpcUtils.Create(npcID, x * 16, y * 16)
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("npc_ok"), 
		LangUtils.NpcName(npcID), x, y))

end