local modimport = modimport
local GetModConfigData = GetModConfigData
GLOBAL.setfenv(1, GLOBAL)

IACore_CONFIG = {
    locale = GetModConfigData("locale", true),
}

IACore = {}

modimport("main/toolutil")
modimport("main/strings")
