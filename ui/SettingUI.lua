---@class TC.SettingUI:TC.UIWindow
local SettingUI = class("SettingUI", require("UIWindow"))
local UIUtil = require("UIUtil")
local Settings = require("settings.Settings")

function SettingUI:__init(closeCallback)
    SettingUI.super.__init(self, require("UIDesign").getSettingUI(), require("ui.UIDefault").GROUP_GAME_WINDOW)
    self._closeCallback = closeCallback
    self._settingInstance = Settings.getInstance()
    self._config = self._settingInstance.uiConfig

    self._infoList = UIScrollView.cast(self.root:getChild("layer.info_list"))
    self._panelSlider = self._infoList:getChild("panel_slider")
    self._panelBool = self._infoList:getChild("panel_bool")
    self._panelHold = self._infoList:getChild("panel_hold")

    self._indexSelected = 1
    self._itemNodes = {}
    self._sliderSoundTicks = 0
    self:initContent()
end

function SettingUI:initContent()
    local panelList = self.root:getChild("layer.panel_list")
    local panelItem = panelList:getChild("panel_item")
    self.itemSize = Size.new(panelItem.width, panelItem.height)
    UIUtil.setTable(panelList, self, true, 1)

    self.root:getChild("layer.btn_ok"):addTouchUpListener({ self._onBackClicked, self })

    self:updateSelection()
end

function SettingUI:_getTableElementCount()
    return #self._config
end

function SettingUI:_getTableElementSize()
    return self.itemSize
end

---_setTableElement
---@param node UINode
---@param index number
function SettingUI:_setTableElement(node, index)
    node.tag = index

    local data = self._config[index]
    local lbName = UIText.cast(node:getChild("lb_group_name"))
    lbName.text = data.name

    node:addTouchUpListener({ self._onElementClicked, self })
    table.insert(self._itemNodes, node)
end

---_onElementClicked
---@param node UINode
---@param _ Touch
function SettingUI:_onElementClicked(node)
    local index = node.tag
    if self._indexSelected ~= index then
        self.manager:playClickSound()
        self._indexSelected = index
        self:updateSelection()
    end
end

function SettingUI:updateSelection()
    ---@param node UINode
    for _, node in pairs(self._itemNodes) do
        local show = false
        if node.tag == self._indexSelected then
            show = true
        end
        node:getChild("img_selected").visible = show
    end
    self:updateInfoList()
end

function SettingUI:updateInfoList()
    self._panelSlider.visible = false
    self._panelBool.visible = false
    self._panelHold:removeAllChildren()
    local elements = self._config[self._indexSelected].elements
    local posY = 0
    for i, element in ipairs(elements) do
        local node ---@type UINode

        if element.type == "Slider" then
            node = self._panelSlider:clone()
            local s = UISlider.cast(node:getChild("slider"))
            if element.maxValue ~= nil then
                s.maxValue = element.maxValue
            end
            if element.minValue ~= nil then
                s.minValue = element.minValue
            end
            if element.getter ~= nil then
                s.value = element.getter()
            end
            s.valueStep = 1
            if element.valueStep ~= nil then
                s.valueStep = element.valueStep
            end
            s:addValueChangedListener({ self._onSliderChanged, self, i })
        elseif element.type == "Boolean" then
            node = self._panelBool:clone()
            local s = UISwitch.cast(node:getChild("sw"))
            if element.getter ~= nil then
                s:setSelected(element.getter(), false)
            end
            s:addSelectChangedListener({ self._onSwitchChanged, self, i })
        end

        UIText.cast(node:getChild("lb_title")).text = element.name

        self._panelHold:addChild(node)
        node.visible = true
        node.positionY = posY
        posY = posY + node.height
    end
    self._panelHold.height = posY

    self._infoList:ScrollToTop()
    local tmpSize = Size.new(self._infoList.viewSize.width, self._panelHold.height)
    tmpSize.height = math.max(tmpSize.height, self._infoList.height)
    self._infoList.viewSize = tmpSize
    self._infoList:ScrollToTop()
end

function SettingUI:_onSwitchChanged(index, _, selected)
    self.manager:playClickSound()
    local elements = self._config[self._indexSelected].elements
    local element = elements[index]
    if element.setter ~= nil then
        element.setter(selected)
    end
end

function SettingUI:_onSliderChanged(index, _, value)
    local elements = self._config[self._indexSelected].elements
    local element = elements[index]
    if element.setter ~= nil then
        element.setter(value)
    end
    self._sliderSoundTicks = self._sliderSoundTicks + 1
    if self._sliderSoundTicks > 8 then
        self._sliderSoundTicks = 0
        SoundUtils.PlaySoundGroup(Reg.SoundGroupID("wood"))
    end
end

function SettingUI:_onBackClicked()
    self.manager:playClickSound()
    Settings.saveData()
    self:closeWindow()
end

function SettingUI:closeWindow()
    if self._closeCallback ~= nil then
        self._closeCallback()
    end
    SettingUI.super.closeWindow(self)
end

return SettingUI