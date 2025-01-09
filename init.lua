Bridge = {
    modules = {},
}
PlayerLoaded = false
PlayerIdentifier = nil
PlayerJobName = nil
PlayerJobLabel = nil
PlayerJobGradeName = nil
PlayerJobGradeLevel = nil

Bridge.Inventory = Inventory
Bridge.Menu = Menu
Bridge.Language = Language
Bridge.Framework = Framework
Bridge.Doorlock = Doorlock
Bridge.Phone = Phone
Bridge.Notify = Notify
Bridge.Vehicle = Vehicle
Bridge.Fuel = Fuel
Bridge.Dispatch = Dispatch
Bridge.Weather = Weather
Bridge.Target = Target
Bridge.Table = Table
Bridge.Input = Input
Bridge.Managment = Managment
Bridge.Math = Math
Bridge.VehicleKey = VehicleKey
Bridge.Clothing = Clothing
Bridge.Progressbar = Progressbar
Bridge.Utility = Utility
Bridge.Prints = Prints


CreateThread(function()
    for k, v in pairs(Bridge) do
        if type(v) == 'table' then
            exports(k, function()
                return v
            end)
            v.__index = function(key, value)
                IndexingFallback(v, key, value)
            end
        else
            exports(k, v)
        end
    end
end)

function IndexingFallback(module, k, v)
    if not module[k] then
        local func = Framework[k] and type(Framework[k]) == 'function' and Framework[k] or nil
        return function(...)
            return func(...)
        end
    end
    return module[k]
end

OverRide = function(module, key, value)
    module[key] = value
end

RegisterCompatibility = function(key, module)
    module = module or {}
    module.__index = IndexingFallback
    module.OverRide = function(key, value)
        OverRide(module, key, value)
    end
    Bridge[key] = module
end
exports('RegisterCompatibility', RegisterCompatibility)

exports('Bridge', function()
    return Bridge
end)

if IsDuplicityVersion() then return end

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