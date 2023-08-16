local _modname = modname
GLOBAL.setfenv(1, GLOBAL)

IACore.OnUnloadMods = {}

function IACore.OnUnloadlevel()
    local servercreationscreen = TheFrontEnd:GetOpenScreenOfType("ServerCreationScreen")

    if not (servercreationscreen and servercreationscreen.world_tabs)  then
        return
    end

    SERVER_LEVEL_LOCATIONS = {"forest", "cave"}

    servercreationscreen:SetLevelLocations()

    for i, world_tab in ipairs(servercreationscreen.world_tabs) do
        local text = world_tab:GetLocationTabName()
        servercreationscreen.world_config_tabs.menu.items[i + 1]:SetText(text)

        if world_tab.choose_world_button then
            world_tab.choose_world_button:Hide()
        end
    end
end

IACore.OnUnloadMods[_modname] = IACore.OnUnloadlevel

local _FrontendUnloadMod = ModManager.FrontendUnloadMod
function ModManager:FrontendUnloadMod(modname, ...)
    if not modname or modname == _modname then
        for _, OnUnloadMod in pairs(IACore.OnUnloadMods) do
            OnUnloadMod()
        end
        ModManager.FrontendUnloadMod = _FrontendUnloadMod
    elseif IACore.OnUnloadMods[modname] then
        IACore.OnUnloadMods[modname]()
    end

    return _FrontendUnloadMod(self, modname, ...)
end
