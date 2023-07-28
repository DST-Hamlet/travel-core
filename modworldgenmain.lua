local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

local IsTheFrontEnd = rawget(_G, "TheFrontEnd") and rawget(_G, "IsInFrontEnd") and IsInFrontEnd()
if IsTheFrontEnd then
    return
end

IACore = {}

-- when start worldgen
require("map/ia_storygen")

modimport("main/toolutil")
modimport("main/tiledefs")
modimport("postinit/map/task")
modimport("postinit/map/graph")
modimport("postinit/map/node")
