local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

local IsTheFrontEnd = rawget(_G, "TheFrontEnd") and rawget(_G, "IsInFrontEnd") and IsInFrontEnd()
if IsTheFrontEnd then
    return
end
-- when start worldgen

IACore = {}

modimport("main/toolutil")
modimport("main/tiledefs")
modimport("main/util")
modimport("main/tuning")

modimport("postinit/map/task")
modimport("postinit/map/level")
modimport("postinit/map/graph")
modimport("postinit/map/node")
modimport("postinit/map/ia_storygen")
