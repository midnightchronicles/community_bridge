Bridge = {}

local function registerModule(moduleName, moduleTable)
    local wrappedModule = {}
    for functionName, func in pairs(moduleTable) do
        wrappedModule[functionName] = func
    end
    print("Registering module:", moduleName)
    Bridge[moduleName] = wrappedModule
end

function Bridge.RegisterModule(moduleName, moduleTable, defaultsTable)
    if not moduleTable then
        moduleTable = Framework
        registerModule(moduleName, moduleTable)
        return
    end

    if Bridge[moduleName] then
        print("Module already registered:", moduleName)
        return
    end

    if defaultsTable and type(defaultsTable) == "table" then
        for functionName, func in pairs(defaultsTable) do
            if not moduleTable[functionName] then
                moduleTable[functionName] = func
                print(string.format("Added function '%s' from defaultsTable to module '%s'", functionName, moduleName))
            end
        end
    end

    registerModule(moduleName, moduleTable)
end

--TODO: Create a way to overide functions or create a new functions for module

Bridge.RegisterModule("Framework", Framework)
Bridge.RegisterModule("Inventory", Inventory, DefaultInventory)
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
