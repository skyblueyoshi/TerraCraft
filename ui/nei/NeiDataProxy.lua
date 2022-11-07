local NeiDataProxy = class("NeiDataProxy")

function NeiDataProxy:__init()
    self._dataDict = {
        [Reg.RecipeConfigID("Craft3x")] = require("NeiDataCrafting").new(),
        [Reg.RecipeConfigID("Smelt")] = require("NeiDataSmelting").new(),
        [Reg.RecipeConfigID("Repair")] = require("NeiDataRepairing").new(),
        [Reg.RecipeConfigID("Brew")] = require("NeiDataBrewing").new(),
    }
end

function NeiDataProxy:getData(recipeConfigID)
    return self._dataDict[recipeConfigID]
end

return NeiDataProxy