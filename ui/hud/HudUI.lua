---@class TC.HudUI:TC.UIWindow
local HudUI = class("HudUI", require("ui.UIWindow"))
local InputControl = require("client.InputControl")
local UISpritePool = require("ui.UISpritePool")
local UIUtil = require("ui.UIUtil")
local UISlotOp = require("ui.UISlotOp")
local SettingsData = require("settings.SettingsData")
local GPlayer = require("player.GPlayer")
local MusicSystem = require("client.MusicSystem")
local UIDefault = require("ui.UIDefault")

local s_instance
local ADVANCEMENT_TIP_FADE_IN_TIME = 32
local ADVANCEMENT_TIP_FADE_OUT_TIME = 64 * 5
local ADVANCEMENT_TIP_FADE_IDLE_TIME = 32
local ADVANCEMENT_TIP_FADE_OUT_START_TIME = ADVANCEMENT_TIP_FADE_IN_TIME + ADVANCEMENT_TIP_FADE_OUT_TIME
local ADVANCEMENT_TIP_TOTAL_TIME = ADVANCEMENT_TIP_FADE_OUT_START_TIME + ADVANCEMENT_TIP_FADE_IDLE_TIME

---@class TC.AdvancementTipData
local AdvancementTipData = class("AdvancementTipData")

---__init
---@param node UINode
---@param itemStack ItemStack
function AdvancementTipData:__init(node, itemStack)
    self.node = node
    self.itemStack = itemStack
    self.tickTime = 0
end

function HudUI:__init()
    HudUI.super.__init(self, require("ui.UIDesign").getHudUI(), UIDefault.GROUP_GAME_HUD)
    s_instance = self
    self._centerTouchTicks = 0
    self._lastCenterTouchPos = nil

    self._debugLabel = UIText.cast(self.root:getChild("lb_debug"))
    self._lbHp = UIText.cast(self.root:getChild("lb_hp"))
    self._lbMana = UIText.cast(self.root:getChild("lb_mana"))
    self._lbExpLevel = UIText.cast(self.root:getChild("panel_shortcut.lb_exp"))
    self._lbItemName = UIText.cast(self.root:getChild("panel_shortcut.lb_item_name"))

    self._panelBtn = self.root:getChild("panel_btn")
    self._btnFrontWall = UIButton.cast(self._panelBtn:getChild("check_box_front_or_wall"))
    self._btnSmart = UIButton.cast(self._panelBtn:getChild("check_box_smart"))
    self._btnBackpack = UIButton.cast(self._panelBtn:getChild("button_backpack"))
    self._btnRecipe = UIButton.cast(self._panelBtn:getChild("button_recipe"))
    self._btnOption = UIButton.cast(self._panelBtn:getChild("button_option"))
    self._btnAdvancement = UIButton.cast(self._panelBtn:getChild("button_task"))

    self._jl = UIJoystick.cast(self.root:getChild("joystick_left"))
    self._jr = UIJoystick.cast(self.root:getChild("joystick_right"))
    self._jc = UIJoystick.cast(self.root:getChild("joystick_center"))

    self._musicNameCR = UIText.cast(self.root:getChild("lb_music_name"))
    self._musicAuthorCR = UIText.cast(self.root:getChild("lb_music_author"))

    self._advancementPanel = UIPanel.cast(self.root:getChild("panel_advancements"))
    self._baseAdvancementTipNode = UIPanel.cast(self._advancementPanel:getChild("panel_advancement_tip"))
    self._advancementTips = {} ---@type TC.AdvancementTipData[]
    self._advancementTipX = self._baseAdvancementTipNode.positionX
    self._advancementTipHeight = self._baseAdvancementTipNode.height

    local uiSpritePool = UISpritePool.getInstance()
    self._textureAim = uiSpritePool:get("tc:aim").textureLocation
    self._textureHealth = uiSpritePool:get("tc:health").textureLocation
    self._textureHunger = uiSpritePool:get("tc:hunger").textureLocation
    self._textureMana = uiSpritePool:get("tc:mana").textureLocation
    self._textureExpBar = uiSpritePool:get("tc:exp_bar").textureLocation

    self._lastHp = -1
    self._lastMaxHp = -1
    self._lastMana = -1
    self._lastMaxMana = -1
    self._lastExpLevel = -1
    self._lastHeldIndex = -1
    self._lastManaIconLines = 0
    self._manaIconLines = 0
    self._tickTime = 0
    self._itemNameHideTickTime = 0

    self._initPlayerData = false
    self._shortcutSlotNodes = {}

    local inputControl = InputControl.getInstance()
    self._backpackHotKey = Input.keyboard:getHotKeys(inputControl.keyMap.Backpack):addListener({ HudUI._tryOpenBackpack, self })
    self._taskHotKey = Input.keyboard:getHotKeys(inputControl.keyMap.Task):addListener({ HudUI._tryOpenTask, self })
    self._taskHotKey = Input.keyboard:getHotKeys(inputControl.keyMap.Nei):addListener({ HudUI._tryOpenNei, self })
    self._optionHotKey = Input.keyboard:getHotKeys(inputControl.keyMap.Esc):addListener({ HudUI._onEsc, self })
    self._optionHotKey = Input.keyboard:getHotKeys(inputControl.keyMap.Ctrl):addListener({ HudUI._onCtrl, self })
    self:initContent()
