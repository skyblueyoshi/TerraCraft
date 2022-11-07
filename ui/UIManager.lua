---@class TC.UIManager
local UIManager = class("UIManager")
local OrderedArray = require("util.OrderedArray")
local UISpritePool = require("UISpritePool")
local MouseItemData = require("MouseItemData")
local SettingsData = require("settings.SettingsData")
local UILayerDefine = require("UILayerDefine")

local g_instance
---@return TC.UIManager
function UIManager.getInstance()
    if g_instance == nil then
        g_instance = UIManager.new()
    end
    return g_instance
end

function UIManager:__init()
    self.spritePool = UISpritePool.getInstance()
    self.canvasGameObject = nil
    self.canvas = nil
    self.baseLayers = {}  ---@type UINode[]
    self.baseLayer = nil
    self.debugCanvasGameObject = nil
    self.debugCanvas = nil
    self._windowsLoaded = OrderedArray.new()
    self.durableBarTexture = nil
    self.cursorTexture = nil
end

function UIManager:init()
    self.canvasGameObject = GameObject.instantiate()
    self.canvasGameObject.canvas:init()
    self.canvas = self.canvasGameObject.canvas.uiRoot

    for i = 1, UILayerDefine.Totals do
        local layerName = string.format("layer_%d", i)
        local panel = UIPanel.new(layerName)
        panel:setLeftMargin(0, true)
        panel:setRightMargin(0, true)
        panel:setTopMargin(0, true)
        panel:setBottomMargin(0, true)
        panel.autoStretchWidth = true
        panel.autoStretchHeight = true
        panel.touchable = false
        self.canvas:addChild(panel)
        table.insert(self.baseLayers, panel)
    end
    self.canvas:applyMargin()
    self.baseLayer = self.baseLayers[UILayerDefine.BaseLayer]

    self:initDebug()

    self:onWindowResize()
end

function UIManager:initDebug()
    self.debugCanvasGameObject = GameObject.instantiate()
    self.debugCanvasGameObject.canvas:init()
    self.debugCanvas = self.debugCanvasGameObject.canvas.uiRoot
    self.debugCanvas.touchable = false
    self.debugRect = nil
    self.debugPoint = nil

    local panel = UIPanel.new("panel")
    panel:setMarginEnabled(true, true, true, true)
    panel.autoStretchWidth = true
    panel.autoStretchHeight = true
    self.debugCanvas:addChild(panel)

    local textDebug = UIText.new("text", 0, 0, 32, 32)
    textDebug.horizontalOverflow = TextHorizontalOverflow.Overflow
    textDebug.color = Color.Yellow
    panel:addChild(textDebug)

    local textDebug2 = UIText.new("text2", 32, 180, 32, 32)
    textDebug2:setBottomMargin(100, true)
    textDebug2.horizontalOverflow = TextHorizontalOverflow.Overflow
    textDebug2.isRichText = true
    textDebug2.fontSize = 18
    panel:addChild(textDebug2)
end

---addWindowsLoaded
---@param uiWindow TC.UIWindow
---@return number
function UIManager:addWindowsLoaded(uiWindow)
    --self.canvas:addChild(uiWindow.root)
    self.baseLayer:addChild(uiWindow.root)
    return self._windowsLoaded:add(uiWindow)
end

function UIManager:removeWindowsLoaded(index)
    --self.canvas:removeChild(self._windowsLoaded:get(index).root)
    self.baseLayer:removeChild(self._windowsLoaded:get(index).root)
    self._windowsLoaded:remove(index)
end

---initUISpriteResources
---@param mod Mod
---@param uiSpriteResourcePathInMod string
function UIManager:initUISpriteResources(mod, uiSpriteResourcePathInMod)
    local searchPath = Path.join(mod.assetRootPath, uiSpriteResourcePathInMod)
    --print(searchPath)
    local texNames = AssetManager.getAllFiles(searchPath, ".png", true, false, true)
    for _, texPath in pairs(texNames) do
        local absPath = Path.join(searchPath, texPath) .. ".png"
        local texName = mod.modId .. ":" .. texPath
        UITexturePool.register(texName, TextureManager.load(absPath))
    end

    for _, texPath in pairs(texNames) do
        local texName = mod.modId .. ":" .. texPath
        local cfgPath = Path.join(searchPath, texPath) .. ".json"
        local sprite
        if AssetManager.isPathExist(cfgPath) then
            sprite = UISprite.new()
            local json = AssetManager.readAsString(cfgPath)
            sprite:fromJson(json)
        else
            sprite = UISprite.new(texName)
        end
        --print("loading sprite: " .. texName)
        self.spritePool:add(texName, sprite)
    end
end

function UIManager:postInit()
    self.durableBarTexture = self.spritePool:get("tc:durable").textureLocation
    self.cursorTexture = self.spritePool:get("tc:cursor2").textureLocation
    ---@param mod Mod
    for _, mod in each(Mod.modList) do
        local modIconPath = Path.join(mod.assetRootPath, "mod_icon.png")
        if AssetManager.isPathExist(modIconPath) then
            local texName = mod.modId .. ":__icon"

            UITexturePool.register(texName, TextureManager.load(modIconPath))
            local sprite = UISprite.new(texName)
            self.spritePool:add(texName, sprite)
        end
    end
