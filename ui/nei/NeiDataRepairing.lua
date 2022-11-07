local NeiDataRepairing = class("NeiDataRepairing")
local UIUtil = require("ui.UIUtil")
local UIDefault = require("ui.UIDefault")

function NeiDataRepairing:getPanelSize()
    return Size.new(320, 60)
end

function NeiDataRepairing:getTitle()
    return "修复"
end

function NeiDataRepairing:createUI(panelRoot, recipeID)
    local offsetX, offsetY = 0, 0
    local recipe = RecipeUtils.GetRecipe(recipeID)

    local repairPercent = math.ceil(recipe.exData.repairRate * 100)

    -- 50-52: tool, source, output
    panelRoot:addChild(UIUtil.createSlot("slot_tool",
            offsetX + 0,
            offsetY + 0,
            UIDefault.CellSize, UIDefault.CellSize, "tc:hammer"), 0)

    panelRoot:addChild(UIUtil.createSlot("slot_source",
            offsetX + 120,
            offsetY + 0,
            UIDefault.CellSize, UIDefault.CellSize, "tc:ingot_gray"), 1)

    panelRoot:addChild(UIUtil.createSlot("slot_output",
            offsetX + 250,
            offsetY - 5,
            UIDefault.CellLargeSize, UIDefault.CellLargeSize, "tc:hammer"), 2)

    panelRoot:addChild(UIUtil.createLabel("lb_exp",
            string.format("修复率:%d%%", repairPercent),
            offsetX + 130, offsetY + 54, 32, 32,
            TextAlignment.HCenter, TextAlignment.VCenter, {
                color = Color.Yellow
            }
    ))

    panelRoot:addChild(UIUtil.createImage("img_add", offsetX + 68, offsetY + 8, 32, 32, {
        sprite = {
            name = "tc:adding",
        }
    }))

    panelRoot:addChild(UIUtil.createImage("img_process", offsetX + 190, offsetY + 8, 40, 32, {
        sprite = {
            name = "tc:process_00",
        }
    }))
end

return NeiDataRepairing