if BridgeClientConfig.ProgressBar ~= "qb" then return end
ProgressBar = {}

local function convertOxToQB(disabledTable, animTable)
    local repackedTable = { disabled = {}, animations = {}}
    for _, v in pairs(disabledTable) do
        if v.move then
            repackedTable.disabled.disableMovement = v.move
        end
        if v.car then
            repackedTable.disabled.disableCarMovement = v.car
        end
        if v.combat then
            repackedTable.disabled.disableCombat = v.combat
        end
        if v.mouse then
            repackedTable.disabled.disableMouse = v.mouse
        end
    end
    for _, v in pairs(animTable) do
        if v.dict then
            repackedTable.animations.animDict = v.animDict
        end
        if v.clip then
            repackedTable.animations.anim = v.anim
        end
    end
    return repackedTable
end

ProgressBar.StartProgressBar = function(time, label, whiledead, cancancel, disable, animTable, successAction, canceledAction)
    local runTime = time or 10000
    local textLabel = label or "Doing something"
    local deadBool = whiledead or false
    local cancelBool = cancancel or false
    local success = successAction or function() print("Success") end
    local canceled = canceledAction or function() print("Cancelled") end
    local repackedTable = convertOxToQB(disable, animTable)
    exports['progressbar']:Progress({
        name = "random_task",
        duration = runTime,
        label = textLabel,
        useWhileDead = deadBool,
        canCancel = cancelBool,
        controlDisables = repackedTable.disabled,
        animation = repackedTable.animations,
        prop = {},
        propTwo = {}
     }, function(cancelled)
        if not cancelled then
            success()
        else
            canceled()
        end
     end)
end

ProgressBar.IsProgressBarActive = function()
    return exports["progressbar"]:isDoingSomething()
end