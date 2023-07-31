local NoiseFunctions = require("noisetilefunctions")
local ChangeTileRenderOrder = ChangeTileRenderOrder
GLOBAL.setfenv(1, GLOBAL)

local GroundTiles = require("worldtiledefs")

if not rawget(_G, "WORLDGEN_MAIN") ~= nil and TileGroups.IAOceanTiles == nil then
    TileGroups.IAOceanTiles = TileGroupManager:AddTileGroup()
end

IA_OCEAN_TILES = {}
IA_LAND_TILES = {}

IACore.TileRanges =
{
    LAND = "LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    IMPASSABLE = "IMPASSABLE",
}

function IACore.IA_Add_Tile(tiledefs, addtilefn)
    local is_worldgen = rawget(_G, "WORLDGEN_MAIN") ~= nil

    for tile, def in pairs(tiledefs) do
        local range = def.tile_range
        if type(range) == "function" then
            range = IACore.TileRanges.NOISE
        end

        addtilefn(tile, range, def.tile_data, def.ground_tile_def, def.minimap_tile_def, def.turf_def)

        local tile_id = WORLD_TILES[tile]

        if def.tile_range == IACore.TileRanges.OCEAN then
            if not is_worldgen then
                TileGroupManager:AddInvalidTile(TileGroups.TransparentOceanTiles, tile_id)
                TileGroupManager:AddValidTile(TileGroups.IAOceanTiles, tile_id)
            end

            table.insert(IA_OCEAN_TILES, tile_id)
        elseif def.tile_range == IACore.TileRanges.LAND then
            table.insert(IA_OCEAN_TILES, tile_id)
        elseif type(def.tile_range) == "function" then
            NoiseFunctions[tile_id] = def.tile_range
        end
    end
end

local _Initialize = GroundTiles.Initialize
function GroundTiles.Initialize(...)
    local ground_table = GroundTiles.ground

    -- Ground
    local ground_last
    for i = #ground_table, 1, -1 do
        local ground = ground_table[i]
        if ground[1] ~= nil then
            ground_last = ground[1]
            break
        end
    end
    for i = #IA_OCEAN_TILES, 1, -1 do
        local tile = IA_OCEAN_TILES[i]
        if tile ~= ground_last then
            ChangeTileRenderOrder(tile, ground_last, true)
            ground_last = tile
        end
    end
    return _Initialize(...)
end
