---@class TC.API
local API = class("API")

local s_instance
---@return TC.API
function API.getInstance()
    if s_instance == nil then
        s_instance = API.new()
    end
    return s_instance
end

function API:__init()
    self.uiModifyDict = {}
end

function API:_ModifyUI(uiClassName, modifyClass)
    if self.uiModifyDict[uiClassName] == nil then
        self.uiModifyDict[uiClassName] = {}
    end
    table.insert(self.uiModifyDict[uiClassName], modifyClass)
end

---data:
---{
--- initContentCallback=???,
---}
---@param data table
function API.ModifyUI(uiClassName, modifyClass)
    API.getInstance():_ModifyUI(uiClassName, modifyClass)
end

return API