---@class TC.WorldGenDefine
local WorldGenDefine = {
    SURFACE_LINE = 400, -- line between surface layer and air layer
    UNDERGROUND_LINE = 600, -- line between surface layer and underground layer
    NETHER_LINE = 2560, -- line between underground layer and nether layer
    NETHER_LAVA_LINE = 2700, -- line to start generating nether large lava lake
    NETHER_LAVE_CAVE_HEIGHT = 60,  -- the height of nether large cave
    UNDERGROUND_LAKE_LINE = 1536,  -- line to start generating lava lake
    BEDROCK_CHUNK_YI = 3, -- bedrock layer chunk y index

    SURFACE_CHUNK_XI_NEW_GUIDE_FOREST = 0,  -- new player's forest
    SURFACE_CHUNK_XI_JUNGLE = 1,  -- jungle with small desert and ghost house
    SURFACE_CHUNK_XI_SNOW = 2,  -- snow land with palace and danger caves
    SURFACE_CHUNK_XI_DUNGEON = 3,  -- a terraria style dungeon area
    SURFACE_CHUNK_XI_DESERT = 4,  -- a large desert area with pyramid dungeon and wasteland
    SURFACE_CHUNK_XI_TAINTED = 5,  -- a large tainted area
    SURFACE_CHUNK_XI_ICE_DUNGEON = 6,  -- snow land with ice dungeon
    SURFACE_CHUNK_XI_VOLCANO = 7,  -- volcano with castle
    SURFACE_CHUNK_XI_MUSHROOM = 8,  -- peaceful mushroom island
    SURFACE_CHUNK_XI_OCEAN = 9,  -- ocean

    SURFACE_CHUNK_XI_LOOP_TOTALS = 10

}

return WorldGenDefine