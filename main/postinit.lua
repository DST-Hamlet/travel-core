-- Update this list when adding files
local components_post = {
    "clock",
    "colourcube",
    "combat",
    "health",
    "lootdropper",
    "playercontroller",
    "rider_replica",
    "seasons",
    "shard_clock",
    "shard_seasons",
    "sleeper",
}

local prefabs_post = {
}

local batch_prefabs_post = {
}

local scenarios_post = {
}

local stategraphs_post = {
}

local brains_post = {
}

local widgets = {
}

local sim_post = {
    "map",  -- Map is not a proper component, so we edit it here instead.
}

modimport("postinit/entityscript")
modimport("postinit/animstate")

for _, file_name in ipairs(components_post) do
    modimport("postinit/components/" .. file_name)
end

for _, file_name in ipairs(prefabs_post) do
    modimport("postinit/prefabs/" .. file_name)
end

for _, file_name in ipairs(batch_prefabs_post) do
    modimport("postinit/batchprefabs/" .. file_name)
end

for _, file_name in ipairs(scenarios_post) do
    modimport("postinit/scenarios/" .. file_name)
end

for _, file_name in ipairs(stategraphs_post) do
    modimport("postinit/stategraphs/SG" .. file_name)
end

for _, file_name in ipairs(brains_post) do
    modimport("postinit/brains/" .. file_name)
end

for _, file_name in ipairs(widgets) do
    modimport("postinit/widgets/"  ..  file_name)
end

-- AddSimPostInit(function()
--     for _, file_name in pairs(sim_post) do
--         modimport("postinit/sim/" .. file_name)
--     end
-- end)
