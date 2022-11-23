---@API

---@class AccountUtils 账号通用类，封装了账号相关操作函数。
local AccountUtils = {}

---从存档中加载一个账号。
---@param accountName string 账号名称。
---@param account Account 如果成功加载账号，将把账号信息写入该参数。
---@return boolean 是否成功加载账号。
function AccountUtils.Load(accountName, account)
end

---将一个账号保存到存档中。
---@param account Account 账号。
function AccountUtils.Save(account)
end

---将一个账号从存档中移除。
---@param accountName string 账号名称。
function AccountUtils.Remove(accountName)
end

return AccountUtils
