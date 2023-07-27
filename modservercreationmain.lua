local modname = modname
local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

modimport("main/toolutil")
modimport("main/strings")
modimport("modfrontendmain")
modimport("modcustonsizitems")

local Menu = require("widgets/menu")
local ImageButton = require("widgets/imagebutton")
local PopupDialogScreen = require("screens/redux/popupdialog")

WorldLocations = {FOREST = true, CAVE = true}

local function SetLevelLocations(servercreationscreen, location)
    servercreationscreen:SetLevelLocations({location, "cave"})
    local text = servercreationscreen.world_tabs[1]:GetLocationTabName()
    servercreationscreen.world_config_tabs.menu.items[2]:SetText(text)
end

local function ChooseWorld(world_tab, servercreationscreen)
    local menuitems = {}
    for location, val in pairs(WorldLocations) do
        table.insert(menuitems, {text = STRINGS.UI.SANDBOXMENU.LOCATIONTABNAME[location], cb = function()
            SetLevelLocations(servercreationscreen, location:lower())
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

    local world_tab = servercreationscreen.world_tabs[1]

    if not world_tab.choose_world_button then
        world_tab.choose_world_button = world_tab:AddChild(ImageButton("images/global_redux.xml", "button_carny_long_normal.tex", "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex"))

        world_tab.choose_world_button.image:SetScale(.49)
        world_tab.choose_world_button:SetFont(CHATFONT)
        world_tab.choose_world_button.text:SetColour(0, 0, 0, 1)
        world_tab.choose_world_button:SetOnClick(function(self, ...)
            ChooseWorld(world_tab, servercreationscreen)
        end)
        world_tab.choose_world_button:SetTextSize(19.6)
        world_tab.choose_world_button:SetText(STRINGS.UI.SANDBOXMENU.CHOOSEWORLD)
        world_tab.choose_world_button:SetPosition(460, 285)
    end
end)
