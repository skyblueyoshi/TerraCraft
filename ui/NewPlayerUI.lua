---@class TC.NewPlayerUI:TC.UIWindow
local NewPlayerUI = class("NewPlayerUI", require("UIWindow"))
local PlayerBoneInfo = require("bone2d.PlayerBoneInfo")
local UIUtil = require("UIUtil")

function NewPlayerUI:__init()
    NewPlayerUI.super.__init(self, require("UIDesign").getNewPlayerUI())

    self._playerBone = nil
    self._posPanel = self.root:getChild("layer.pos_panel")
    self._postureIdx = 0
    self._skins = {}
    self._itemSize = nil
    self._indexSelected = 0
    self._accountNameExists = {}
    self._canGenerateAccount = false
    self._validName = ""
    self._validSkinID = 0

    self:initContent()
end

function NewPlayerUI:initContent()
    local accountNames = File.getAllFiles(Path.join(App.persistentDataPath, "accounts"),
            ".dat", true, false, false)
    for _, name in pairs(accountNames) do
        self._accountNameExists[name] = true
    end

    self._validSkinID = 1
    self._playerBone = PlayerBoneInfo.createBySkinID(self._validSkinID)
    self._playerBone.animator:setBool("Standard", false)
    self._playerBone.animator:setBool("OnGround", true)
    self._playerBone.joints.flip = true
    self._posPanel:getPostDrawLayer(0):addListener(
            { self._onRenderPlayerBone, self })

    self:_reloadListData()

    UIButton.cast(self.root:getChild("layer.btn_female")).selected = true

    self.root:getChild("layer.btn_ok"):addTouchUpListener({ self.onOkButtonClicked, self })
    self.root:getChild("layer.btn_back"):addTouchUpListener({ self.onBackButtonClicked, self })
    self.root:getChild("layer.btn_animator"):addTouchUpListener({ self.onPostureButtonClicked, self })
    UIInputField.cast(self.root:getChild("layer.panel_name.edit")):addTextChangedListener({ self._onNameChanged, self })
    self:initUpdateFunc({ self._onPlayerBoneUpdate, self })
    self:initUpdateFunc({ self._onPlayerBoneUpdateInList, self })

    self:_checkNameValid("")
end

function NewPlayerUI:onOkButtonClicked()
    if self._canGenerateAccount and self._validName ~= "" and self._validSkinID > 0 then
        local account = Account.new()
        account.name = self._validName
        account.skinID = self._validSkinID
        AccountUtils.Save(account)

        self.manager:playClickSound()
        self:closeWindow()
        require("PlayerListUI").new()
    end
end

function NewPlayerUI:_onNameChanged(_, text)
    self:_checkNameValid(text)
end

---_checkNameValid
---@param text string
function NewPlayerUI:_checkNameValid(text)
    local checker = require("util.ValidChecker")

    local tipText = ""
    self._canGenerateAccount = false
    local len = utf8string.len(text)
    if len == 0 then
        tipText = "请输入玩家名称"
    elseif not (len >= 1 and len <= 20) then
        tipText = "玩家名称不能超过20个字符"
    elseif not checker.checkValidFileName(text) then
        tipText = "玩家名称格式不正确"
    elseif self._accountNameExists[text] then
        tipText = "名称已存在，请换一个"
    else
        tipText = "玩家名称可用!"
        self._canGenerateAccount = true
        self._validName = text
    end
    UIText.cast(self.root:getChild("layer.panel_info.lb_info")).text = tipText
    local btnColor = Color.Gray
    if self._canGenerateAccount then
        btnColor = Color.White
    end
    UIText.cast(self.root:getChild("layer.btn_ok.lb_caption")).color = btnColor
end

function NewPlayerUI:_reloadListData()
    self._skins = {}

    for skinID = 1, SkinUtils.maxID do
        skin = SkinUtils.GetSkin(skinID)
        local skinTable = {
            id = skinID,
            name = skin.name,
            mod = skin.mod,
            authors = "",
            playerBone = PlayerBoneInfo.createBySkinID(skinID)
        }
        for i, author in each(skin.authors) do
            if i == 1 then
                skinTable.authors = "by " .. author
            else
                skinTable.authors = skinTable.authors .. ", " .. author
            end
        end
        skinTable.playerBone.animator:setBool("Standard", true)
        table.insert(self._skins, skinTable)
    end

    self._panelList = UIScrollView.cast(self.root:getChild("layer.panel_list"))
    local panelItem = self._panelList:getChild("panel_item")
    self._itemSize = Size.new(panelItem.width, panelItem.height)
    UIUtil.setTable(self._panelList, self, true, 1)
