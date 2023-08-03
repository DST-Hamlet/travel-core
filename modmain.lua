local modimport = modimport
local GetModConfigData = GetModConfigData
GLOBAL.setfenv(1, GLOBAL)

IACore_CONFIG = {
    locale = GetModConfigData("locale", true),
}

modimport("main/toolutil")
modimport("main/tuning")
modimport("main/constants")

modimport("main/util")
modimport("main/commands")
modimport("main/standardcomponents")

modimport("main/assets")
modimport("main/strings")
modimport("main/postinit")

modimport("main/worldsettings_overrides")