end

function HudUI:initContent()
    local inputControl = InputControl.getInstance()

    local jl = self._jl
    local jr = self._jr
    local jc = self._jc
    inputControl.virtualJoystickLeftNode = jl
    inputControl.virtualJoystickRightNode = jr
    inputControl.virtualJoystickCenterNode = jc
    -- catch all touches for map operation
    self.root.touchable = true
    self.root:addTouchDownListener({ HudUI.onMapTouchDown, self })
    jc:addTouchDownListener({ HudUI.onTouchDownCenter, self })
    jc:addTouchUpAfterMoveListener({ HudUI.onTouchUpCenter, self })

    self.root:getChild("panel_shortcut"):getPreDrawLayer(0):addListener({ HudUI._onRenderExpBar, self })
    self.root:getChild("panel_element_base"):getPreDrawLayer(0):addListener({ HudUI._onRenderHudElement, self })

    self._btnFrontWall:addTouchUpListener({ HudUI._onFrontWallClicked, self })
    self._btnSmart:addTouchUpListener({ HudUI._onSmartClicked, self })
    self._btnBackpack:addTouchUpListener({ HudUI._onBackpackClicked, self })
    self._btnRecipe:addTouchUpListener({ HudUI._onRecipeBtnClicked, self })
    self._btnOption:addTouchUpListener({ HudUI._onOptionBtnClicked, self })
    self._btnAdvancement:addTouchUpListener({ HudUI._onTaskBtnClicked, self })

end

function HudUI.showAdvancementTip(advancementID)
    if s_instance == nil then
        return
    end
    s_instance:createAdvancementTipUI(advancementID)
end

function HudUI:createAdvancementTipUI(advancementID)
    local advancement = AdvancementUtils.Get(advancementID)
    local itemStack = ItemStack.new(ItemRegistry.GetItemByID(advancement.itemID))
    local node = self._baseAdvancementTipNode:clone()
    UIText.cast(node:getChild("lb_sub_caption")).text = LangUtils.AdvancementName(advancementID)
    node:getChild("panel_icon"):getPostDrawLayer(0):addListener(
            { UISlotOp.itemStackOnRenderWithShadow, itemStack })
    node.visible = true
    self._advancementPanel:addChild(node)
    table.insert(self._advancementTips, AdvancementTipData.new(node, itemStack))
end

function HudUI._changeBtnSprite(btn, flag, spriteName1, spriteName2)
    local spriteName = flag and spriteName1 or spriteName2

    local sprite = UISpritePool.getInstance():get(spriteName)
    local color = Color.new(255, 255, 255, 200)
    btn.targetSprite = sprite
    btn.targetSprite.color = color
    btn.selectedSprite = sprite
    btn.selectedSprite.color = color
    btn.pressedSprite = sprite
    btn.pressedSprite.color = color
    btn.highlightedSprite = sprite
    btn.highlightedSprite.color = color
