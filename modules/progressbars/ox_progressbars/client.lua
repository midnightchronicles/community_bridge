if BridgeClientConfig.ProgressBar ~= "ox" then return end
ProgressBar = {}
local _progBarType = BridgeClientConfig.ProgressBarStyle or "bar"

ProgressBar.StartProgressBar = function(time, label, whiledead, cancancel, disable, animTable, successAction, canceledAction)
    local runTime = time or 10000
    local textLabel = label or "Doing something"
    local deadBool = whiledead or false
    local cancelBool = cancancel or false
    local disableKeys = disable or { move = true, sprint = true, car = true, combat = true, }
    local anim = animTable or nil
    local success = successAction or function() print("Success") end
    local canceled = canceledAction or function() print("Cancelled") end
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

ProgressBar.IsProgressBarActive = function()
    return exports.ox_lib:progressActive()
end