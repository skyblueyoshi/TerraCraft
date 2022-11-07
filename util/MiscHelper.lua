local MiscHelper = class("MiscHelper")

local s_dirt = Reg.BlockID("dirt")
local s_coarse_dirt = Reg.BlockID("coarse_dirt")
local s_farmland = Reg.BlockID("farmland")

local s_cow = Reg.NpcID("cow")
local s_brown_mushroom_cow = Reg.NpcID("brown_mushroom_cow")
local s_red_mushroom_cow = Reg.NpcID("red_mushroom_cow")

local s_bone_meal = Reg.ItemID("bone_meal")
local s_bowl = Reg.ItemID("bowl")
local s_mushroom_stew = Reg.ItemID("mushroom_stew")
local s_glass_bottle = Reg.ItemID("glass_bottle")
local s_bucket_empty = Reg.ItemID("bucket_empty")
local s_bucket_milk = Reg.ItemID("bucket_milk")
local s_liquid_to_bucket_item_names = {
    { "water", "bucket_water" },
    { "lava", "bucket_lava" },
}

local s_liquid_2_buckets = {}
for _, v in ipairs(s_liquid_to_bucket_item_names) do
    s_liquid_2_buckets[Reg.LiquidID(v[1])] = Reg.ItemID(v[2])
end
local s_bucket_2_liquids = {}
for _, v in ipairs(s_liquid_to_bucket_item_names) do
    s_bucket_2_liquids[Reg.ItemID(v[2])] = Reg.LiquidID(v[1])
end

function MiscHelper.GetBucketIDFromLiquidID(liquidID)
    local res = s_liquid_2_buckets[liquidID]
    if res ~= nil then
        return res
    end
    return 0
end

function MiscHelper.GetLiquidIDFromBucket(itemID)
    local res = s_bucket_2_liquids[itemID]
    if res ~= nil then
        return res
    end
    return 0
end

function MiscHelper.GetMilkBucketID()
    return s_bucket_milk
end

function MiscHelper.GetEmptyBucketID()
    return s_bucket_empty
end

function MiscHelper.GetEmptyGrassBottleID()
    return s_glass_bottle
end

function MiscHelper.IsPullableBucket(itemID)
    return MiscHelper.GetLiquidIDFromBucket(itemID) > 0
end

function MiscHelper.IsEmptyGrassBottle(itemID)
    return itemID == s_glass_bottle
end

function MiscHelper.IsEmptyBucket(itemID)
    return itemID == s_bucket_empty
end

function MiscHelper.IsMushroomCow(npcID)
    return npcID == s_brown_mushroom_cow or npcID == s_red_mushroom_cow
end

function MiscHelper.IsCow(npcID)
    return npcID == s_cow or MiscHelper.IsMushroomCow(npcID)
end

function MiscHelper.IsEmptyBowl(itemID)
    return itemID == s_bowl
end

function MiscHelper.GetMushroomBowl()
    return s_mushroom_stew
end

function MiscHelper.IsBoneMeal(itemID)
    return s_bone_meal == itemID
end

function MiscHelper.CanTransformToFramland(blockID)
    return blockID == s_dirt or blockID == s_coarse_dirt
end

function MiscHelper.GetFarmlandID()
    return s_farmland
end

function MiscHelper.OpenURL(url)
    print("open url:", url)
    if not App.isPC then
        require("tc.ui.InfoPopupUI").new(url)
        return
    end

    os.execute("start " .. url)
end

return MiscHelper