local ControlAimMode = require("client.ControlAimMode")
---@class TC.InputControl
local InputControl = class("InputControl")
local SettingsData = require("settings.SettingsData")

local s_instance
---@return TC.InputControl
function InputControl.getInstance()
    if s_instance == nil then
        s_instance = InputControl.new()
    end
    return s_instance
end

function InputControl:__init()
    self.keyMap = {
        left = Keys.A,
        right = Keys.D,
        up = Keys.W,
        down = Keys.S,
        jump = Keys.Space,
        Drop = Keys.Q,
        Backpack = Keys.E,
        Task = Keys.F,
        Nei = Keys.R,
        Esc = Keys.Escape,
        Ctrl = Keys.LeftControl,
        Shift = Keys.LeftShift,
    }
    self.joystickKeyStates = {
        left = false,
        right = false,
        up = false,
        down = false,
        jump = false,
    }

    self.operatingWall = false
    self.isSmart = false

    self.usingVirtualJoystick = false
    ---@type UIJoystick
    self.virtualJoystickLeftNode = nil
    ---@type UIJoystick
    self.virtualJoystickRightNode = nil
    ---@type UIJoystick
    self.virtualJoystickCenterNode = nil
    self.aimMode = ControlAimMode.PressOnly
    self.aimAngle = 0
    self.aimDistance = 0
    self.aimInstanceClicked = false
    self.aimPressing = false
    self.aimTriggerUsing = false
    self.isMapClicking = false
    self.touchMapPosition = Vector2.new()
    self._lastRightJoystickPressed = false
    self._lastCenterJoystickPressed = false
    self._lastWriteVirtualJoystickLeft = false
    self._lastWriteVirtualJoystickRight = false

    self.isPcMouseAtMap = false
    self.pcMouseAtMapX = 0
    self.pcMouseAtMapY = 0
    self.pcMouseAtMapXi = 0
    self.pcMouseAtMapYi = 0

    self.isPcMouseLeftInstantDown = false
    self.isPcMouseLeftInstantDownAtMap = false
    self.isPcMouseLeftPressing = false
    self.isPcMouseLeftPressingAtMap = false
    self.isPcMouseLeftInstantUp = false
    self.isPcMouseLeftInstantUpAtMap = false

    self.isPcMouseRightInstantDown = false
    self.isPcMouseRightInstantDownAtMap = false
    self.isPcMouseRightPressing = false
    self.isPcMouseRightPressingAtMap = false
    self.isPcMouseRightInstantUp = false
    self.isPcMouseRightInstantUpAtMap = false

    self._pressingKeys = {}
    self._instantPressedKeys = {}

    for k, _ in pairs(self.keyMap) do
        self._pressingKeys[k] = false
        self._instantPressedKeys[k] = false
    end
end

function InputControl.isPressing(keyName)
    local instance = InputControl.getInstance()
    local key = instance.keyMap[keyName]
    if key ~= nil then
        if Input.keyboard:isKeyPressed(key) then
            return true
        end
    end
    local joystickState = instance.joystickKeyStates[keyName]
    if joystickState ~= nil then
        return joystickState
    end
    return false
end

function InputControl.isInstantPressing(keyName)
    local instance = InputControl.getInstance()
    return instance._instantPressedKeys[keyName] == true
end

function InputControl.isNumKeyPressing(num)
    return Input.keyboard:isKeyPressed(Keys.D0 + num)
end

function InputControl.getCurrentPressingKeyNum()
    for i = 0, 9 do
        if InputControl.isNumKeyPressing(i) then
            return i
        end
    end
    return -1
end

function InputControl:updateMovementByAxis(x, y)
    self.joystickKeyStates.left = x < -0.3
    self.joystickKeyStates.right = x > 0.3
    self.joystickKeyStates.up = y < -0.3
    self.joystickKeyStates.down = y > 0.3
    self.joystickKeyStates.jump = self.joystickKeyStates.up
end

