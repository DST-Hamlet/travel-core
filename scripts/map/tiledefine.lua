local TileManager = require("tilemanager")
local GroundTiles = require("worldtiledefs")

if not rawget(_G, "WORLDGEN_MAIN") ~= nil and TileGroups.IAOceanTiles == nil then
    TileGroups.IAOceanTiles = TileGroupManager:AddTileGroup()
end

local TileRanges =
{
    LAND = "LAND",
    NOISE = "NOISE",
    OCEAN = "OCEAN",
    IMPASSABLE = "IMPASSABLE",
}

IA_OCEAN_TILES = {}
IA_LAND_TILES = {}

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
            mod_protect_TileManager = false
            TileManager.ChangeTileRenderOrder(tile, ground_last, true)
            mod_protect_TileManager = true
            ground_last = tile
        end
    end
    return _Initialize(...)
end

return TileRanges