end

function HudUI:_onFrontWallClicked()
    self.manager:playClickSound()
    local inputControl = InputControl.getInstance()
    inputControl.operatingWall = not inputControl.operatingWall
    HudUI._changeBtnSprite(self._btnFrontWall, inputControl.operatingWall,
            "tc:check_box_front_or_wall_2",
            "tc:check_box_front_or_wall"
    )
end

function HudUI:_onSmartClicked()
    self.manager:playClickSound()
    local inputControl = InputControl.getInstance()
    inputControl.isSmart = not inputControl.isSmart
    HudUI._changeBtnSprite(self._btnSmart, inputControl.isSmart,
            "tc:check_box_smart_2",
            "tc:check_box_smart"
    )
end

function HudUI:_onBackpackClicked()
    self:_tryOpenBackpack()
    self.manager:playClickSound()
end

function HudUI:_tryOpenBackpack()
    if self.manager:hasUIGroup(UIDefault.GROUP_GAME_WINDOW) then
        return
    end

    local player = PlayerUtils.GetCurrentClientPlayer()
    if not player then
        return
    end
    local GuiID = require("ui.GuiID")
    if player:IsGuiOpened(Mod.current, GuiID.Backpack) then
        return
    end
    player:OpenGuiRemote(Mod.current, GuiID.Backpack, player.centerXi, player.centerYi)
end

function HudUI:_onTaskBtnClicked()
    self:_tryOpenTask()
    self.manager:playClickSound()
end

function HudUI:_tryOpenTask()
    if self.manager:hasUIGroup(UIDefault.GROUP_GAME_WINDOW) then
        return
    end

    local player = PlayerUtils.GetCurrentClientPlayer()
    if not player then
        return
    end
    local GuiID = require("ui.GuiID")
    if player:IsGuiOpened(Mod.current, GuiID.Advancement) then
        return
    end
    player:OpenGui(Mod.current, GuiID.Advancement, player.centerXi, player.centerYi)
end

function HudUI:_tryOpenNei()
    if self.manager:hasUIGroup(UIDefault.GROUP_GAME_WINDOW) then
        return
    end
    require("ui.nei.NeiUI").new()
end

function HudUI:_openRecipe()
    self:_tryOpenNei()
end

function HudUI:_onRecipeBtnClicked()
    self.manager:playClickSound()
    self:_openRecipe()
end

function HudUI:_onOptionBtnClicked()
    self.manager:playClickSound()
    self:_tryOpenOption()
end

function HudUI:_onEsc()
    self:_tryOpenOption()
end

function HudUI:_onCtrl()
    if self.manager:hasUIGroup(UIDefault.GROUP_GAME_WINDOW) then
        return
    end
    self:_onSmartClicked()
end

function HudUI:_tryOpenOption()
    if self.manager:hasUIGroup(UIDefault.GROUP_GAME_WINDOW) then
        return
    end
    if self.manager:isWindowOpened("OptionUI") then
        return
    end
    require("ui.OptionUI").new()
end

function HudUI:_checkPlayerData()
    if self._initPlayerData then
        return
    end
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        self._initPlayerData = true
        local backpackInventory = player.backpackInventory
        local panelShortcut = self.root:getChild("panel_shortcut")
        for i = 1, 10 do
            local slotNode = UIButton.cast(panelShortcut:getChildByTag(i - 1))
            table.insert(self._shortcutSlotNodes, slotNode)
            UIUtil.hookSlotView(slotNode, backpackInventory:GetSlot(i - 1), false)
            slotNode:addTouchDownListener({ HudUI._onSlotTouchDown, self, i - 1 })
        end
        self:refreshShortcut(player)
    end
end

function HudUI:_onSlotTouchDown(index, _, _)
    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then
        player.heldSlotIndex = index
        self:refreshShortcut(player)
    end
