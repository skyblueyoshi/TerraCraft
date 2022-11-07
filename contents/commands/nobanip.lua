
function RunCommand(sourceCmd, ip)
	local ok = MiscUtils.RemoveBan(ip)
	if ok then
		sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("nobanip_ok"), ip))
	else
		sourceCmd:ResponseUTF8(string.format(LangUtils.ModText("nobanip_fail"), ip))
	end
end