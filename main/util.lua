local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

function GetWorldPosition(x, y, z)
    if z == nil then  -- More efficent than checking the type - Half
        if y ~= nil then
            x, y, z = x, 0, z
        elseif x.x then
            x, y, z = x.x, x.y, x.z
        elseif x.Transform then
            x, y, z = x.Transform:GetWorldPosition()
        end
    end

    return x, y, z
end

-- Only for convenience, not efficent at all  - Half
function CheckTileType(tile, check, ...)
    if type(tile) == "table" then
        local x, y, z = GetWorldPosition(tile)
        if type(check) == "function" then
            return check(x, y, z, ...)
        end
        tile = TheWorld.Map:GetTileAtPoint(x, y, z)
    end

    if type(check) == "function" then
        return check(tile, ...)
    elseif type(check) == "table" then
        -- return table.contains(check, tile)  -- ewww no, very inefficent
        return check[tile] ~= nil
    elseif type(check) == "string" then
        return WORLD_TILES[check] == tile
    end

    return tile == check
end
