-- [WARNING]: This file is imported into modclientmain.lua, be careful!
if not env.is_mim_enabled then
    FrontEndAssets = {
        Asset("IMAGE", "images/hud/customization_ia.tex"),
        Asset("ATLAS", "images/hud/customization_ia.xml"),
    }
    ReloadFrontEndAssets()
end

local AddCustomizeItem = AddCustomizeItem
local AddCustomizeGroup = AddCustomizeGroup
GLOBAL.setfenv(1, GLOBAL)

local Customize = require("map/customize")

local worldgen_atlas = "images/worldgen_customization.xml"
local ia_atlas = "images/hud/customization_ia.xml"

function IACore.AddGroupAndItem(category, name, text, desc, atlas, order, items)
    if text then  -- assume that if the group has a text string its new
        AddCustomizeGroup(category, name, text, desc, atlas or ia_atlas, order)
    end
    if items then
        for k, v in pairs(items) do
            AddCustomizeItem(category, name, k, v)
        end
    end
end

local WORLDGEN_GROUP = ToolUtil.GetUpvalue(Customize.GetWorldGenOptions, "WORLDGEN_GROUP")
local WORLDSETTINGS_GROUP = ToolUtil.GetUpvalue(Customize.GetWorldSettingsOptions, "WORLDSETTINGS_GROUP")
function IACore.AddItemWorld(category, group, item, world)
    local GROUP = category == "worldgen" and WORLDGEN_GROUP or WORLDSETTINGS_GROUP
    table.insert(GROUP[group].items[item].world, world)
end

local enable_descriptions = {
    {text = STRINGS.UI.SANDBOXMENU.SLIDENEVER,   data = "never"},
    {text = STRINGS.UI.SANDBOXMENU.SLIDEDEFAULT, data = "default"}
}

local ia_customize_table = {  -- we customize
}

local custonsiz_items = {  -- add in dst custonsiz
    [LEVELCATEGORY.WORLDGEN] = {
        ["global"] = {},  -- global is keywords
        monsters = {},
        animals = {},
        resources = {},
        misc = {}
    },
    [LEVELCATEGORY.SETTINGS] = {
        monsters = {},
        animals = {},
        resources = {},
        misc = {
            poison = {desc = enable_descriptions}
        },
    }
}

for name, data in pairs(ia_customize_table) do  -- add we customize
    IACore.AddGroupAndItem(data.category, name, data.text, data.desc, data.atlas, data.order, data.items)
end

for category, category_data in pairs(custonsiz_items) do  -- -- add to dst custonsiz
    for group, group_data in pairs(category_data) do
        for item, data in pairs(group_data) do
            local name = item
            local itemsettings = data
            if type(data) == "string" then
                name = itemsettings
                itemsettings = {}
            end

            itemsettings.image = itemsettings.image or name .. ".tex"
            itemsettings.value = itemsettings.value or "default"
            itemsettings.world = itemsettings.world or {"forest", "cave", "porkland", "shipwrecked", "volcano"}
            itemsettings.atlas = itemsettings.atlas or ia_atlas
            AddCustomizeItem(category, group, name, itemsettings)
        end
    end
end
