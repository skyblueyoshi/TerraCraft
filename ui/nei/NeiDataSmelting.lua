local NeiDataSmelting = class("NeiDataSmelting")
local UIUtil = require("ui.UIUtil")
local UIDefault = require("ui.UIDefault")
local Locale = require("languages.Locale")

local MAX_ANIMATION_INDEX = 16
local ANIMATION_SPEED = 8

function NeiDataSmelting:__init()
    self._animationTick = 0
    self._animationIndex = 0
end

function NeiDataSmelting:getPanelSize()
    return Size.new(190, 130)
end

function NeiDataSmelting:getTitle()
    return "烧炼"
end

function NeiDataSmelting:createUI(panelRoot, recipeID)

    panelRoot:addChild(UIUtil.createSlot("slot",
            0, 5), 0)

    panelRoot:addChild(UIUtil.createSlot("slot",
            130, 20, UIDefault.CellLargeSize, UIDefault.CellLargeSize), 1)

    panelRoot:addChild(UIUtil.createImage("img_cook",
            70, 34, 40, 32, {
                sprite = {
                    name = "tc:process_00"
                }
            }))

    panelRoot:addChild(UIUtil.createImage("img_burn",
            8, 68, 30, 30, {
                sprite = {
                    name = "tc:burn_00"
                }
            }))

    local recipe = RecipeUtils.GetRecipe(recipeID)
    local time = recipe.exData.time
    local text = string.format(Locale.BURN_TIME_COST, time * 0.02)
    panelRoot:addChild(UIUtil.createLabel("lb_desc", text,
            80, 120, 32, 32, TextAlignment.HCenter, TextAlignment.VCenter
    ))

    panelRoot:getChild("img_cook"):getPostDrawLayer(0):addListener({ NeiDataSmelting.OnRenderCookProgress, self })
    panelRoot:getChild("img_burn"):getPostDrawLayer(0):addListener({ NeiDataSmelting.OnRenderBurnProgress, self })

end

function NeiDataSmelting:onUpdateTick()
    self._animationTick = self._animationTick + 1
    if self._animationTick > ANIMATION_SPEED then
        self._animationTick = 0
        self._animationIndex = self._animationIndex + 1
        if self._animationIndex > MAX_ANIMATION_INDEX then
            self._animationIndex = 0
        end
    end
end

---OnRenderCookProgress
---@param node UINode
---@param canvasPos Vector2
function NeiDataSmelting:OnRenderCookProgress(node, canvasPos)
    UIUtil.renderProgress("tc:process_01",
            node.positionInCanvas + canvasPos,
            self._animationIndex,
            16,
            1, 0)
end

---
---@param node UINode
---@param canvasPos Vector2
function NeiDataSmelting:OnRenderBurnProgress(node, canvasPos)
    UIUtil.renderProgress("tc:burn_01",
            node.positionInCanvas + canvasPos,
            16 - self._animationIndex,
            16,
            0, -1)
end

return NeiDataSmelting