end

function NewPlayerUI:_getTableElementCount()
    return #self._skins
end

function NewPlayerUI:_getTableElementSize()
    return self._itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function NewPlayerUI:_setTableElement(node, index)
    node.tag = index

    node:getChild("img_player_icon_holder").isContainer = true
    node:getChild("img_player_icon_holder.bg"):getPostDrawLayer(0):addListener(
            { self._onRenderPlayerBoneInList, self, index })

    local lbName = UIText.cast(node:getChild("lb_name"))
    local lbMod = UIText.cast(node:getChild("lb_mod"))
    local lbAuthor = UIText.cast(node:getChild("lb_author"))

    lbName.text = self._skins[index].name
    lbMod.text = self._skins[index].mod.displayName
    lbAuthor.text = self._skins[index].authors

    if lbName.text == "Unknown" then
        lbName.visible = false
        lbMod.positionY = lbMod.positionY - 8
        lbAuthor.positionY = lbAuthor.positionY - 8
    else
        lbName.visible = true
    end

    node:addTouchUpListener({ self._onElementClicked, self })
end

---_onElementClicked
---@param node UINode
---@param _ Touch
function NewPlayerUI:_onElementClicked(node)
    local index = node.tag
    if self._indexSelected ~= index then
        self.manager:playClickSound()
        self._indexSelected = index
        self._validSkinID = self._skins[index].id
        PlayerBoneInfo.setSkinByID(self._playerBone, self._validSkinID)
        self:updateSelection()
    end
end

function NewPlayerUI:updateSelection()
    for index = 1, self:_getTableElementCount() do
        local node = self._panelList:getChildByTag(index)
        local show = false
        if node.tag == self._indexSelected then
            show = true
        end
        node:getChild("img_selected").visible = show
    end
end

function NewPlayerUI:_onPlayerBoneUpdate()
    local screenPos = self.manager:getScreenPosition(self._posPanel)
    self._playerBone.joints.position = screenPos + Vector2.new(100, 200)
    self._playerBone.joints.scale = Vector2.new(4, 4)
    self._playerBone:update()
end

function NewPlayerUI:_onRenderPlayerBoneInList(index)
    local playerBone = self._skins[index].playerBone
    playerBone.joints:render()
end

function NewPlayerUI:_onPlayerBoneUpdateInList()
    for index = 1, #self._skins do
        local elementNode = UIUtil.getTableElement(self._panelList, index)
        local screenPos = self.manager:getScreenPosition(elementNode)
        ---@type JointBody2D
        local playerBone = self._skins[index].playerBone

        playerBone.joints.position = screenPos + Vector2.new(40, 104)
        playerBone.joints.scale = Vector2.new(1.5, 1.5)
        playerBone:update()
    end
end

function NewPlayerUI:_onRenderPlayerBone()
    self._playerBone.joints:render()
end

function NewPlayerUI:onBackButtonClicked()
    local PlayerListUI = require("PlayerListUI")
    self.manager:playClickSound()
    self:closeWindow()
    PlayerListUI.new()
end

function NewPlayerUI:onPostureButtonClicked()
    local animator = self._playerBone.animator
    if self._postureIdx == 0 then
        animator:setFloat("Speed", 0.5)
        self._postureIdx = 1
    elseif self._postureIdx == 1 then
        animator:setFloat("Speed", 1)
        self._postureIdx = 2
    elseif self._postureIdx == 2 then
        animator:setBool("OnGround", false)
        animator:setFloat("AirSpeed", -1)
        self._postureIdx = 3
    elseif self._postureIdx == 3 then
        animator:setFloat("AirSpeed", 1)
        self._postureIdx = 4
    elseif self._postureIdx == 4 then
        animator:setBool("OnGround", true)
        animator:setFloat("Speed", 0)
        self._postureIdx = 0
    end
end

function NewPlayerUI:closeWindow()
    NewPlayerUI.super.closeWindow(self)
end

return NewPlayerUI