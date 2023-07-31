-- this file function only for worldgen, in game use main/util.lua functions

local SpawnUtil = {}

local commonspawnfn = {}

local function surroundedbywater(x, y, ents)
    return SpawnUtil.IsSurroundedByWaterTile(x, y, 1)
end

local function notclosetowater(x, y, ents)
    return not SpawnUtil.IsCloseToWaterTile(x, y, 1)
end

function SpawnUtil.SpawntestFn(prefab, x, y, ents)
    return prefab ~= nil and (commonspawnfn[prefab] == nil or commonspawnfn[prefab](x, y, ents))
end

-- Mod support
function SpawnUtil.AddWaterCommonSpawn(prefab)
    assert(commonspawnfn[prefab] == nil)  -- don't replace an existing one
    commonspawnfn[prefab] = surroundedbywater
end

function SpawnUtil.AddLandCommonSpawn(prefab)
    assert(commonspawnfn[prefab] == nil)  -- don't replace an existing one
    commonspawnfn[prefab] = notclosetowater
end

function SpawnUtil.AddCommonSpawn(prefab, fn)
    assert(commonspawnfn[prefab] == nil)  -- don't replace an existing one
    commonspawnfn[prefab] = fn
end

function SpawnUtil.GetShortestDistToPrefab(x, y, ents, prefab)
    local w, h = WorldSim:GetWorldSize()
    local halfw, halfh = w / 2, h / 2
    local dist = 100000
    if ents ~= nil and ents[prefab] ~= nil then
        for i,spawn in ipairs(ents[prefab]) do
            local sx, sy = spawn.x, spawn.z
            local dx, dy = (x - halfw) * TILE_SCALE - sx, (y - halfh) * TILE_SCALE - sy
            local d = math.sqrt(dx * dx + dy * dy)
            if d < dist then
                dist = d
            end
            -- print(string.format("SpawnUtil.GetShortestDistToPrefab (%d, %d) -> (%d, %d) = %d", x, y, sx, sy, dist))
        end
    end
    return dist
end

function SpawnUtil.GetDistToSpawnPoint(x, y, ents)
    return SpawnUtil.GetShortestDistToPrefab(x, y, ents, "spawnpoint")
end

function SpawnUtil.IsSurroundedByTile(x, y, radius, tile)
    local num_edge_points = math.ceil((radius*2) / 4) - 1

    -- test the corners first

    if not CheckTileType(WorldSim:GetTile(x + radius, y + radius), tile) then return false end
    if not CheckTileType(WorldSim:GetTile(x - radius, y + radius), tile) then return false end
    if not CheckTileType(WorldSim:GetTile(x + radius, y - radius), tile) then return false end
    if not CheckTileType(WorldSim:GetTile(x - radius, y - radius), tile) then return false end

    -- if the radius is less than 1(2 after the +1), it won't have any edges to test and we can end the testing here.
    if num_edge_points == 0 then return true end

    local dist = (radius * 2) / (num_edge_points + 1)
    -- test the edges next
    for i = 1, num_edge_points do
        local idist = dist * i
        if not CheckTileType(WorldSim:GetTile(x - radius + idist, y + radius), tile) then return false end
        if not CheckTileType(WorldSim:GetTile(x - radius + idist, y - radius), tile) then return false end
        if not CheckTileType(WorldSim:GetTile(x - radius, y - radius + idist), tile) then return false end
        if not CheckTileType(WorldSim:GetTile(x + radius, y - radius + idist), tile) then return false end
    end

    -- test interior points last
    for i = 1, num_edge_points do
        local idist = dist * i
        for j = 1, num_edge_points do
            local jdist = dist * j
            if not CheckTileType(WorldSim:GetTile(x - radius + idist, y - radius + jdist), tile) then return false end
        end
    end
    return true
end

function SpawnUtil.IsSurroundedByWaterTile(x, y, radius)
    return SpawnUtil.IsSurroundedByTile(x, y, radius, IsOceanTile)
end

function SpawnUtil.IsCloseToTile(x, y, radius, check)
    radius = radius or 1
    for i = -radius, radius do
        if CheckTileType(WorldSim:GetTile(x - radius, y + i), check) or CheckTileType(WorldSim:GetTile(x + radius, y + i), check) then
            return true
        end
    end
    for i = -(radius - 1), radius - 1, 1 do
        if CheckTileType(WorldSim:GetTile(x + i, y - radius), check) or CheckTileType(WorldSim:GetTile(x + i, y + radius), check) then
            return true
        end
    end
    return false
end

function SpawnUtil.IsCloseToWaterTile(x, y, radius)
    return SpawnUtil.IsCloseToTile(x, y, radius, IsOceanTile)
end

