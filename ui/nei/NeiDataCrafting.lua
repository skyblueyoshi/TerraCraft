local NeiDataCrafting = class("NeiDataCrafting")
local UIUtil = require("ui.UIUtil")
local UIDefault = require("ui.UIDefault")

function NeiDataCrafting:getPanelSize()
    return Size.new(256, 144)
end

function NeiDataCrafting:getTitle()
    return "合成"
end

function NeiDataCrafting:createUI(panelRoot, recipeID)
    for i = 0, 8 do
        panelRoot:addChild(UIUtil.createSlot("slot",
                (i % 3) * UIDefault.CellOffset, math.floor(i / 3) * UIDefault.CellOffset), i)
    end
    panelRoot:addChild(UIUtil.createSlot("slot",
                200, 43, UIDefault.CellLargeSize, UIDefault.CellLargeSize), 9)

    panelRoot:addChild(UIUtil.createImage("img_craft_arrow", 158, 60, 32, 24, {
        sprite = {
            name = "tc:arrow3",
            color = Color.new(100, 100, 100, 188)
        }
    }))
end

return NeiDataCrafting