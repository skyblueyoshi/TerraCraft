---@class TC.ModListUI:TC.UIWindow
local ModListUI = class("ModListUI", require("UIWindow"))
local UIUtil = require("UIUtil")
local Locale = require("languages.Locale")

function ModListUI:__init()
    ModListUI.super.__init(self, require("UIDesign").getModListUI())
    self.indexSelected = 1
    self.itemNodes = {}
    self.modInfoList = {}

    self._panelList = self.root:getChild("layer.panel_list")
    self._panelItem = self._panelList:getChild("panel_item")
    self._svInfo = UIScrollView.cast(self.root:getChild("layer.info_list"))
    self._panelInfo1 = self._svInfo:getChild("panel_info_1")
    self._panelInfo2 = self._svInfo:getChild("panel_info_2")
    self._panelInfoWeb = self._svInfo:getChild("panel_info_web")
    self._btnWeb1 = self._panelInfoWeb:getChild("btn_web_1")
    self._btnWeb2 = self._panelInfoWeb:getChild("btn_web_2")

    self._lbVersion = UIText.cast(self._panelInfo1:getChild("panel_version.lb_version"))
    self._lbAuthors = UIText.cast(self._panelInfo1:getChild("panel_author.lb_author"))
    self._lbDesc = UIText.cast(self._panelInfo2:getChild("lb_des"))
    self._lbListTitle = UIText.cast(self.root:getChild("layer.lb_list_title"))

    self:initContent()
end

function ModListUI:initContent()
    self:_initInfo()
    self.root:getChild("layer.btn_back"):addTouchUpListener({
        function(self)
            self.manager:playClickSound()
            local StartUI = require("StartUI")
            self:closeWindow()
            StartUI.new()
        end, self }
    )
    self.root:getChild("layer.btn_mod_folder"):addTouchUpListener({
        self._onOpenModsFolderClicked, self }
    )
    self._btnWeb1:addTouchUpListener({ self._onURLClicked, self, 1 })
    self._btnWeb2:addTouchUpListener({ self._onURLClicked, self, 2 })
    self.itemSize = Size.new(self._panelItem.width, self._panelItem.height)
    UIUtil.setTable(self._panelList, self, true, 1)
    self._lbListTitle.text = string.format(Locale.ALL_MOD_LOADED, #self.modInfoList)

    self:postInitContent()

    self:updateSelection()
end

function ModListUI:_onOpenModsFolderClicked()
    self.manager:playClickSound()
    if App.isPC then
        File.openFolderWindow(Path.join(App.persistentDataPath, "mods"))
    else
        require("ui.InfoPopupUI").new(Locale.MOD_FOLDER_UNSUPPORTED)
    end
end

function ModListUI:_initInfo()
    -- load all mod info from package.json
    local UISpritePool = require("UISpritePool")
    ---@param mod Mod
    for _, mod in each(Mod.modList) do
        local packageJsonPath = Path.join(mod.assetRootPath, "package.json")
        local jsonStr = AssetManager.readAsString(packageJsonPath)
        local info = JsonUtil.fromJson(jsonStr)

        if UISpritePool.getInstance():has(mod.modId .. ":__icon") then
            info._texName = mod.modId .. ":__icon"
        end

        table.insert(self.modInfoList, info)
    end
end

function ModListUI:_getTableElementCount()
    return #self.modInfoList
end

function ModListUI:_getTableElementSize()
    return self.itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function ModListUI:_setTableElement(node, index)
    node.tag = index

    local info = self.modInfoList[index]
    local lbCaption = UIText.cast(node:getChild("lb_mod_name"))
    local lbTips = UIText.cast(node:getChild("lb_mod_tip"))
    local iconImg = UIImage.cast(node:getChild("img_mod_pic"))

    if info.displayName then
        lbCaption.text = info.displayName
    else
        lbCaption.text = "Untitled"
    end

    if info.tips then
        lbTips.text = info.tips
    else
        lbTips.text = ""
    end

    if info._texName ~= nil then
        local UISpritePool = require("UISpritePool")
        iconImg.sprite = UISpritePool.getInstance():get(info._texName)
    end

    node:addTouchUpListener({ self._onElementClicked, self })
    table.insert(self.itemNodes, node)
end

---_onElementClicked
---@param node UINode
---@param _ Touch
function ModListUI:_onElementClicked(node)
    local index = node.tag
    if self.indexSelected ~= index then
        self.indexSelected = index
        self:updateSelection()
        self.manager:playClickSound()
    end
end

function ModListUI:updateSelection()
    ---@param node UINode
    for _, node in pairs(self.itemNodes) do
        if node.tag == self.indexSelected then
            node:getChild("img_selected").visible = true
        else
            node:getChild("img_selected").visible = false
        end
    end

    local info = self.modInfoList[self.indexSelected]
    if info.version then
        self._lbVersion.text = info.version
    else
        self._lbVersion.text = "0.0.0.0"
    end

    if info.authors then
        local str = ""
        local flag = false
        for _, authorName in ipairs(info.authors) do
            if flag then
                str = str .. ", "
            end
            flag = true
            str = str .. authorName
        end
        self._lbAuthors.text = str
    else
        self._lbAuthors.text = "..."
    end

    self._panelInfoWeb.visible = false
    if info.websites then
        self._panelInfoWeb.visible = true
        self._btnWeb1.visible = false
        self._btnWeb2.visible = false
        for i, wbData in ipairs(info.websites) do
            local btn
            if i == 1 then
                btn = self._btnWeb1
            elseif i == 2 then
                btn = self._btnWeb2
            else
                break
            end
            btn.visible = true
            local originalText = wbData.title
            if originalText == "Github" then
                originalText = Locale.WEB_SOURCE_GITHUB
            elseif originalText == "Homepage" then
                originalText = Locale.WEB_HOME
            end
            UIText.cast(btn:getChild("lb_caption")).text = originalText
        end
    end

    self._lbDesc.autoAdaptSize = true
    self._lbDesc.preferredWidth = self._panelInfo2.width - 32
    if info.description then
        self._lbDesc.text = info.description
    else
        self._lbDesc.text = ""
    end
    self._panelInfo2.height = self._lbDesc.positionY + self._lbDesc.height + 16

    local posY = self._panelInfo1.positionY + self._panelInfo1.height + 16
    if self._panelInfoWeb.visible then
        self._panelInfoWeb.positionY = posY
        posY = posY + self._panelInfoWeb.height + 16
    end
    self._panelInfo2.positionY = posY

    self._svInfo:ScrollToTop()
    local tmpSize = Size.new(self._svInfo.viewSize.width,
            self._panelInfo2.positionY + self._panelInfo2.height)
    tmpSize.height = math.max(tmpSize.height, self._svInfo.height)
    self._svInfo.viewSize = tmpSize
    self._svInfo:ScrollToTop()
end

function ModListUI:_onURLClicked(index)
    self.manager:playClickSound()
    local info = self.modInfoList[self.indexSelected]
    if info.websites then
        if index <= #info.websites then
            local url = info.websites[index].url
            local MiscHelper = require("util.MiscHelper")
            MiscHelper.OpenURL(url)
        end
    end
end

function ModListUI:closeWindow()
    ModListUI.super.closeWindow(self)
end

return ModListUI