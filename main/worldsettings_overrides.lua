GLOBAL.setfenv(1, GLOBAL)

local worldsettings_overrides = require("worldsettings_overrides")
local applyoverrides_pre = worldsettings_overrides.Pre
local applyoverrides_post = worldsettings_overrides.Post

--------------------------------------------------------------------------
--[[ WORLDSETTINGS PRE ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ WORLDSETTINGS POST ]]
--------------------------------------------------------------------------

applyoverrides_post.poison = function(difficulty)
    local worldsettings = TheWorld.components.worldsettings
    if worldsettings then
        worldsettings:SetSetting("poison", difficulty == "default")
    end
end
