local TheNet = GLOBAL.TheNet
local ToolUtil = GLOBAL.ToolUtil

PrefabFiles = {
    "machete",
    "poisonbubble"
}

Assets = {
    -- hud
    Asset("ATLAS", "images/overlays/fx3.xml"),  -- poison
    Asset("IMAGE", "images/overlays/fx3.tex"),

    -- inventoryimages
    Asset("IMAGE", "images/ia_inventoryimages.tex"),
    Asset("ATLAS", "images/ia_inventoryimages.xml"),
    Asset("ATLAS_BUILD", "images/ia_inventoryimages.xml", 256),  -- for minisign

    -- player_actions
    Asset("ANIM", "anim/player_actions_hack.zip"),
    Asset("ANIM", "anim/player_actions_shear.zip"),
    Asset("ANIM", "anim/player_idles_poison.zip"),
    Asset("ANIM", "anim/player_mount_idles_poison.zip"),
}

ToolUtil.RegisterImageAtlas("images/ia_inventoryimages.xml")

if not TheNet:IsDedicated() then
    -- table.insert(Assets, Asset("SOUND", "sound/"))
end
