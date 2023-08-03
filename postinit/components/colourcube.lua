GLOBAL.setfenv(1, GLOBAL)

local ColourCube = require("components/colourcube")

function ColourCube:AddSeasonColourCube(season_colourcubes)
    local OnSeasonTick = self.inst:GetEventCallbacks("seasontick", nil, "scripts/components/colourcube.lua")

    local SEASON_COLOURCUBES = nil

    if OnSeasonTick then
        SEASON_COLOURCUBES = ToolUtil.GetUpvalue(OnSeasonTick, "SEASON_COLOURCUBES", 10)  -- OnSeasonTick->UpdateAmbientCCTable->SEASON_COLOURCUBES
    end

    if not SEASON_COLOURCUBES then  -- try again
        local OnPlayerActivated = self.inst:GetEventCallbacks("playeractivated", nil, "scripts/components/colourcube.lua")
        if OnPlayerActivated then
            SEASON_COLOURCUBES = ToolUtil.GetUpvalue(OnPlayerActivated, "SEASON_COLOURCUBES", 10)  -- OnPlayerActivated->OnOverrideCCTable->UpdateAmbientCCTable->SEASON_COLOURCUBES
        end
    end

    if SEASON_COLOURCUBES then
        for season, data in pairs(season_colourcubes) do
            SEASON_COLOURCUBES[season] = data
        end
    end
end
