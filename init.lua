Bridge = {}

function Bridge.RegisterModule(moduleName, moduleTable)
    if not moduleTable then
        print("No moduleTable provided for module and no defaultsTable found: ", moduleName)
        return
    end
    if Bridge[moduleName] then
        print("Module already registered:", moduleName)
        return
    end

    local wrappedModule = {}
    for functionName, func in pairs(moduleTable) do
        wrappedModule[functionName] = func
    end
    print("Registering module:", moduleName)
    Bridge[moduleName] = wrappedModule
end

--TODO: Create a way to overide functions or create a new functions for module

Bridge.RegisterModule("Framework", Framework)
Bridge.RegisterModule("Inventory", Inventory)
Bridge.RegisterModule("Notify", Notify)
Bridge.RegisterModule("Utility", Utility)
Bridge.RegisterModule("Clothing", Clothing)
Bridge.RegisterModule("Menu", Menu)
Bridge.RegisterModule("Language", Language)
Bridge.RegisterModule("Doorlock", Doorlock)
Bridge.RegisterModule("Phone", Phone)
Bridge.RegisterModule("Target", Target)
Bridge.RegisterModule("Table", Table)
Bridge.RegisterModule("Math", Math)
Bridge.RegisterModule("Prints", Prints)
Bridge.RegisterModule("Callback", Callback)


CreateThread(function()
    for moduleName, moduleFunction in pairs(Bridge) do
        if type(moduleFunction) == 'table' then
            exports(moduleName, function()
                return moduleFunction
            end)
        else
            exports(moduleName, moduleFunction)
        end
    end
end)

exports('Bridge', function()
    return Bridge
end)


if IsDuplicityVersion() then return end

Bridge.RegisterModule("Dispatch", Dispatch)
Bridge.RegisterModule("Fuel", Fuel)
Bridge.RegisterModule("Input", Input)
Bridge.RegisterModule("Progressbar", Progressbar)
Bridge.RegisterModule("VehicleKey", VehicleKey)
Bridge.RegisterModule("Weather", Weather)

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
