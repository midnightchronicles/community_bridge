local ConvarLang = GetConvar("lang", "none")
local OXLang = GetConvar("ox:locale", "none")
local QBXLang = GetConvar("qb_locale", "none")
local txLang = GetConvar("txAdmin-locale", "none")
local esxLang = GetConvar("esx:locale", "none")

BridgeSharedConfig = Require("settings/sharedConfig.lua")

Lang = ConvarLang ~= "none" and
ConvarLang or BridgeSharedConfig.Lang ~= "auto" and BridgeSharedConfig.Lang or
OXLang ~= "none" and OXLang or
QBXLang ~= "none" and QBXLang or
txLang ~= "none" and txLang or
esxLang ~= "none" and esxLang or
"en"

Language = {}

function Language.Locale(str, ...)
    local resource = GetInvokingResource() or GetCurrentResourceName()
    assert(resource, "Resource name not found")
    
    local locales = LoadResourceFile(resource, "locales/" .. Lang .. ".json")
    locales = locales and json.decode(locales) or {}
    
    -- Handle nested tables via dot notation
    local current = locales
    for part in str:gmatch("[^%.]+") do
        if type(current) ~= "table" then
            warn(("Invalid nested locale path: %s"):format(str))
            return str
        end
        current = current[part]
        if not current then
            warn(("Locale not found for key: %s in language: %s"):format(str, Lang))
            return str
        end
    end
    
    -- Handle variable replacement
    local args = {...}
    
    if type(current) == "string" and #args > 0 then        
        current = string.format(current, ...)
    end
    
    return current
end


RegisterCommand("lang", function(source, args, raw)
    print(Language.Locale("UNITTEST.UNITTEST.UNITTESTA"))
    print(Language.Locale("UNITTEST.UNITTESTA", "Devil", "GERRRRRRR!"))

    print( "Oh also this works", Language.Locale("place_object_scroll_down"))
end)

if BridgeSharedConfig.DebugLevel == 2 then
    -- if outside this resource, use local whatever = Require("modules/locales/shared.lua")
    -- whatever.Locales("some-index-in-language-.json-file")
    -- Files must be stored in "locales" folder, within the resource.
    -- Instead of using Require you can also import it via the manifest.
    -- The Lang variable is available globally, which tells you what the server is using.
    --print("Language: ", Lang)
    --print("Locale: ", Language.Locale("locale-unit-test"))

    -- Example outside community bridge resource:

    -- local Language = Require('modules/locales/shared.lua')
    -- print("Language: ", Lang)
    -- print("Locale: ", Language.Locale("locale-unit-test"))
end

return Language