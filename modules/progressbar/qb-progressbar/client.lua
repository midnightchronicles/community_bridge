if BridgeClientConfig.ProgressBar ~= "qb" then return end
Progressbar = {}

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

Progressbar.StartProgressBar = function(time, label, whiledead, cancancel, disable, animTable, successAction, canceledAction)
    local runTime = time or 10000
    local textLabel = label or "Doing something"
    local deadBool = whiledead or false
    local cancelBool = cancancel or false
    local success = successAction or function() Prints.Debug("Success") end
    local canceled = canceledAction or function() Prints.Debug("Cancelled") end
    local repackedTable = convertOxToQB(disable, animTable)
    exports['progressbar']:Progress({
        name = textLabel,
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

Progressbar.IsProgressBarActive = function()
    return exports["progressbar"]:isDoingSomething()
end