local DebugHelperConfig = {
    Enable = false,

    FlyDebug = {
        HotKey = Keys.P,
    },

    DayDebug = {
        HotKeyAdd = Keys.X,
        HotKeySub = Keys.Z,
        AddTime = 500,
        SubTime = 500,
    },

    WeatherDebug = {
        HotKeyAdd = Keys.C,
        HotKeySub = Keys.V,
        AddTime = 500,
        SubTime = 500,
    },

    PropDebug = {
        Enable = true,
        Attack = {
            attack = 0,
            knockBack = 1,
            crit = 10,
        },
        Defense = {
            defense = 18,
            blastDefense = 0,
            flameDefense = 0,
            projectileDefense = 0,
            breathDefense = 0,
            fallDefense = 0,
            knockBackDefense = 0,
        },
        FullFood = true,
    },

    EquipmentDebug = {
        Enable = true,
        Equipments = {
            --"i_hat_10",
            --"i_cloth_10",
            --"i_leg_10",
        }
    },

    ItemDebug = {
        Enable = true,
        HotKey = Keys.B,
        StartEquipments = {
            "lava_helmet",
            "lava_chestplate",
            "lava_leggings",
        },
        StartItems = {
            --{ "blue_shot_bow", 1 },
            --{ "bone_gun", 1 },
            --{ "curse_bow", 1 },
            --{ "dark_staff", 1 },
            --{ "fire_book", 1 },
            --{ "fire_shooter", 1 },
            --{ "fire_staff", 1 },
            --{ "frosen_staff", 1 },
            --{ "lava_sword", 1 },
            --{ "mini_laser_gun", 1 },
            { "tc:ender_mirror", 1 },
            { "tc:blaze_rod", 11 },
            { "tc:shotgun", 1 },
            { "tc:shot_bow", 1 },
            { "tc:brewing_stand", 111 },
            { "tc:diamond_pickaxe", 1 },
            { "tc:diamond_axe", 1 },
            { "tc:diamond_sword", 1 },
            { "tc:tower_core", 1 },
            { "tc:boomerang", 1 },
            { "td:energy_tower", 11 },
            { "td:burn_tower", 15 },
            { "potion_weakness", 111 },
            { "wooden_arrow", 111 },
            { "mini_laser_gun", 1 },
            { "wooden_arrow", 111 },
            { "ender_mirror", 1 },
            { "strange_eye", 8 },
            { "air_sword", 1 },
            { "bread", 111 },
            { "crafting_table", 2 },
            { "blue_talisman", 1 },
            { "gold_talisman", 1 },
            { "heart_talisman", 1 },
            { "lava_necklace", 1 },
            { "lighting_talisman", 1 },
            { "sword_fish", 1 },
            { "sword_fish_gun", 1 },
            { "water_book", 1 },
            { "ice_bow", 1 },
            { "blue_arrow", 11 },
            { "iron_bullet", 411 },
        },
        Items = {
            { "iron_bullet", 21 },
        },
    },

    NpcDebug = {
        HotKey = Keys.I,
        GenList = {
            "skeleton",
            "crison_eye",
            "dungeon_eater_head",
            "dungeon_slime",
            "dungeon_knight",
            "dungeon_soul",
            "bone_officer",
            "dead_mage",
            "dark_mage",
            "cursed_skull",
            "dragon_skull",
            "dungeon_creeper",
            "evil",
            "eye_guard",
            "eye_guard_laser",
            "flame_soul",
            "fly_eye",
            "fly_mouth",
            "fly_skeleton",
            "ghost_gunner",
            "ghost_soul",
            "giant_cursed_skull",
            "grim_reaper",
            "ragged_mage",
            "red_mage",
            "large_bat",
            "mad_skeleton",
            "mad_skeleton_armed",
            "mad_skeleton_tall",
            "mad_skeleton_tall_armed",
            "mad_skeleton_tall_helmet_armed",
            "skeleton_blue_armed",
            "skeleton_blue_armed_masked",
            "skeleton_blue_knight",
            "skeleton_fire_armed",
            "skeleton_fire_armed_swordsman",
            "large_spider",
            "mini_ghast",
            "red_phantom",
            "rock_man",
            "rolling_fire_ball",
            "skeleton_assaulter",
            "skeleton_guard",
            "undead_miner",
            "vampire_miner",
            "bone_officer",
            "black_rabbit",
            "guardian",
            "skeleton",
            "skeleton",
            "creeper",
            "snow_queen",
        }
    }
}

return DebugHelperConfig