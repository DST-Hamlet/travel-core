GLOBAL.setfenv(1, GLOBAL)

local tuning = {
    MAPWRAPPER_WARN_RANGE = 14
}

for key, value in pairs(tuning) do
    if TUNING[key] then
        print("OVERRIDE: " .. key .. " in TUNING")
    end

    TUNING[key] = value
end