function InputControl:update()
    self.joystickKeyStates.left = false
    self.joystickKeyStates.right = false
    self.joystickKeyStates.up = false
    self.joystickKeyStates.down = false
    self.joystickKeyStates.jump = false

    self.aimPressing = false
    self.aimInstanceClicked = false
    self.aimTriggerUsing = false

    self.isPcMouseLeftInstantUp = false
    self.isPcMouseLeftInstantDown = false
    self.isPcMouseLeftInstantDownAtMap = false

    self.isPcMouseRightInstantUp = false
    self.isPcMouseRightInstantDown = false
    self.isPcMouseRightInstantDownAtMap = false

    self.pcMouseAtMapX = 0
    self.pcMouseAtMapY = 0
    self.pcMouseAtMapXi = 0
    self.pcMouseAtMapYi = 0

    local checkMovingByVirtualJoystick = false
    local checkAimingByVirtualJoystick = false

    for k, v in pairs(self.keyMap) do
        self._instantPressedKeys[k] = false
        local pressed = Input.keyboard:isKeyPressed(v)
        if pressed and not self._pressingKeys[k] then
            self._pressingKeys[k] = true
            self._instantPressedKeys[k] = true
        elseif not pressed and self._pressingKeys[k] then
            self._pressingKeys[k] = false
        end
    end

    if SettingsData.isMobileOperation then
        self.usingVirtualJoystick = (self.virtualJoystickCenterNode ~= nil)
        if self.usingVirtualJoystick then

            self.virtualJoystickCenterNode.visible = self.aimMode == ControlAimMode.LookPositionOrUse

            -- movement
            if self.virtualJoystickLeftNode.isTouching then
                local u, d, l, r = self.virtualJoystickLeftNode:getControlledFourDirection()
                if u or d or l or r then
                    self.joystickKeyStates.left = l
                    self.joystickKeyStates.right = r
                    self.joystickKeyStates.up = u
                    self.joystickKeyStates.down = d
                    self.joystickKeyStates.jump = u
                    checkMovingByVirtualJoystick = true
                end
            end
            -- aim
            if self.virtualJoystickRightNode.isTouching then
                local angle = self.virtualJoystickRightNode.controlledAngle
                local distance = self.virtualJoystickRightNode.controlledDistanceRate
                self.aimAngle = angle
                self.aimDistance = distance
                if not self._lastRightJoystickPressed then
                    self.aimInstanceClicked = true
                end
                self.aimPressing = true
                if self.aimMode == ControlAimMode.LookDirectionOrShoot then
                    if self.aimDistance > 0.5 then
                        self.aimTriggerUsing = true
                    end
                else
                    self.aimTriggerUsing = true
                end
                checkAimingByVirtualJoystick = true
            end
            if self.aimMode == ControlAimMode.LookPositionOrUse then
                if self.virtualJoystickCenterNode.isTouching then
                    local angle = self.virtualJoystickCenterNode.controlledAngle
                    local distance = self.virtualJoystickCenterNode.controlledDistanceRate

                    self.aimAngle = angle
                    self.aimDistance = distance

                    if not self._lastCenterJoystickPressed then
                        self.aimInstanceClicked = true
                    end
                    self.aimPressing = true
                    checkAimingByVirtualJoystick = true
                end
                self._lastCenterJoystickPressed = self.virtualJoystickCenterNode.isTouching

            else
                self._lastCenterJoystickPressed = false
            end
        end
    else
        self.usingVirtualJoystick = false
        -- PC Mouse + Keyboard.
        self.operatingWall = InputControl.isPressing("Shift")

        local nPos = Input.mouse.position
        nPos.x = nPos.x / GameWindow.displayResolution.width
        nPos.y = nPos.y / GameWindow.displayResolution.height

        self.pcMouseAtMapX = MiscUtils.screenX + MiscUtils.screenWidth * nPos.x
        self.pcMouseAtMapY = MiscUtils.screenY + MiscUtils.screenHeight * nPos.y
        self.pcMouseAtMapXi = Utils.Cell(self.pcMouseAtMapX)
        self.pcMouseAtMapYi = Utils.Cell(self.pcMouseAtMapY)

        local lp = Input.mouse.isLeftButtonPressed
        if self.isPcMouseLeftPressing and not lp then
            self.isPcMouseLeftInstantUp = true
        elseif not self.isPcMouseLeftPressing and lp then
            self.isPcMouseLeftInstantDown = true
            if self.isPcMouseAtMap then
                self.isPcMouseLeftInstantDownAtMap = true
                self.isPcMouseLeftPressingAtMap = true
            end
        end
        self.isPcMouseLeftPressing = lp
        if not lp then
            self.isPcMouseLeftPressingAtMap = false
        end

        local rp = Input.mouse.isRightButtonPressed
        if self.isPcMouseRightPressing and not rp then
            self.isPcMouseRightInstantUp = true
        elseif not self.isPcMouseRightPressing and rp then
            self.isPcMouseRightInstantDown = true
            if self.isPcMouseAtMap then
                self.isPcMouseRightInstantDownAtMap = true
                self.isPcMouseRightPressingAtMap = true
            end
        end
        self.isPcMouseRightPressing = rp
        if not rp then
            self.isPcMouseRightPressingAtMap = false
        end
    end

    if Input.joystick[1].isConnected then
        local leftPress = false
        local rightPress = false
        if not checkMovingByVirtualJoystick then
            local x, y = Input.joystick[1]:getAxis(0), Input.joystick[1]:getAxis(1)
            if not (math.abs(x) < 0.001 and math.abs(y) < 0.001) then
                leftPress = true
                self:updateMovementByAxis(x, y)
                if self.usingVirtualJoystick then
                    self.virtualJoystickLeftNode:setControl(x, y)
                    if not self._lastWriteVirtualJoystickLeft then
                        self.virtualJoystickLeftNode.controlledCenter = Vector2.new(
                                self.virtualJoystickLeftNode.width / 2 + math.random(-20, 30),
                                self.virtualJoystickLeftNode.height / 2 + math.random(-30, 30))
                    end
                end
            else
                if self.usingVirtualJoystick then
                    self.virtualJoystickLeftNode:setControl(0, 0)
                end
            end
        end
        if not checkAimingByVirtualJoystick then
            local x, y = Input.joystick[1]:getAxis(2), Input.joystick[1]:getAxis(3)
            if not (math.abs(x) < 0.001 and math.abs(y) < 0.001) then
                rightPress = true
                local tempVec = Vector2.new(x, y)
                self.aimAngle = tempVec.angle
                self.aimDistance = tempVec.length
                if not self._lastRightJoystickPressed then
                    self.aimInstanceClicked = true
                end
                self.aimPressing = true
                self.aimTriggerUsing = true
                if self.usingVirtualJoystick then
                    self.virtualJoystickRightNode:setControl(x, y)
                    if not self._lastWriteVirtualJoystickRight then
                        self.virtualJoystickRightNode.controlledCenter = Vector2.new(
                                self.virtualJoystickRightNode.width / 2 + math.random(-20, 30),
                                self.virtualJoystickRightNode.height / 2 + math.random(-30, 30))
                    end
                end
            else
                if self.usingVirtualJoystick then
                    self.virtualJoystickRightNode:setControl(0, 0)
                end
            end
        end
        self._lastWriteVirtualJoystickLeft = leftPress
        self._lastWriteVirtualJoystickRight = rightPress
    end

    self._lastRightJoystickPressed = self.aimPressing

    
end

return InputControl