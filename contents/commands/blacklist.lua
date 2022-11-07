
function RunCommand(sourceCmd)
	local blackList = MiscUtils.GetBlackList()
	local count = blackList.length
	for i = 1, count do
		sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("blacklist_info"), i, blackList[i]))
	end
	sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("blacklist_ok"), count))
end