end

---@param player Player
function HudUI:refreshShortcut(player)
    local heldIndex = player.heldSlotIndex
    if self._lastHeldIndex == heldIndex then
        return
    end
    self._lastHeldIndex = heldIndex
    for i = 1, #self._shortcutSlotNodes do
        self._shortcutSlotNodes[i].selected = (i - 1 == heldIndex)
    end
    local itemName = ""
    local slot = player.backpackInventory:GetSlot(heldIndex)
    if slot.hasStack then
        local itemId = slot:GetStack():GetItem().id
        itemName = LangUtils.ItemName(itemId)
    end
    self._lbItemName.text = itemName
    self._lbItemName.color = Color.new(193, 187, 220)
    self._lbItemName.visible = true
    self._itemNameHideTickTime = 64
end

---onTouchDownCenter
---@param touch Touch
function HudUI:onTouchDownCenter(_, touch)
    self._lastCenterTouchPos = touch.position:clone()
    self._centerTouchTicks = 64
end

---@param touch Touch
function HudUI:onTouchUpCenter(_, touch)
    if self._lastCenterTouchPos ~= nil then
        local d = touch.position:getDistance(self._lastCenterTouchPos)
        if d < 6 then
            self:activateMapClicking(touch.position)
        end
    end
end

function HudUI:updateTouchTicking()
    if self._centerTouchTicks == 0 then
        self._lastCenterTouchPos = nil
    elseif self._centerTouchTicks > 0 then
        self._centerTouchTicks = self._centerTouchTicks - 1
    end
end

---activateMapClicking
---@param touchPosition Vector2
function HudUI:activateMapClicking(touchPosition)
    local inputControl = InputControl.getInstance()
    inputControl.isMapClicking = true
    inputControl.touchMapPosition = touchPosition:clone()
    --print("touch map", inputControl.touchMapPosition)
end

---onMapTouchDown
---@param touch Touch
function HudUI:onMapTouchDown(_, touch)
    if not SettingsData.isMobileOperation then
        if not Input.mouse.isRightButtonPressed then
            return
        end
    end

    self:activateMapClicking(touch.position)
end

