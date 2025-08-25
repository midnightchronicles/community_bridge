
local Targets = {
    tag = "targets",
    default = {
        label = "Default Target Label",
        distance = 2,
    }
}


function Targets.OnSpawn(entityData)
    if not entityData.spawned or not entityData.target then return end
    if entityData.targets?.label then
        entityData.newTargets = {entityData.targets}
    else
        entityData.newTargets = entityData.targets or {}
    end
    for k, v in pairs(entityData.newTargets) do
        local onSelect = v.onSelect
        if onSelect then
            v.onSelect = function(entity)
                onSelect(entityData, entity)
            end
        end
    end
    Target.AddLocalEntity(entityData.spawned, entityData.newTargets)
    entityData.oldTargets = entityData.newTargets
end

function Targets.OnRemove(entityData)
    if not entityData.spawned or not entityData.newTargets then return end
    Target.RemoveLocalEntity(entityData.spawned)
end

function Targets.OnUpdate(entityData)
    if not entityData.spawned or not entityData.newTargets then return end
    for i, target in ipairs(entityData.oldTargets) do
        local newTarget = entityData.targets.label
        if newTarget then
            entityData.newTargets = {entityData.targets}
        end
        newTarget = entityData.newTargets[i]
        if newTarget and target.label ~= newTarget.label
            or target.distance ~= newTarget.distance
            or target.description ~= newTarget.description
        then
            Targets.OnRemove(entityData)
            Targets.OnSpawn(entityData)
        end
    end
end

return Targets