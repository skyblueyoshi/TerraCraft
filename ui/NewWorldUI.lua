---@class TC.NewWorldUI:TC.UIWindow
local NewWorldUI = class("NewWorldUI", require("UIWindow"))

function NewWorldUI:__init()
    NewWorldUI.super.__init(self, require("UIDesign").getNewWorldUI())

    self._worldNameExists = {}
    self._canGenerateWorld = false
    self._isSSC = false
    self._gameMode = 0
    self._tipMode = 0
    self._validName = ""

    self:initContent()
end

function NewWorldUI:initContent()
    local worldNames = File.getAllSubFolders(Path.join(App.persistentDataPath, "worlds"))
    for _, name in pairs(worldNames) do
        self._worldNameExists[name] = true
    end
    UIText.cast(self.root:getChild("layer.btn_gm.lb_caption")).color = Color.Gray

    UIInputField.cast(self.root:getChild("layer.panel_name.edit")):addTextChangedListener({ self._onNameChanged, self })
    self.root:getChild("layer.btn_ok"):addTouchUpListener({ self.onOkButtonClicked, self })
    self.root:getChild("layer.btn_gm"):addTouchUpListener({ self._onGameModeButtonClicked, self })
    self.root:getChild("layer.btn_bp"):addTouchUpListener({ self._onSideButtonClicked, self })
    self.root:getChild("layer.btn_back"):addTouchUpListener({ self.onCancelClicked, self })
    self:_checkNameValid("")
end

function NewWorldUI:_onNameChanged(_, text)
    self:_checkNameValid(text)
end

function NewWorldUI:onCancelClicked()
    self.manager:playClickSound()
    self:closeWindow()
    require("WorldListUI").new()
end

function NewWorldUI:onOkButtonClicked()
    if self._canGenerateWorld and self._validName ~= "" then
        local worldData = WorldData.new()
        local seedString = UIInputField.cast(self.root:getChild("layer.panel_seed.edit")).text

        worldData.worldName = self._validName
        worldData.worldSeed = WorldDataUtils.GenerateSeed(seedString)
        worldData.clientSideCharacters = not self._isSSC
        WorldDataUtils.Save(worldData)

        self.manager:playClickSound()
        self:closeWindow()
        require("WorldListUI").new()
    end
end

function NewWorldUI:_onGameModeButtonClicked(node)
    do return end
    if self._tipMode == 1 then
        self._gameMode = self._gameMode + 1
        if self._gameMode >= 3 then
            self._gameMode = 0
        end
    end
    self._tipMode = 1
    local title = ""
    local tipText = ""
    if self._gameMode == 0 then
        title = "????????????"
        tipText = "???????????????????????????"
    elseif self._gameMode == 1 then
        title = "????????????"
        tipText = "???????????????????????????????????????"
    elseif self._gameMode == 2 then
        title = "????????????"
        tipText = "???????????????????????????????????????"
    end
    self.manager:playClickSound()
    UIText.cast(node:getChild("lb_caption")).text = title
    UIText.cast(self.root:getChild("layer.panel_info.lb_info")).text = tipText
end

function NewWorldUI:_onSideButtonClicked(node)
    if self._tipMode == 2 then
        self._isSSC = not self._isSSC
    end
    self._tipMode = 2
    local title
    local tipText
    if self._isSSC then
        title = "??????????????????"
        --tipText = "[SSC Mode] Starts with new character."
        tipText = "[SSC] ??????????????????????????????????????????."
    else
        title = "??????????????????"
        tipText = "[CSC] ????????????????????????????????????."
    end
    self.manager:playClickSound()
    UIText.cast(node:getChild("lb_caption")).text = title
    UIText.cast(self.root:getChild("layer.panel_info.lb_info")).text = tipText
end

---_checkNameValid
---@param text string
function NewWorldUI:_checkNameValid(text)
    local checker = require("util.ValidChecker")

    self._tipMode = 0
    local tipText = ""
    self._canGenerateWorld = false
    local len = utf8string.len(text)
    if len == 0 then
        tipText = "?????????????????????"
    elseif not (len >= 1 and len <= 20) then
        tipText = "????????????????????????20?????????"
    elseif not checker.checkValidFileName(text) then
        tipText = "???????????????????????????"
    elseif self._worldNameExists[text] then
        tipText = "??????????????????????????????"
    else
        tipText = "??????????????????!"
        self._canGenerateWorld = true
        self._validName = text
    end
    UIText.cast(self.root:getChild("layer.panel_info.lb_info")).text = tipText
    local btnColor = Color.Gray
    if self._canGenerateWorld then
        btnColor = Color.White
    end
    UIText.cast(self.root:getChild("layer.btn_ok.lb_caption")).color = btnColor
end

function NewWorldUI:closeWindow()
    NewWorldUI.super.closeWindow(self)
end

return NewWorldUI