function HudUI:update()
    --self._debugLabel.text = string.format("FPS:%d Logic:%d Batches:%d Triangles:%d",
    --        IntegratedClient.main.fps,
    --        IntegratedClient.main.gameSpeed,
    --        GraphicsDevice.drawCalls,
    --        GraphicsDevice.primitiveCount
    --)
    --self._debugLabel.isRichText = true
    self._debugLabel.visible = false

    local showMobileLayout = SettingsData.isMobileOperation
    self._jl.visible = showMobileLayout
    self._jr.visible = showMobileLayout
    self._jc.visible = showMobileLayout
    self._panelBtn.visible = showMobileLayout

    local inputControl = InputControl.getInstance()
    inputControl.isPcMouseAtMap = false

    if not SettingsData.isMobileOperation then
        local pointer = self.manager.canvas:screenPointToCanvasPoint(Input.mouse.position)
        local node = self.manager.baseLayer:getPointedNode(pointer)
        if node:valid() then
            if node.name == "hud_ui" then
                inputControl.isPcMouseAtMap = true
            end
        end
    end

    if SettingsData.showMusicInfo and MusicSystem.getInstance().musicCopyright ~= nil and Audio.musicVolume > 0.3 then
        local cr = MusicSystem.getInstance().musicCopyright
        self._musicNameCR.visible = true
        self._musicAuthorCR.visible = true

        self._musicNameCR.text = cr.title
        self._musicAuthorCR.text = cr.author
    else
        self._musicNameCR.visible = false
        self._musicAuthorCR.visible = false
    end
    -- 先屏蔽
    self._musicNameCR.visible = false
    self._musicAuthorCR.visible = false

    self:_checkPlayerData()

    local player = PlayerUtils.GetCurrentClientPlayer()
    if player then

        self:refreshShortcut(player)

        if not (player.health == self._lastHp and player.maxHealth == self._lastMaxHp) then
            self._lastHp = player.health
            self._lastMaxHp = player.maxHealth
            self._lbHp.text = string.format("<c=#ED4541FF>%d/%d</c>", player.health, player.maxHealth)
            self._lbHp.isRichText = true
            self._lbHp:setPosition(16, 46)
        end

        if not (player.mana == self._lastMana and player.maxMana == self._lastMaxMana and self._manaIconLines == self._lastManaIconLines) then
            self._lastMana = player.mana
            self._lastHp = player.health
            self._lastManaIconLines = self._manaIconLines
            self._lbMana.text = string.format("<c=#5D94FFFF>%d/%d</c>", player.mana, player.maxMana)
            self._lbMana.isRichText = true
            self._lbMana:setPosition(16, 100 + (self._manaIconLines - 1) * 32)
        end

        if not (player.expLevel == self._lastExpLevel) then
            self._lastExpLevel = player.expLevel
            self._lbExpLevel.text = string.format("<c=#FFFF00FF>%d</c>", player.expLevel)
            self._lbExpLevel.isRichText = true
        end
    end
    self._tickTime = self._tickTime + 1
    if self._itemNameHideTickTime > 0 then
        self._itemNameHideTickTime = self._itemNameHideTickTime - 1
        if self._itemNameHideTickTime == 0 then
            self._lbItemName.visible = false
        end
    end

    local currentX = self._advancementTipX
    local currentY = 0
    local TIP_HEIGHT = self._advancementTipHeight
    for i = #self._advancementTips, 1, -1 do
        local data = self._advancementTips[i]
        data.tickTime = data.tickTime + 1
        local t = data.tickTime
        if t >= ADVANCEMENT_TIP_TOTAL_TIME then
            self._advancementPanel:removeChild(data.node)
            table.remove(self._advancementTips, i)
        else
            local deltaY = 0
            if t < ADVANCEMENT_TIP_FADE_IN_TIME then
                deltaY = (t * 1.0 / ADVANCEMENT_TIP_FADE_IN_TIME - 1.0) * TIP_HEIGHT
            elseif t < ADVANCEMENT_TIP_FADE_OUT_START_TIME then
                deltaY = 0
            else
                deltaY = ((ADVANCEMENT_TIP_TOTAL_TIME - t) * 1.0 / ADVANCEMENT_TIP_FADE_IN_TIME - 1.0) * TIP_HEIGHT
            end
            currentY = currentY + deltaY
            data.node:setPosition(currentX, currentY)
            currentY = currentY + TIP_HEIGHT
        end
    end
end

function HudUI:_onRenderHudElement()
    local player = PlayerUtils.GetCurrentClientPlayer()
    if not player then
        return
    end

    self:_renderAim(player)
    self:_renderHp(player)
    self:_renderMana(player)
    self:_renderHunger(player)
end

function HudUI:renderGaming()

end

---@param player Player
function HudUI:_renderAim(player)
    -- only render in mobile
    if not SettingsData.isMobileOperation then
        return
    end
    local globalPlayer = GPlayer.GetInstance(player)
    if not globalPlayer.showingAimPoint then
        return
    end

    local show = false
    local inputControl = InputControl.getInstance()
    if inputControl.aimMode == 1 then
        if inputControl.aimDistance > 0.05 and inputControl.aimPressing then
            show = true
        end
    else
        show = true
    end
    if show and not (globalPlayer.aimOffsetX == 0 and globalPlayer.aimOffsetY == 0) then
        local cutRect = Rect.new(0, 0, 32, 32)
        local drawX = player.centerX + globalPlayer.aimOffsetX - 16 - MiscUtils.screenX
        local drawY = player.centerY + globalPlayer.aimOffsetY - 16 - MiscUtils.screenY
        Sprite.draw(self._textureAim, Vector2.new(drawX, drawY), cutRect, Color.White)
    end
end

