local DebugHelper = class("DebugHelper")
local DebugHelperConfig = require("DebugHelperConfig")

local function PrintRecipe(rid)
    local s = "recipe: "
    local recipe = RecipeUtils.GetRecipe(rid)
    if recipe.configID == Reg.RecipeConfigID("Craft3x") then
        ---@param e RecipeInputSlot
        for i, e in each(recipe.inputs) do
            if e.type == RecipeInputSlotType.Item then
                s = s .. string.format("[%s(%d)]",
                        e.itemStack:GetItem().idName, e.itemStack.stackSize)
            elseif e.type == RecipeInputSlotType.OreDictionary then
                s = s .. string.format("[%s(%d)]",
                        Reg.OreDictionaryIDName(e.id), e.stackSize)
            else
                s = s .. "[]"
            end
        end
        s = s .. " -> "
        ---@param e Slot
        for i, e in each(recipe.outputs) do
            if e.hasStack then
                s = s .. string.format("[%s(%d)]",
                        e:GetStack():GetItem().idName, e:GetStack().stackSize)
            else
                s = s .. "[]"
            end
        end
        print(s)
    end
end

function DebugHelper.RunDebug(player)
    if not DebugHelperConfig.Enable then
        return
    end
    if NetMode.current == NetMode.Server then
        DebugHelper.DebugNpc(player)
        DebugHelper.DebugDay()
        DebugHelper.DebugWeather()
    else
        DebugHelper.DebugFly(player)
    end
end

function DebugHelper.RunDebugStart(player)
    if not DebugHelperConfig.Enable then
        return
    end
    if NetMode.current == NetMode.Server then
        DebugHelper.DebugItemStart(player)
    end
end

---@param player Player
function DebugHelper.RunDebugProp(player)
    if not DebugHelperConfig.Enable then
        return
    end
    local propDebug = DebugHelperConfig.PropDebug
    if not propDebug.Enable then
        return
    end

    local TEST_ATTACK = propDebug.Attack
    local TEST_DEFENSE = propDebug.Defense

    player.baseAttack.attack = player.baseAttack.attack + TEST_ATTACK.attack
    player.baseAttack.knockBack = player.baseAttack.knockBack + TEST_ATTACK.knockBack
    player.baseAttack.crit = player.baseAttack.crit + TEST_ATTACK.crit

    player.baseDefense.defense = player.baseDefense.defense + TEST_DEFENSE.defense
    player.baseDefense.blastDefense = player.baseDefense.blastDefense + TEST_DEFENSE.blastDefense
    player.baseDefense.flameDefense = player.baseDefense.flameDefense + TEST_DEFENSE.flameDefense
    player.baseDefense.projectileDefense = player.baseDefense.projectileDefense + TEST_DEFENSE.projectileDefense
    player.baseDefense.breathDefense = player.baseDefense.breathDefense + TEST_DEFENSE.breathDefense
    player.baseDefense.fallDefense = player.baseDefense.fallDefense + TEST_DEFENSE.fallDefense
    player.baseDefense.knockBackDefense = player.baseDefense.knockBackDefense + TEST_DEFENSE.knockBackDefense

    if propDebug.FullFood then
        player.foodLevel = 100
        player.foodSaturationLevel = 100
    end
end

local s_tmpTickFly = 0
function DebugHelper.DebugFly(player)
    local flyDebug = DebugHelperConfig.FlyDebug
    if s_tmpTickFly == nil then
        s_tmpTickFly = 0
    end
    s_tmpTickFly = s_tmpTickFly + 1
    if s_tmpTickFly >= 60 and Input.keyboard:isKeyPressed(flyDebug.HotKey) then
        s_tmpTickFly = 0
        local g = require("player.GPlayer").GetInstance(player)
        g.observeMode = not g.observeMode
    end
end

function DebugHelper.DebugDay()
    local dayDebug = DebugHelperConfig.DayDebug
    if Input.keyboard:isKeyPressed(dayDebug.HotKeySub) then
        MiscUtils.SetDayTime(MiscUtils.GetDayTime() - dayDebug.SubTime)
    elseif Input.keyboard:isKeyPressed(dayDebug.HotKeyAdd) then
        MiscUtils.SetDayTime(MiscUtils.GetDayTime() + dayDebug.AddTime)
    end
end

function DebugHelper.DebugWeather()
    local weaDebug = DebugHelperConfig.WeatherDebug
    if Input.keyboard:isKeyPressed(weaDebug.HotKeySub) then
        MiscUtils.SetWeatherTime(MiscUtils.GetWeatherTime() - weaDebug.SubTime)
    elseif Input.keyboard:isKeyPressed(weaDebug.HotKeyAdd) then
        MiscUtils.SetWeatherTime(MiscUtils.GetWeatherTime() + weaDebug.AddTime)
    end
end

local s_tmpTickNpc = 0
function DebugHelper.DebugNpc(player)
    if s_tmpTickNpc == nil then
        s_tmpTickNpc = 0
    end
    s_tmpTickNpc = s_tmpTickNpc + 1
    local npcDebug = DebugHelperConfig.NpcDebug
    if s_tmpTickNpc > 30 and Input.keyboard:isKeyPressed(npcDebug.HotKey) then
        s_tmpTickNpc = 0
        local cx = player.centerX - GameWindow.width / 2 + Input.mouse.position.x
        local cy = player.centerY - GameWindow.height / 2 + Input.mouse.position.y

        for i, idName in ipairs(npcDebug.GenList) do
            NpcUtils.Create(Reg.NpcID(idName), cx - i * 20, cy)
        end
    end
end

---@param player Player
function DebugHelper.DebugItemStart(player)
    local itemDebug = DebugHelperConfig.ItemDebug
    if not itemDebug.Enable then
        return
    end

    local items = itemDebug.StartItems
    for idx, data in ipairs(items) do
        local index = idx - 1
        if idx < player.backpackInventory.slotCount then
            local slot = player.backpackInventory:GetSlot(index)
            slot:ClearStack()
            slot:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName(data[1]), data[2]))
        end
    end

    local equipments = itemDebug.StartEquipments
    for idx, data in ipairs(equipments) do
        if data then
            local index = idx - 1
            if idx < player.equipmentInventory.slotCount then
                local slot = player.equipmentInventory:GetSlot(index)
                slot:ClearStack()
                slot:PushStack(ItemStack.new(ItemRegistry.GetItemByIDName(data), 1))
            end
        end
    end
end

return DebugHelper