---@class TC.TipUI:TC.UIWindow
local TipUI = class("TipUI", require("UIWindow"))

---@type TC.TipUI
local s_tipUI

function TipUI.generate(contentTable, keepTicks, showTag)
    keepTicks = keepTicks or 128
    -- TEST CODE
    contentTable = contentTable or {
        "Copper Axe",
        " ",
        "Durability: 6666/9999",
        "<c=#9c9c9cFF>+3 Attack Damage</c>",
        "<c=#9c9c9cFF>+6 Crit Rate</c>",
        "普通速度",
        "普通攻击力",
        "Can be placed",
        "<c=#FFFF00FF>Debug Only</c>"
    }
    TipUI.close()
    s_tipUI = TipUI.new(keepTicks, contentTable, showTag)
    return s_tipUI
end

function TipUI.adaptPosition(pos)
    if s_tipUI ~= nil then
        s_tipUI:_adaptPosition(pos.x, pos.y)
    end
end

function TipUI.close()
    if s_tipUI ~= nil then
        s_tipUI:closeWindow()
    end
end

function TipUI.isShowing()
    return s_tipUI ~= nil
end

function TipUI.changeNewContent(contentTable)
    if s_tipUI ~= nil then
        s_tipUI:setNewContent(contentTable)
    end
end

function TipUI.getShowTag()
    if s_tipUI ~= nil then
        return s_tipUI.showTag
    end
    return 0
end

function TipUI.resetKeepTime()
    if s_tipUI ~= nil then
        s_tipUI:_resetKeepTime()
    end
end

function TipUI:__init(keepTicks, contentTable, showTag)
    TipUI.super.__init(self, require("UIDesign").getTipUI())
    if showTag == nil then
        showTag = 0
    end
    self.maxKeepTicks = keepTicks
    self.keepTicks = keepTicks
    self.contentTable = clone(contentTable)
    self.touchingPosition = Vector2.new()
    self.showTag = showTag
    self.baseLabel = UIText.cast(self.root:getChild("lb_tip"))
    self._totalLabels = 0
    self:_initContent()
end

function TipUI:_initContent()
    self:_setContent()
    self._schedule = IntegratedClient.main:createSchedule(0)
    IntegratedClient.main:getSchedule(self._schedule):addListener({ TipUI._onTick, self })
end

function TipUI:setNewContent(contentTable)
    if #self.contentTable == #contentTable then
        local same = true
        for i, str in ipairs(self.contentTable) do
            local str2 = contentTable[i]
            if str ~= str2 then
                same = false
                break
            end
        end
        if same then
            return
        end
    end
    self.contentTable = contentTable
    self:_setContent()
end

function TipUI:_setContent()
    local label = self.baseLabel
    label.visible = false
    local LINE_OFFSET = 2
    local maxTextWidth = 0
    local offsetY = label.positionY

    for i = 1, self._totalLabels do
        local node = self.root:getChild(string.format("content_%d", i))
        if node:valid() then
            node.visible = false
            self.root:removeChild(node)
        end
    end
    self._totalLabels = #self.contentTable

    -- generate all text from content table
    for i, str in ipairs(self.contentTable) do
        local currentLabel = self.root:getChild(string.format("content_%d", i))
        if not currentLabel:valid() then
            currentLabel = label:clone()
            currentLabel.name = string.format("content_%d", i)
            self.root:addChild(currentLabel)
        end

        currentLabel.visible = true
        currentLabel.isRichText = true
        currentLabel.text = str
        currentLabel.position = Vector2(label.positionX, offsetY)
        maxTextWidth = math.max(currentLabel.width, maxTextWidth)
        offsetY = offsetY + currentLabel.height + LINE_OFFSET
    end
    self.root:setSize(maxTextWidth + 20, offsetY + 6)
end

function TipUI:_onTick()
    self.keepTicks = self.keepTicks - 1
    if self.keepTicks <= 0 then
        self:closeWindow()
    end
end

function TipUI:_resetKeepTime()
    self.keepTicks = self.maxKeepTicks
end

---adaptPosition
---@param touchX double
---@param touchY double
function TipUI:_adaptPosition(touchX, touchY)
    if self.touchingPosition.x ~= touchX or self.touchingPosition.y ~= touchY then
        self.touchingPosition.x = touchX
        self.touchingPosition.y = touchY
        local size = self.root.size
        local globalWidth, globalHeight = GameWindow.displayResolution.width, GameWindow.displayResolution.height
        local uiWidth, uiHeight = size.width, size.height
        local newX, newY = touchX, touchY
        newX = touchX + 32
        newY = touchY - uiHeight * 0.75

        -- left boundary
        newX = math.max(newX, 32)
        -- right boundary
        if newX + uiWidth + 32 > globalWidth then
            newX = touchX - 32 - uiWidth
        end
        -- top boundary
        newY = math.max(newY, 32)
        -- bottom boundary
        if newY + uiHeight + 32 > globalHeight then
            newY = touchY - 32 - uiHeight
        end

        self.root.position = Vector2.new(newX, newY)
        self.root:applyMargin()
    end
end

function TipUI:closeWindow()
    TipUI.super.closeWindow(self)
    if self._schedule ~= nil then
        IntegratedClient.main:removeSchedule(self._schedule)
        self._schedule = nil
    end
    s_tipUI = nil
end

return TipUI