end

function UIManager:update()
    if SettingsData.isShowUIDebug or SettingsData.isShowDebugInfo then
        self.debugCanvas.visible = true

        local lbText = UIText.cast(self.debugCanvas:getChild("panel.text"))
        local lbText2 = UIText.cast(self.debugCanvas:getChild("panel.text2"))
        lbText.visible = false
        lbText2.visible = false

        if SettingsData.isShowDebugInfo then
            lbText2.text = string.format("FPS:%d \nLogic:%d \nBatches:%d \nTriangles:%d",
                    IntegratedClient.main.fps,
                    IntegratedClient.main.gameSpeed,
                    GraphicsDevice.drawCalls,
                    GraphicsDevice.primitiveCount
            )
            lbText2.visible = true
        end

        if SettingsData.isShowUIDebug then
            local pointer = self.canvas:screenPointToCanvasPoint(Input.mouse.position)
            --local node = self.canvas:getPointedNode(pointer)
            local node = self.baseLayer:getPointedNode(pointer)

            if node:valid() then
                local nodeScreenPos = self.canvas:canvasPointToScreenPoint(node.positionInCanvas)
                local bound = RectFloat.new(nodeScreenPos.x, nodeScreenPos.y, node.size.width, node.size.height)
                self.debugRect = bound
                self.debugPoint = Vector2.new(
                        bound.x + bound.width * node.anchorPointX,
                        bound.y + bound.height * node.anchorPointY
                )
                lbText.fontSize = 16
                lbText.text = node.name ..
                        " (position:" .. tostring(node.positionInCanvas) ..
                        " size:" .. tostring(node.size) .. ")"
            else
                self.debugRect = nil
                self.debugPoint = nil
                lbText.text = "[UI Debug Mode]"
            end
            lbText.visible = true
        end
    else
        self.debugCanvas.visible = false
    end

    if ClientState.current == ClientState.Gaming then
        MouseItemData.getInstance():update()
    end
end

function UIManager:render()
    if SettingsData.isShowUIDebug then
        if self.debugRect ~= nil then
            GraphicsDevice.drawRect2D(self.debugRect, Color.new(255, 255, 0, 20))
            GraphicsDevice.drawRectHollow2D(self.debugRect, Color.new(255, 255, 0, 200))
        end
        if self.debugPoint ~= nil then
            GraphicsDevice.drawRect2D(RectFloat.new(self.debugPoint.x - 2, self.debugPoint.y - 2, 4, 4), Color.new(255, 255, 0, 200))
        end
    end
    if ClientState.current == ClientState.Gaming then
        MouseItemData.getInstance():render()
    end
    if not SettingsData.isMobileOperation then
        Sprite.beginBatch()
        local area = TextureManager.getSourceRect(self.cursorTexture)
        Sprite.draw(self.cursorTexture, Input.mouse.position, area, Color.White)
        Sprite.endBatch()
        Input.mouse:setCursorVisible(false)
    else
        Input.mouse:setCursorVisible(true)
    end

end

function UIManager:isWindowOpened(uiClassName)
    for _, index in ipairs(self._windowsLoaded.indices) do
        ---@type TC.UIWindow
        local uiWindow = self._windowsLoaded:get(index)
        if uiWindow.uiClassName == uiClassName then
            return true
        end
    end
    return false
end

function UIManager:hasUIGroup(uiGroup)
    for _, index in ipairs(self._windowsLoaded.indices) do
        ---@type TC.UIWindow
        local uiWindow = self._windowsLoaded:get(index)
        if uiWindow.uiGroup == uiGroup then
            return true
        end
    end
    return false
end

function UIManager:onWindowResize()
    self.canvas.size = GameWindow.displayResolution
    self.canvas:applyMargin()

    self.debugCanvas.size = GameWindow.displayResolution
    self.debugCanvas:applyMargin()

    for _, index in ipairs(self._windowsLoaded.indices) do
        ---@type TC.UIWindow
        local uiWindow = self._windowsLoaded:get(index)
        uiWindow:onWindowResize()
    end
end

function UIManager:_onEscPressed()
    local lastEscWindow = self:getLastAllowEscWindow()
    if lastEscWindow == nil then
        return
    end
    lastEscWindow:closeWindow()
end

function UIManager:getLastAllowEscWindow()
    local lastEscWindow
    for _, index in ipairs(self._windowsLoaded.indices) do
        ---@type TC.UIWindow
        local uiWindow = self._windowsLoaded:get(index)
        if uiWindow.allowCloseByEsc then
            lastEscWindow = uiWindow
        end
    end
    return lastEscWindow
end

---getScreenPosition
---@param uiNode UINode
function UIManager:getScreenPosition(uiNode)
    return self.canvas:canvasPointToScreenPoint(uiNode.positionInCanvas)
end

function UIManager:playClickSound()
    SoundUtils.PlaySound(Reg.SoundID("tc:click"))
end

return UIManager