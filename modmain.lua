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
modimport("main/oceanutil")
modimport("main/commands")
modimport("main/standardcomponents")

modimport("main/assets")
modimport("main/fx")
modimport("main/strings")

modimport("main/worldsettings_overrides")
modimport("main/actions")
modimport("main/postinit")
