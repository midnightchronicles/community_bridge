Bridge = {}

local function registerModule(moduleName, moduleTable)
    local wrappedModule = {}
    for functionName, func in pairs(moduleTable) do
        wrappedModule[functionName] = func
    end
    print("Registering module:", moduleName)
    Bridge[moduleName] = wrappedModule
end

function Bridge.RegisterModule(moduleName, moduleTable)
    if not moduleTable then
        moduleTable = Framework
        registerModule(moduleName, moduleTable)
        return
    end
    if Bridge[moduleName] then
        print("Module already registered:", moduleName)
        return
    end
    registerModule(moduleName, moduleTable)
end
--TODO: Create a way to overide functions or create a new functions for module
-- local OverRide = function(module, key, value)
--     module[key] = value
-- end

-- RegisterCompatibility = function(moduleName, key, func)
--     local module = Bridge[moduleName] or {}

--     if not module[key] then
--         module[key] = func
--         print("Registered function for:", moduleName, key)
--     else
--         print("Key already exists for:", moduleName, key)
--     end
--     Bridge[moduleName] = module
--     Bridge[moduleName].OverRide = function(k, v)
--         OverRide(module, k, v)
--     end
-- end
-- exports('RegisterCompatibility', RegisterCompatibility)

Bridge.RegisterModule("Inventory", Inventory)
Bridge.RegisterModule("Framework", Framework)
Bridge.RegisterModule("Notify", Notify)
Bridge.RegisterModule("Utility", Utility)
Bridge.RegisterModule("Progressbar", Progressbar)
Bridge.RegisterModule("Clothing", Clothing)
Bridge.RegisterModule("Menu", Menu)
Bridge.RegisterModule("Language", Language)
Bridge.RegisterModule("Debugger", Debugger)
Bridge.RegisterModule("Doorlock", Doorlock)
Bridge.RegisterModule("Phone", Phone)
Bridge.RegisterModule("Vehicle", Vehicle)
Bridge.RegisterModule("Dispatch", Dispatch)
Bridge.RegisterModule("Weather", Weather)
Bridge.RegisterModule("Target", Target)
Bridge.RegisterModule("Table", Table)
Bridge.RegisterModule("Math", Math)
Bridge.RegisterModule("Prints", Prints)

-- Fill the bridge tables with player data.
function FillBridgeTables()
    PlayerLoaded = true
    PlayerIdentifier = Framework.GetPlayerIdentifier()
    PlayerJobName, PlayerJobLabel, PlayerJobGradeName, PlayerJobGradeLevel = Framework.GetPlayerJob()
end

-- Clean the bridge tables.
function ClearClientSideVariables()
    PlayerLoaded = false
    PlayerIdentifier = nil
    PlayerJobName = nil
    PlayerJobLabel = nil
    PlayerJobGradeName = nil
    PlayerJobGradeLevel = nil
    StoredOldClothing = {}
end

CreateThread(function()
    for k, v in pairs(Bridge) do
        if type(v) == 'table' then
            exports(k, function()
                return v
            end)
        else
            exports(k, v)
        end
    end
end)

exports('Bridge', function()
    return Bridge
end)
