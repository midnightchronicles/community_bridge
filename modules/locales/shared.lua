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
    --print(resource, "locales/" .. Lang .. ".json")
    local locales = LoadResourceFile(resource, "locales/" .. Lang .. ".json")
    --print(locales, Lang)
    locales = locales and json.decode(locales) or {}
    local locale = locales[str]

    if not locale then
        warn("Locale not found for language: " .. Lang)
        return str
    end

    local args = {...}
    if #args > 0 then
        for i = 1, #args do
            locale = locale:gsub('{' .. i .. '}', args[i])
        end
    end

    return locale
end

if BridgeSharedConfig.DebugLevel == 3 then
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