---@param player Player
function HudUI:_renderHp(player)
    if player.gameMode == GameMode.Creative then
        return
    end

    local FIX_LEFT_X = 16
    local FIX_TOP_Y = 16
    local VALUE_PRE_HEART = 20
    local ALPHA_EMPTY = 32
    local SCALE_EMPTY = 0.75
    local DEFAULT_STEP = 26

    local maxHp = player.maxHealth
    local hp = player.health
    local cnt = math.ceil(maxHp * 1.0 / VALUE_PRE_HEART)
    local index = math.min(math.floor(hp / VALUE_PRE_HEART), cnt - 1)
    local drawX, drawY = FIX_LEFT_X, FIX_TOP_Y
    local cutRect = Rect.new(0, 0, 32, 32)
    local color = Color.White
    local spriteEx = SpriteExData.new()
    for i = 0, cnt - 1 do
        local scale = 1
        local alpha = 255
        if i == index then
            if hp ~= maxHp then
                scale = 1 + Utils.SinValue(self._tickTime, 64) * 0.0625
                alpha = math.floor(ALPHA_EMPTY + (255 - ALPHA_EMPTY) * (hp - index * VALUE_PRE_HEART) / VALUE_PRE_HEART)
            end
        elseif i > index then
            scale = SCALE_EMPTY
            alpha = ALPHA_EMPTY
        end

        color = Color.new(255, 255, 255, alpha)
        spriteEx.scaleRateX = scale
        spriteEx.scaleRateY = scale
        local offset = 32 * -(scale - 1) / 2
        local realDrawX = math.floor(drawX + offset)
        local realDrawY = math.floor(drawY + offset)
        Sprite.draw(self._textureHealth, Vector2.new(realDrawX, realDrawY), cutRect, color, spriteEx, 0)

        local step = DEFAULT_STEP
        if maxHp > 100 then
            step = step - math.floor((maxHp - 100) / 40)
        end
        step = math.max(step, 14)
        drawX = drawX + step
    end
end

---@param player Player
function HudUI:_renderHunger(player)
    if player.gameMode == GameMode.Creative then
        return
    end

    local VALUE_PRE_HEART = 10
    local MAX_HUNGER = 100
    local DEFAULT_STEP = 26
    local ALPHA_EMPTY = 32
    local SCALE_EMPTY = 0.75

    local hunger = player.foodLevel
    local cnt = math.ceil(MAX_HUNGER * 1.0 / VALUE_PRE_HEART)
    local index = math.min(math.floor(hunger / VALUE_PRE_HEART), cnt - 1)

    local FIX_RIGHT_X = GameWindow.displayResolution.width - 16
    local FIX_TOP_Y = 16
    local drawX, drawY = FIX_RIGHT_X - DEFAULT_STEP, FIX_TOP_Y
    local cutRect = Rect.new(0, 0, 32, 32)
    local color = Color.White
    local spriteEx = SpriteExData.new()
    for i = 0, cnt - 1 do
        local scale = 1
        local alpha = 255
        if i == index then
            if hunger ~= MAX_HUNGER then
                scale = 1 + Utils.SinValue(self._tickTime, 64) * 0.0625
                alpha = math.floor(ALPHA_EMPTY + (255 - ALPHA_EMPTY) * (hunger - index * VALUE_PRE_HEART) / VALUE_PRE_HEART)
            end
        elseif i > index then
            scale = SCALE_EMPTY
            alpha = ALPHA_EMPTY
        end

        color = Color.new(255, 255, 255, alpha)
        spriteEx.scaleRateX = scale
        spriteEx.scaleRateY = scale
        local offset = 32 * -(scale - 1) / 2
        local realDrawX = math.floor(drawX + offset)
        local realDrawY = math.floor(drawY + offset)
        Sprite.draw(self._textureHunger, Vector2.new(realDrawX, realDrawY), cutRect, color, spriteEx, 0)
        drawX = drawX - DEFAULT_STEP
    end
end

