local Assets = Assets
GLOBAL.setfenv(1, GLOBAL)

local function FinalOffset1(inst)
    inst.AnimState:SetFinalOffset(1)
end

local function TintOceantFx(inst)
    inst.AnimState:SetOceanBlendParams(TUNING.OCEAN_SHADER.EFFECT_TINT_AMOUNT)
end

local ia_fx = {
    {
        name = "splash_water_float",
        bank = "splash_water_drop",
        build = "splash_water_drop",
        sound = "ia/common/item_float",
        fn = TintOceantFx,
        anim = "idle",
    },
    {
        name = "shock_machines_fx",
        bank = "shock_machines_fx",
        build = "shock_machines_fx",
        anim = "shock",
        sound = "ia/creatures/jellyfish/electric_land",
        fn = FinalOffset1,
    },
}

-- Sneakily add these to the FX table
-- Also force-load the assets because the fx file won't do for some reason

local fx = require("fx")

for _, v in ipairs(ia_fx) do
    table.insert(fx, v)
    if Settings.last_asset_set ~= nil then
        table.insert(Assets, Asset("ANIM", "anim/" .. v.build .. ".zip"))
    end
end
