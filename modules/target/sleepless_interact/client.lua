local resourceName = "sleepless_interact"
local configValue = BridgeClientConfig.TargetSystem
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end

--if GetResourceState('sleepless_interact') ~= 'started' then return end
-- This is only partially supported

local sleepless = exports.sleepless_interact

Target = Target or {}

Target.ModuleName = function()
    return resourceName
end

Target.DisableTargeting = function(bool)
    -- nothing to see here
end

Target.FixOptions = function(options)
    for k, v in pairs(options) do
        local action = v.onSelect or v.action
        local select = function(entityOrData)
            if type(entityOrData) == 'table' then
                return action(entityOrData.entity)
            end
            return action(entityOrData)
        end
        options[k].onSelect = select
    end
    return options
end

Target.AddLocalEntity = function(entity, _options)
    local options = Target.FixOptions(_options)
    sleepless:addLocalEntity({
        id = entity,
        entity = entity,
        options = options,
        renderDistance = 10.0,
        activeDistance = 2.0,
        cooldown = 1500
    })
end

Target.RemoveLocalEntity = function(entity)
    sleepless:removeLocalEntity(entity)
end