---@class TC.WorldListUI:TC.UIWindow
local WorldListUI = class("WorldListUI", require("UIWindow"))
local UIUtil = require("UIUtil")
local MenuJoinInfo = require("client.MenuJoinInfo")
local Locale = require("languages.Locale")

function WorldListUI:__init()
    WorldListUI.super.__init(self, require("UIDesign").getWorldListUI())

    ---@type UIScrollView
    self._panelList = nil
    self._indexSelected = 0
    self._worldInfoList = {}

    self:initContent()
end

function WorldListUI:initContent()
    self:initWorldData()

    self._panelList = self.root:getChild("layer.panel_list")
    local panelItem = self._panelList:getChild("panel_item")
    self.itemSize = Size.new(panelItem.width / 1, panelItem.height)
    UIUtil.setTable(self._panelList, self, true, 1)
    self:updateSelection()

    self.root:getChild("layer.btn_ok"):addTouchUpListener({ self._onOkButtonClicked, self })
    self.root:getChild("layer.btn_back"):addTouchUpListener({ self._onBackButtonClicked, self })
    self.root:getChild("layer.btn_create"):addTouchUpListener({ self._onNewWorldClicked, self })
end

function WorldListUI:getWorldLastModifiedTime(name)
    local filePath = Path.join(App.persistentDataPath, "worlds", name, "base.dat")
    if File.isPathExist(filePath) then
        return File.getLastWriteTime(filePath)
    end
    local filePathBackup = Path.join(App.persistentDataPath, "worlds", name, "base.dat.bak")
    return File.getLastWriteTime(filePathBackup)
end

function WorldListUI:initWorldData()
    local worldNames = File.getAllSubFolders(Path.join(App.persistentDataPath, "worlds"))
    for _, worldName in pairs(worldNames) do
        local worldData = WorldData.new()
        if WorldDataUtils.Load(worldName, worldData) then
            local info = {
                name = worldName,
                data = worldData,
                isCSC = worldData.clientSideCharacters,
                lastModifiedTime = self:getWorldLastModifiedTime(worldName)
            }
            table.insert(self._worldInfoList, info)
        end
    end
    table.sort(self._worldInfoList, function(element1, element2)
        return element1.lastModifiedTime > element2.lastModifiedTime
    end)
end

function WorldListUI:_getTableElementCount()
    return #self._worldInfoList
end

function WorldListUI:_getTableElementSize()
    return self.itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function WorldListUI:_setTableElement(node, index)
    node.tag = index
    local info = self._worldInfoList[index]

    local tipText = ""
    tipText = tipText .. (info.isCSC and Locale.BP_SHARED_MODE or Locale.FORCE_NEW_PLAYER_MODE)

    UIText.cast(node:getChild("lb_world_name")).text = info.name
    UIText.cast(node:getChild("lb_time")).text = tostring(info.lastModifiedTime)
    UIText.cast(node:getChild("lb_tips")).text = tipText
    node.allowDoubleClick = true
    node:addTouchUpListener({ self._onElementClicked, self })
    node:addTouchDoubleDownListener({ self._onElementDoubleClicked, self })
    node:getChild("btn_remove"):addTouchUpListener({ self._onRemoveButtonClicked, self, index })

end

function WorldListUI:_onOkButtonClicked()
    if self._indexSelected > 0 then
        MenuJoinInfo.getInstance().worldInfo.name = self._worldInfoList[self._indexSelected].name
        ClientStateManager.StartJoining(MenuJoinInfo.getInstance():getData())
        self:closeWindow()
        self.manager:playClickSound()
    end
end

function WorldListUI:_onBackButtonClicked()
    self:closeWindow()
    self.manager:playClickSound()
    require("PlayerListUI").new()
end

function WorldListUI:_onNewWorldClicked()
    self.manager:playClickSound()
    self:closeWindow()
    require("NewWorldUI").new()
end

---_onElementClicked
---@param node UINode
---@param _ Touch
function WorldListUI:_onElementClicked(node)
    local index = node.tag
    if self._indexSelected ~= index then
        self.manager:playClickSound()
        self._indexSelected = index
        self:updateSelection()
    end
end

---@param _ Touch
---@param node UINode
function WorldListUI:_onElementDoubleClicked(node)
    self:_onElementClicked(node)
    self:_onOkButtonClicked()
end

---@param index number
function WorldListUI:_onRemoveButtonClicked(index)
    if self._indexSelected == index then
        local name = self._worldInfoList[index].name
        self.manager:playClickSound()
        local InfoPopupUI = require("InfoPopupUI")
        local infoUI = InfoPopupUI.new(
                Locale.SURE_TO_DELETE_WORLD_1 .. "\"" .. name .. "\"" .. Locale.SURE_TO_DELETE_WORLD_2,
                function()
                    if name ~= nil and name ~= "" then
                        print("remove world", name)
                        WorldDataUtils.Remove(name)
                    end
                end,
                function()
                    WorldListUI.new()
                end
        )
        self:closeWindow()
    end
end

function WorldListUI:updateSelection()
    for index = 1, #self._worldInfoList do
        local node = self._panelList:getChildByTag(index)
        local show = false
        if node.tag == self._indexSelected then
            show = true
        end
        node:getChild("img_selected").visible = show
        node:getChild("btn_remove").visible = show
    end
    local btnColor = self._indexSelected and Color.White or Color.Gray
    UIText.cast(self.root:getChild("layer.btn_ok.lb_caption")).color = btnColor
end

function WorldListUI:closeWindow()
    WorldListUI.super.closeWindow(self)
end

return WorldListUI