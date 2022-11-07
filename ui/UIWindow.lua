---@class TC.UIWindow
local UIWindow = class("UIWindow")
local UIManager = require("UIManager")
local MouseItemData = require("MouseItemData")
local API = require("api")
local UIDefault = require("ui.UIDefault")

---__init
---@param root UIPanel
function UIWindow:__init(root, uiGroup)
    self.root = root
    self.manager = UIManager.getInstance()
    self.mouseItemData = MouseItemData.getInstance()
    self.windowId = self.manager:addWindowsLoaded(self)
    self.closed = false
    self.scheduleIds = {}
    self.allowCloseByEsc = false
    self.uiGroup = UIDefault.GROUP_NONE
    if uiGroup ~= nil then
        self.uiGroup = uiGroup
    end

    self.root.textBatchRendering = true
    self.uiClassName = self.__cname

    self._modifyInstances = {}
    self:initModifyFromOutside()
end

function UIWindow:initModifyFromOutside()
    local dict = API.getInstance().uiModifyDict[self.uiClassName]
    if dict ~= nil then
        for _, modifyClass in ipairs(dict) do
            local ins = modifyClass.new(self)
            table.insert(self._modifyInstances, ins)
        end
    end
end

function UIWindow:closeWindow()
    self.manager:removeWindowsLoaded(self.windowId)
    self.closed = true

    self:onDestroy()

    for _, scheduleID in ipairs(self.scheduleIds) do
        IntegratedClient.main:removeSchedule(scheduleID)
    end
    self.scheduleIds = {}
end

function UIWindow:onDestroy()
end

function UIWindow:initUpdateFunc(listener, intervalTicks)
    intervalTicks = intervalTicks or 0
    local scheduleID = IntegratedClient.main:createSchedule(intervalTicks)
    IntegratedClient.main:getSchedule(scheduleID):addListener(listener)
    table.insert(self.scheduleIds, scheduleID)
end

function UIWindow:onWindowResize()
    self.root:applyMargin()
end

function UIWindow:onUpdate()
end

function UIWindow:postInitContent()
    for _, ins in ipairs(self._modifyInstances) do
        if ins.initContent ~= nil then
            ins:initContent()
        end
    end
end

return UIWindow