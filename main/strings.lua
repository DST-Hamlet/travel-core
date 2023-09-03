local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

require("translator")

local languages = {
    -- en = "strings.pot",
    de = "german",  -- german
    es = "spanish",  -- spanish
    fr = "french",  -- french
    it = "italian",  -- italian
    ko = "korean",  -- korean
    pt = "portuguese_br",  -- portuguese and brazilian portuguese
    br = "portuguese_br",  -- brazilian portuguese
    pl = "polish",  -- polish
    ru = "russian",  -- russian
    zh = "chinese_s",  -- chinese
    chs = "chinese_s", -- chinese mod
    sc = "chinese_s", -- simple chinese
    tc = "chinese_t", -- traditional chinese
    cht = "chinese_t",  -- traditional chinese
}

local speech = {
    "generic",
    "willow",
    "wolfgang",
    "wendy",
    "wx78",
    "wickerbottom",
    "woodie",
    -- "wes",
    "waxwell",
    "wathgrithr",
    "webber",
    "winona",
    "wortox",
    "wormwood",
    "warly",
    "wurt",
    "walter",
    "wanda",
}

local newspeech = {
    -- sw character
    "walani",
    -- "wilbur",
    "woodlegs",

    -- pork character
    "wheeler",
    "wilba",
    "wagstaff",
    -- "warbucks"  -- discard
}

local function ia_import(module_name, env)
    module_name = module_name .. ".lua"
    print("modimport (strings file): " .. env.MODROOT .. "strings/" .. module_name)
    local result = kleiloadlua(env.MODROOT .. "strings/" .. module_name)

    if result == nil then
        error("Error in custom import: Stringsfile " .. module_name .. " not found!")
    elseif type(result) == "string" then
        error("Error in custom import: Pork Land importing strings/" .. module_name .. "!\n" .. result)
    else
        setfenv(result, env)  -- in case we use mod data
        return result()
    end
end

function TravelCore.LoadAndTranslateString(po_path, env)
    ToolUtil.merge_table(STRINGS, ia_import("common", env))
    local IsTheFrontEnd = rawget(_G, "TheFrontEnd") and rawget(_G, "IsInFrontEnd") and IsInFrontEnd()
    if not IsTheFrontEnd then
        -- add character speech
        for _, character in pairs(speech) do
            ToolUtil.merge_table(STRINGS.CHARACTERS[string.upper(character)], ia_import(character, env))
        end

        for _, character in pairs(newspeech) do
            STRINGS.CHARACTERS[string.upper(character)] = ia_import(character, env)
        end
    end

    local desiredlang = nil
    local TravelCore_CONFIG = rawget(_G, "TravelCore_CONFIG")
    if TravelCore_CONFIG and TravelCore_CONFIG.locale then
        desiredlang = TravelCore_CONFIG.locale
    elseif (IsTheFrontEnd or TravelCore_CONFIG) and LanguageTranslator.defaultlang then  -- only use default in FrontEnd or if locale is not set
        desiredlang = LanguageTranslator.defaultlang
    end

    if desiredlang and languages[desiredlang] then
        local temp_lang = desiredlang .. "_temp"

        env.LoadPOFile(po_path .. languages[desiredlang] .. ".po", temp_lang)
        ToolUtil.merge_table(LanguageTranslator.languages[desiredlang], LanguageTranslator.languages[temp_lang])
        TranslateStringTable(STRINGS)
        LanguageTranslator.languages[temp_lang] = nil
        LanguageTranslator.defaultlang = desiredlang
    end
end

TravelCore.LoadAndTranslateString("scripts/languages/ia_", IAENV)
