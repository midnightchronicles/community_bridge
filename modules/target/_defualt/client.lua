Target = Target or {}

local function warnUser()
    print("Currently Only Targeting Is Supported.")
end

Target.AddGlobalPlayer = function(options)
    warnUser()
end

Target.AddGlobalVehicle = function(options)
    warnUser()
end

Target.RemoveGlobalVehicle = function(options)
    warnUser()
end

Target.AddLocalEntity = function(entities, _options)
    warnUser()
end

Target.AddModel = function(models, options)
    warnUser()
end

Target.AddBoxZone = function(name, coords, size, heading, options)
    warnUser()
end

Target.RemoveGlobalPlayer = function()
    warnUser()
end

Target.RemoveLocalEntity = function(entity)
    warnUser()
end

Target.RemoveModel = function(model)
    warnUser()
end

Target.RemoveZone = function(name)
    warnUser()
end