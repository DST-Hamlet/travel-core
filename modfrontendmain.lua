local modname = modname
GLOBAL.setfenv(1, GLOBAL)

local function OnUnloadMod()
    local servercreationscreen = TheFrontEnd:GetOpenScreenOfType("ServerCreationScreen")

    SERVER_LEVEL_LOCATIONS[1] = "forest"

    if not (servercreationscreen and servercreationscreen.world_tabs and servercreationscreen.world_tabs[1])  then
        return
    end

    servercreationscreen:SetLevelLocations()
    local text = servercreationscreen.world_tabs[1]:GetLocationTabName()
    servercreationscreen.world_config_tabs.menu.items[2]:SetText(text)

    local world_tab = servercreationscreen.world_tabs[1]

    if world_tab.choose_world_button then
        world_tab.choose_world_button:Hide()
    end
end

local _FrontendUnloadMod = ModManager.FrontendUnloadMod
function ModManager:FrontendUnloadMod(modname, ...)
    if not modname or modname == modname then  -- if modname is nil, unload all mod
        OnUnloadMod()
        ModManager.FrontendUnloadMod = _FrontendUnloadMod
    end

    return _FrontendUnloadMod(self, modname, ...)
end
