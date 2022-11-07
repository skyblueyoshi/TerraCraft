local NeiDataBrewing = class("NeiDataBrewing")
local UIUtil = require("ui.UIUtil")
local UIDefault = require("ui.UIDefault")
local Locale = require("languages.Locale")

local MAX_ANIMATION_INDEX = 32
local ANIMATION_SPEED = 4

function NeiDataBrewing:__init()
    self._animationTick = 0
    self._animationIndex = 0
end

function NeiDataBrewing:getPanelSize()
    return Size.new(280, 180)
end

function NeiDataBrewing:getTitle()
    return "酿造"
end

function NeiDataBrewing:createUI(panelRoot, recipeID)
    local offsetX = 120
    local offsetY = 10

    panelRoot:addChild(UIUtil.createImage("img_tube", offsetX, offsetY + 52, 30, 30, {
        sprite = {
            name = "tc:tube"
        }
    }))

    panelRoot:addChild(UIUtil.createImage("img_process", offsetX + 38, offsetY + 12, 24, 80, {
        sprite = {
            name = "tc:brewing_process_00",
        }
    }))

    panelRoot:addChild(UIUtil.createImage("img_bubble", offsetX - 48, offsetY + 4, 40, 64, {
        sprite = {
            name = "tc:brewing_bubble_00"
        }
    }))

    panelRoot:addChild(UIUtil.createImage("img_fuel", offsetX - 48, offsetY + 70, 40, 12, {
        sprite = {
            name = "tc:brewing_fuel_00"
        }
    }))

    -- 0: potion  1: source  2: output  3: fuel
    panelRoot:addChild(UIUtil.createSlot("slot_potion",
            offsetX - 82, offsetY + 88, UIDefault.CellSize, UIDefault.CellSize, "tc:glass_bottle"), 0)

    panelRoot:addChild(UIUtil.createSlot("slot_input",
            offsetX - 8, offsetY, UIDefault.CellSize, UIDefault.CellSize), 1)

    panelRoot:addChild(UIUtil.createSlot("slot_output",
            offsetX + 66, offsetY + 80, UIDefault.CellLargeSize, UIDefault.CellLargeSize, "tc:glass_bottle"), 2)

    --panelRoot:addChild(UIUtil.createSlot("slot_fuel",
    --        offsetX - 100, offsetY, UIDefault.CellSize, UIDefault.CellSize, "tc:blaze_powder"), 3)

    local recipe = RecipeUtils.GetRecipe(recipeID)
    local time = recipe.exData.time
    local text = string.format(Locale.TIME_COST, time * 0.02)
    panelRoot:addChild(UIUtil.createLabel("lb_desc", text,
            120, 160, 32, 32, TextAlignment.HCenter, TextAlignment.VCenter
    ))

    panelRoot:getChild("img_process"):getPostDrawLayer(0):addListener({ NeiDataBrewing.OnRenderProcessProgress, self })
    panelRoot:getChild("img_bubble"):getPostDrawLayer(0):addListener({ NeiDataBrewing.OnRenderBubbleProgress, self })
    panelRoot:getChild("img_fuel"):getPostDrawLayer(0):addListener({ NeiDataBrewing.OnRenderFuelProgress, self })

end

function NeiDataBrewing:onUpdateTick()
    self._animationTick = self._animationTick + 1
    if self._animationTick > ANIMATION_SPEED then
        self._animationTick = 0
        self._animationIndex = self._animationIndex + 1
        if self._animationIndex > MAX_ANIMATION_INDEX then
            self._animationIndex = 0
        end
    end
end

---
---@param node UINode
---@param canvasPos Vector2
function NeiDataBrewing:OnRenderProcessProgress(node, canvasPos)
    local step = math.ceil(self._animationIndex / MAX_ANIMATION_INDEX * 16)
    UIUtil.renderProgress("tc:brewing_process_01",
            node.positionInCanvas + canvasPos,
            step,
            16, 0, 1)
end

---
---@param node UINode
---@param canvasPos Vector2
function NeiDataBrewing:OnRenderBubbleProgress(node, canvasPos)
    local step = math.ceil(self._animationIndex / MAX_ANIMATION_INDEX * 32)
    UIUtil.renderProgress("tc:brewing_bubble_01",
            node.positionInCanvas + canvasPos,
            step,
            32, 0, -1)
end

---
---@param node UINode
---@param canvasPos Vector2
function NeiDataBrewing:OnRenderFuelProgress(node, canvasPos)
    local step = math.ceil(self._animationIndex / MAX_ANIMATION_INDEX * 20)
    UIUtil.renderProgress("tc:brewing_fuel_01",
            node.positionInCanvas + canvasPos,
            20 - step,
            20, 0, -1)
end

return NeiDataBrewing