function SpawnUtil.IsCloseToLandTile(x, y, radius)
    return SpawnUtil.IsCloseToTile(x, y, radius, IsLandTile)
end

function SpawnUtil.GetLayoutRadius(layout, prefabs)
    assert(layout ~= nil)
    assert(prefabs ~= nil)

    local extents = {xmin = 1000000, ymin = 1000000, xmax = -1000000, ymax = -1000000}
    for i = 1, #prefabs do
        -- print(string.format("Prefab %s (%4.2f, %4.2f)", tostring(prefabs[i].prefab), prefabs[i].x, prefabs[i].y))
        if prefabs[i].x < extents.xmin then extents.xmin = prefabs[i].x end
        if prefabs[i].x > extents.xmax then extents.xmax = prefabs[i].x end
        if prefabs[i].y < extents.ymin then extents.ymin = prefabs[i].y end
        if prefabs[i].y > extents.ymax then extents.ymax = prefabs[i].y end
    end

    local e_width, e_height = extents.xmax - extents.xmin, extents.ymax - extents.ymin
    local size = math.ceil(layout.scale * math.max(e_width, e_height))

    if layout.ground then
        size = math.max(size, #layout.ground)
    end

    -- print(string.format("Layout %s dims (%4.2f x %4.2f), size %4.2f", layout.name, e_width, e_height, size))
    return size
end

function SpawnUtil.AddEntityCheckFilter(prefab, ground)
    if terrain.filter[prefab] then
        for i, g in ipairs(terrain.filter[prefab]) do
            if g == ground then
                return false
            end
        end
    else
        --print("Warning: no terrain filter ", prefab)
    end
    return true
end

function SpawnUtil.AddEntity(prefab, ent_x, ent_y, entitiesOut, width, height, prefab_list, prefab_data, rand_offset, ...)
    local x = (ent_x - width/2.0)*TILE_SCALE
    local y = (ent_y - height/2.0)*TILE_SCALE

    local tile = WorldSim:GetVisualTileAtPosition(ent_x, ent_y)
    if TileGroupManager:IsImpassableTile(tile) then
        return
    end

    if not SpawnUtil.AddEntityCheckFilter(prefab, tile) then
        return
    end

    return PopulateWorld_AddEntity(prefab, ent_x, ent_y, tile, entitiesOut, width, height, prefab_list, prefab_data, rand_offset, ...)
end

function SpawnUtil.AddEntityCheck(prefab, ent_x, ent_y, entitiesOut, spawnFns)
    local spawn = true
    if prefab ~= nil then
        if spawnFns ~= nil and spawnFns[prefab] ~= nil then
            spawn = spawnFns[prefab](ent_x, ent_y, entitiesOut)
        else
            spawn = SpawnUtil.SpawntestFn(prefab, ent_x, ent_y, entitiesOut)
        end
    end
    --local spawn = prefab ~= nil and (spawnFns == nil or spawnFns[prefab] == nil or spawnFns[prefab](ent_x, ent_y, entitiesOut)) and SpawnUtil.SpawntestFn(prefab, ent_x, ent_y, entitiesOut)
    return spawn
end

-- for in-game checks, use FindRandomWaterPoints
-- overrides basegame function from RoT, so populating_tile may be a function or nil.
function SpawnUtil.FindRandomWaterPoints(populating_tile, width, height, edge_dist, needed)
    local points = {}
    local points_x = {}
    local points_y = {}
    local incs = {263, 137, 67, 31, 17, 9, 5, 3, 1}
    local adj_width, adj_height = width - 2 * edge_dist, height - 2 * edge_dist
    local start_x, start_y = math.random(0, adj_width), math.random(0, adj_height)

    for inc = 1, #incs do
        if #points < needed then

            -- dunno why this was a function
            local i, j = 0, 0
            while j < adj_height and #points < needed do
                local y = ((start_y + j) % adj_height) + edge_dist
                while i < adj_width and #points < needed do
                    local x = ((start_x + i) % adj_width) + edge_dist
                    -- local ground = WorldSim:GetTile(x, y)
                    -- if populating_tile(ground, x, y) then
                    if populating_tile == nil
                    or (type(populating_tile) == "function" and populating_tile(WorldSim:GetTile(x, y), x, y, points))
                    or (type(populating_tile) == "number" and not WorldSim:IsTileReserved(x, y) and populating_tile == WorldSim:GetTile(x, y)) then
                        table.insert(points, {x = x, y = y})
                    end
                    i = i + incs[inc]
                end
                j = j + incs[inc]
                i = 0
            end

            -- print(string.format("%d (of %d) points found", #points, needed))
        end
    end

    points = shuffleArray(points)
    for i = 1, #points do
        table.insert(points_x, points[i].x)
        table.insert(points_y, points[i].y)
    end

    return points_x, points_y
end

return SpawnUtil