---@param player Player
function HudUI:_renderMana(player)
    if player.gameMode == GameMode.Creative then
        return
    end

    local FIX_LEFT_X = 16
    local FIX_TOP_Y = 70
    local VALUE_PRE_HEART = 20
    local ALPHA_EMPTY = 128
    local SCALE_EMPTY = 0.75
    local DEFAULT_STEP = 26
    local DEFAULT_STEP_Y = 32
    local DISPLAY_DISTANCE_PRE_LINE = 260

    local maxMana = player.maxMana
    local mana = player.mana
    local cnt = math.ceil(maxMana * 1.0 / VALUE_PRE_HEART)
    local index = math.min(math.floor(mana / VALUE_PRE_HEART), cnt - 1)
    local drawX, drawY = FIX_LEFT_X, FIX_TOP_Y
    local maxDrawX = FIX_LEFT_X + DISPLAY_DISTANCE_PRE_LINE
    local cutRect = Rect.new(0, 0, 32, 32)
    local color = Color.White
    local spriteEx = SpriteExData.new()
    self._manaIconLines = 1
    for i = 0, cnt - 1 do
        local scale = 1
        local alpha = 255
        if i == index then
            if mana ~= maxMana then
                scale = 1 + Utils.SinValue(self._tickTime, 64) * 0.0625
                alpha = math.floor(ALPHA_EMPTY + (255 - ALPHA_EMPTY) * (mana - index * VALUE_PRE_HEART) / VALUE_PRE_HEART)
            end
        elseif i > index then
            scale = SCALE_EMPTY
            alpha = ALPHA_EMPTY
        end

        color = Color.new(255, 255, 255, alpha)
        spriteEx.scaleRateX = scale
        spriteEx.scaleRateY = scale
        local offset = 32 * -(scale - 1) / 2
        local realDrawX = math.floor(drawX + offset)
        local realDrawY = math.floor(drawY + offset)
        Sprite.draw(self._textureMana, Vector2.new(realDrawX, realDrawY), cutRect, color, spriteEx, 0)

        local step = DEFAULT_STEP
        drawX = drawX + step
        if drawX >= maxDrawX then
            drawX = FIX_LEFT_X
            drawY = drawY + DEFAULT_STEP_Y
            if i < cnt - 1 then
                self._manaIconLines = self._manaIconLines + 1
            end
        end
    end
end

---@param node UINode
---@param canvasPos Vector2
function HudUI:_onRenderExpBar(node, canvasPos)
    local player = PlayerUtils.GetCurrentClientPlayer()
    if not player then
        return
    end
    local needExp = player:GetLevelNeedExp(player.expLevel)
    if needExp <= 0 then
        return
    end

    local barWidth, barHeight = 560, 12
    local drawX = canvasPos.x + node.positionInCanvas.x
    local drawY = canvasPos.y + node.positionInCanvas.y - barHeight - 4
    local drawPos = Vector2.new(drawX, drawY)

    local remainExp = player.remainExp

    local rate = math.min(1.0, math.max(0.0, remainExp * 1.0 / needExp))
    local cutRectBack = Rect.new(0, barHeight, barWidth, barHeight)
    local cutRectFront = Rect.new(0, 0, barWidth * rate, barHeight)
    Sprite.draw(self._textureExpBar, drawPos, cutRectBack, Color.White)
    Sprite.draw(self._textureExpBar, drawPos, cutRectFront, Color.White)
end

function HudUI:closeWindow()
    if self._backpackHotKey then
        Input.keyboard:getHotKeys(InputControl.getInstance().keyMap.Backpack):removeListener(self._backpackHotKey)
        self._backpackHotKey = nil
    end
    if self._taskHotKey then
        Input.keyboard:getHotKeys(InputControl.getInstance().keyMap.Task):removeListener(self._taskHotKey)
        self._taskHotKey = nil
    end
    if self._optionHotKey then
        Input.keyboard:getHotKeys(InputControl.getInstance().keyMap.Esc):removeListener(self._optionHotKey)
        self._optionHotKey = nil
    end
    HudUI.super.closeWindow(self)
    s_instance = nil
end

return HudUI