---@class TC.PlayerListUI:TC.UIWindow
local PlayerListUI = class("PlayerListUI", require("UIWindow"))
local UIUtil = require("UIUtil")
local PlayerBoneInfo = require("bone2d.PlayerBoneInfo")
local MenuJoinInfo = require("client.MenuJoinInfo")
local Locale = require("languages.Locale")

function PlayerListUI:__init()
    PlayerListUI.super.__init(self, require("UIDesign").getPlayerListUI())

    ---@type UIScrollView
    self._panelList = nil
    self._accounts = {}
    self._indexSelected = 0
    self._itemSize = nil

    self:initContent()
end

function PlayerListUI:initContent()
    self:initAccountData()

    self._panelList = UIScrollView.cast(self.root:getChild("layer.panel_list"))
    local panelItem = self._panelList:getChild("panel_item")
    self._itemSize = Size.new(panelItem.width, panelItem.height)
    UIUtil.setTable(self._panelList, self, true, 1)

    self:updateSelection()
    self.root:getChild("layer.btn_back"):addTouchUpListener({ self._onBackButtonClicked, self })
    self.root:getChild("layer.btn_ok"):addTouchUpListener({ self._onOkButtonClicked, self })
    self.root:getChild("layer.btn_create"):addTouchUpListener({ self._onNewButtonClicked, self })
    self:initUpdateFunc({ self._onPlayerBoneUpdate, self })
end

function PlayerListUI:getAccountLastModifiedTime(name)
    local filePath = Path.join(App.persistentDataPath, "accounts", name .. ".dat")
    if File.isPathExist(filePath) then
        return File.getLastWriteTime(filePath)
    end
    local filePathBackup = Path.join(App.persistentDataPath, "accounts", name .. ".dat.bak")
    return File.getLastWriteTime(filePathBackup)
end

function PlayerListUI:initAccountData()
    local accountNames = File.getAllFiles(Path.join(App.persistentDataPath, "accounts"),
            ".dat", true, false, false)
    for _, name in pairs(accountNames) do
        local account = Account.new()
        if AccountUtils.Load(name, account) then
            local lastModifiedTime = self:getAccountLastModifiedTime(name)
            local infoTable = {
                name = name,
                skinID = account.skinID,
                lastModifiedTime = lastModifiedTime,
                playerBone = PlayerBoneInfo.createBySkinID(account.skinID)
            }
            infoTable.playerBone.animator:setBool("Standard", true)
            table.insert(self._accounts, infoTable)
        end
    end
    table.sort(self._accounts, function(element1, element2)
        return element1.lastModifiedTime > element2.lastModifiedTime
    end)
end

function PlayerListUI:_getTableElementCount()
    return #self._accounts
end

function PlayerListUI:_getTableElementSize()
    return self._itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function PlayerListUI:_setTableElement(node, index)
    node.tag = index
    node:getChild("img_player_icon_holder").isContainer = true
    node:getChild("img_player_icon_holder.bg"):getPostDrawLayer(0):addListener(
            { self._onRenderPlayerBone, self, index })
    local lbText = UIText.cast(node:getChild("lb_player_name"))
    lbText.text = self._accounts[index].name
    node.allowDoubleClick = true
    node:addTouchUpListener({ self._onElementClicked, self })
    node:addTouchDoubleDownListener({ self._onElementDoubleClicked, self })
    node:getChild("btn_cfg"):addTouchUpListener({ self._onConfigButtonClicked, self, index })
    node:getChild("btn_remove"):addTouchUpListener({ self._onRemoveButtonClicked, self, index })
end

function PlayerListUI:_onRenderPlayerBone(index)
    local playerBone = self._accounts[index].playerBone
    playerBone.joints:render()
    --playerBone.joints:renderDebug()
end

function PlayerListUI:_onPlayerBoneUpdate()
    for index = 1, #self._accounts do
        local elementNode = UIUtil.getTableElement(self._panelList, index)
        local screenPos = self.manager:getScreenPosition(elementNode)
        ---@type JointBody2D
        local playerBone = self._accounts[index].playerBone

        playerBone.joints.position = screenPos + Vector2.new(48, 112)
        playerBone.joints.scale = Vector2.new(1.5, 1.5)
        playerBone:update()
    end
end

---_onElementClicked
---@param node UINode
function PlayerListUI:_onElementClicked(node)
    local index = node.tag
    if self._indexSelected ~= index then
        self.manager:playClickSound()
        self._indexSelected = index
        self:updateSelection()
    end
end

---_onElementClicked
---@param node UINode
function PlayerListUI:_onElementDoubleClicked(node)
    self:_onElementClicked(node, nil)
    self:_onOkButtonClicked()
end

function PlayerListUI:_onOkButtonClicked()
    if self._indexSelected > 0 then
        MenuJoinInfo.getInstance().playerInfo.name = self._accounts[self._indexSelected].name
        self:closeWindow()
        self.manager:playClickSound()
        if not MenuJoinInfo.getInstance().serverInfo.isMultiplayer then
            require("WorldListUI").new()
        else
            require("ServerListUI").new()
        end
    end
end

function PlayerListUI:_onNewButtonClicked()
    self:closeWindow()
    self.manager:playClickSound()
    require("NewPlayerUI").new()
end

function PlayerListUI:_onConfigButtonClicked(index)

end

---@param index number
function PlayerListUI:_onRemoveButtonClicked(index)
    if self._indexSelected == index then
        local name = self._accounts[index].name
        self.manager:playClickSound()

        local InfoPopupUI = require("InfoPopupUI")
        local infoUI = InfoPopupUI.new(
                Locale.SURE_TO_DELETE_PLAYER_1 .. "\"" .. name .. "\"" .. Locale.SURE_TO_DELETE_PLAYER_2,
                function()
                    if name ~= nil and name ~= "" then
                        print("remove player", name)
                        AccountUtils.Remove(name)
                    end
                end,
                function()
                    PlayerListUI.new()
                end
        )
        self:closeWindow()
    end
end

function PlayerListUI:_onBackButtonClicked()
    MenuJoinInfo.getInstance().playerInfo.name = ""
    self.manager:playClickSound()
    self:closeWindow()
    require("StartUI").new()
end

function PlayerListUI:updateSelection()
    for index = 1, #self._accounts do
        local node = self._panelList:getChildByTag(index)
        local show = false
        if node.tag == self._indexSelected then
            show = true
        end
        node:getChild("img_selected").visible = show
        node:getChild("btn_remove").visible = show
        node:getChild("btn_cfg").visible = show
    end
    local btnColor = self._indexSelected and Color.White or Color.Gray
    UIText.cast(self.root:getChild("layer.btn_ok.lb_caption")).color = btnColor
end

function PlayerListUI:closeWindow()
    PlayerListUI.super.closeWindow(self)
end

return PlayerListUI