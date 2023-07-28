local modname = modname
local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

IACore = {}

modimport("main/toolutil")
modimport("main/strings")
modimport("modfrontendmain")

local Menu = require("widgets/menu")
local ImageButton = require("widgets/imagebutton")
local PopupDialogScreen = require("screens/redux/popupdialog")

IACore.WorldLocations = {
    [1] = {FOREST = true, CAVE = true},
    [2] = {CAVE = true},
}

function IACore.SetLevelLocations(servercreationscreen, location, i)
    local server_level_locations = {}
    server_level_locations[i] = location
    server_level_locations[3 - i] = SERVER_LEVEL_LOCATIONS[3 - i]
    servercreationscreen:SetLevelLocations(server_level_locations)
    local text = servercreationscreen.world_tabs[i]:GetLocationTabName()
    servercreationscreen.world_config_tabs.menu.items[i + 1]:SetText(text)
end

local function ChooseWorld(i, world_tab, servercreationscreen)
    local menuitems = {}
    for location, val in pairs(IACore.WorldLocations[i]) do
        table.insert(menuitems, {text = STRINGS.UI.SANDBOXMENU.LOCATIONTABNAME[location], cb = function()
            IACore.SetLevelLocations(servercreationscreen, location:lower(), i)
            TheFrontEnd:PopScreen()
        end, style = "carny_long"})
    end
    table.insert(menuitems, {text = STRINGS.UI.LOBBYSCREEN.CANCEL, cb = function() TheFrontEnd:PopScreen() end, style = "carny_long"})
    TheFrontEnd:PushScreen(PopupDialogScreen(STRINGS.UI.SANDBOXMENU.CHOOSEWORLD, STRINGS.UI.CUSTOMIZATIONSCREEN.CUSTOMDESC, menuitems))
end

scheduler:ExecuteInTime(0, function()  -- Delay a frame so we can get ServerCreationScreen when entering a existing world
    local servercreationscreen = TheFrontEnd:GetOpenScreenOfType("ServerCreationScreen")

    if not (KnownModIndex:IsModEnabled(modname) and servercreationscreen and servercreationscreen.world_tabs and servercreationscreen.world_tabs[1]) then
        return
    end

    for i, world_tab in ipairs(servercreationscreen.world_tabs) do
        if servercreationscreen:CanResume() and world_tab:GetLocation() ~= SERVER_LEVEL_LOCATIONS[i] then
            SERVER_LEVEL_LOCATIONS[i] = world_tab:GetLocation()
            servercreationscreen.world_tabs[i]:RefreshOptionItems()
            local text = servercreationscreen.world_tabs[i]:GetLocationTabName()
            servercreationscreen.world_config_tabs.menu.items[i + 1]:SetText(text)
        end

        if not world_tab.choose_world_button then
            world_tab.choose_world_button = world_tab.settings_root:AddChild(ImageButton("images/global_redux.xml", "button_carny_long_normal.tex", "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex"))

            world_tab.choose_world_button.image:SetScale(.47)
            world_tab.choose_world_button:SetFont(CHATFONT)
            world_tab.choose_world_button.text:SetColour(0, 0, 0, 1)
            world_tab.choose_world_button:SetOnClick(function(self, ...)
                ChooseWorld(i, world_tab, servercreationscreen)
            end)
            world_tab.choose_world_button:SetTextSize(19.6)
            world_tab.choose_world_button:SetText(STRINGS.UI.SANDBOXMENU.CHOOSEWORLD)
            world_tab.choose_world_button:SetPosition(320, 285)
        elseif not world_tab.choose_world_button.shown then
            world_tab.choose_world_button:Show()
        end
    end
end)
