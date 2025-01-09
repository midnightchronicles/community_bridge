if BridgeClientConfig.ProgressBar ~= "ox" then return end
Progressbar = {}
local _progBarType = BridgeClientConfig.ProgressBarStyle or "bar"

Progressbar.StartProgressBar = function(time, label, whiledead, cancancel, disable, animTable, successAction, canceledAction)
    local runTime = time or 10000
    local textLabel = label or "Doing something"
    local deadBool = whiledead or false
    local cancelBool = cancancel or false
    local disableKeys = disable or { move = true, sprint = true, car = true, combat = true, }
    local anim = animTable or nil
    local success = successAction or function() Prints.Debug("Success") end
    local canceled = canceledAction or function() Prints.Debug("Cancelled") end
    if _progBarType == "bar" then
        if exports.ox_lib:progressBar({
            duration = runTime,
            label = textLabel,
            useWhileDead = deadBool,
            canCancel = cancelBool,
            disable = disableKeys,
            anim = anim,
        }) then success() else canceled() end
    elseif _progBarType == "circle" then
        if exports.ox_lib:progressCircle({
            duration = runTime,
            label = textLabel,
            position = 'bottom',
            useWhileDead = deadBool,
            canCancel = cancelBool,
            disable = disableKeys,
            anim = anim,
        }) then success() else canceled() end
    end
end

Progressbar.IsProgressBarActive = function()
    return exports.ox_lib:progressActive()
end