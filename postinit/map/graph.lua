GLOBAL.setfenv(1, GLOBAL)

require("map/network")

function Graph:IAConvertGround(map, spawnFN, entities, check_col)
    local nodes = self:GetNodes(true)
    for k, node in pairs(nodes) do
        node:IAConvertGround(map, spawnFN, entities, check_col)
    end
end
