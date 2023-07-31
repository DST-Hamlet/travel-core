local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

require("map/graphnode")

local obj_layout = require("map/ia_object_layout")
local SpawnUtil = require("map/spawnutil")

-- local NodeAddEntity = Node.AddEntity
-- Node.AddEntity = function(self, prefab, points_x, points_y, current_pos_idx, entitiesOut, ...)
--     if IA_worldtype ~= "shipwrecked" then
--         return NodeAddEntity(self, prefab, points_x, points_y, current_pos_idx, entitiesOut, ...)
--     end

--     local tile = WorldSim:GetTile(points_x[current_pos_idx], points_y[current_pos_idx])

--     if not self.voronoi_entity_check or SpawnUtil.SpawntestFn(prefab, points_x[current_pos_idx], points_y[current_pos_idx], entitiesOut) then
--         return PopulateWorld_AddEntity(prefab, points_x[current_pos_idx], points_y[current_pos_idx], tile, entitiesOut, ...)  -- thanks for tony
--     end
-- end

local _PopulateVoronoi = Node.PopulateVoronoi
function Node:PopulateVoronoi(...)
    self.voronoi_entity_check = true
    local ret = {_PopulateVoronoi(self, ...)}
    self.voronoi_entity_check = false

    return unpack(ret)
end

function Node:IAConvertGround(spawnFn, entitiesOut, width, height, world_gen_choices)  -- rewrite
    if not self.data.terrain_contents then
        return
    end

    local prefab_list = {}

    local area = WorldSim:GetSiteArea(self.id)

    -- Get the list of special items for this node
    local add_fn = {fn = function(...) self:AddEntity(...) end, args = {entitiesOut = entitiesOut, width = width, height = height, rand_offset = false, debug_prefab_list = prefab_list}}
    local checkFn = function(ground) return IsOceanTile(ground) end
    local border = 1

    local scratchpad = {} -- shared data between all entries in countstaticlayouts. This is not shared with countprefabs.
    if self.data.terrain_contents.countstaticlayouts ~= nil then
        for k, count in pairs(self.data.terrain_contents.countstaticlayouts) do
            if type(count) == "function" then
                count = count(area, k, scratchpad)
            end

            local layout = obj_layout.LayoutForDefinition(k)
            local prefabs = obj_layout.ConvertLayoutToEntitylist(layout)

            if layout.water and (self.data.type == nil or self.data.type ~= "water") then
                for i = 1, count do
                    obj_layout.PlaceWaterLayout(layout, prefabs, add_fn, checkFn)
                end
            else
                layout.border = layout.border or border
                for i = 1, count do
                    obj_layout.ReserveAndPlaceLayout(self.id, layout, prefabs, add_fn)
                end
            end
        end
    end

    if self.data.terrain_contents_extra and self.data.terrain_contents_extra.static_layouts then
        for i, layoutname in pairs(self.data.terrain_contents_extra.static_layouts) do
            local layout = obj_layout.LayoutForDefinition(layoutname)
            local prefabs = obj_layout.ConvertLayoutToEntitylist(layout)
            if layout.water and (self.data.type == nil or self.data.type ~= "water") then
                obj_layout.PlaceWaterLayout(layout, prefabs, add_fn, checkFn)
            else
                layout.border = layout.border or border
                obj_layout.ReserveAndPlaceLayout(self.id, layout, prefabs, add_fn)
            end
        end
    end
end
