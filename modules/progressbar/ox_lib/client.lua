-- if BridgeClientConfig.ProgressBar ~= "ox" then return end
-- Progressbar = {}
-- local _progBarType = BridgeClientConfig.ProgressBarStyle or "bar"

-- Progressbar.StartProgressBar = function(time, label, whiledead, cancancel, disable, animTable, successAction, canceledAction)
--     local runTime = time or 10000
--     local textLabel = label or "Doing something"
--     local deadBool = whiledead or false
--     local cancelBool = cancancel or false
--     local disableKeys = disable or { move = true, sprint = true, car = true, combat = true, }
--     local anim = animTable or nil
--     local success = successAction or function() Prints.Debug("Success") end
--     local canceled = canceledAction or function() Prints.Debug("Cancelled") end
--     if _progBarType == "bar" then
--         if exports.ox_lib:progressBar({
--             duration = runTime,
--             label = textLabel,
--             useWhileDead = deadBool,
--             canCancel = cancelBool,
--             disable = disableKeys,
--             anim = anim,
--         }) then success() else canceled() end
--     elseif _progBarType == "circle" then
--         if exports.ox_lib:progressCircle({
--             duration = runTime,
--             label = textLabel,
--             position = 'bottom',
--             useWhileDead = deadBool,
--             canCancel = cancelBool,
--             disable = disableKeys,
--             anim = anim,
--         }) then success() else canceled() end
--     end
-- end

-- Progressbar.IsProgressBarActive = function()
--     return exports.ox_lib:progressActive()
-- end


if GetResourceState('ox_lib') ~= 'started' or (BridgeClientConfig.ProgressBarSystem ~= "ox" and BridgeClientConfig.InputSystem ~= "auto") then return end
ProgressBar = ProgressBar or {}

local function convertFromQB(options)
    if not options then return options end
    local prop1 = options.prop or {}
    local prop2 = options.propTwo or {}
    local props = {
        {
            model = prop1.model,
            bone = prop1.bone,
            pos = prop1.coords,
            rot = prop1.rotation,       
        },
        {
            model = prop2.model,
            bone = prop2.bone,
            pos = prop2.coords,
            rot = prop2.rotation,
        }
    }
    
    
    return {
        duration = options.duration,
        label = options.label,
        position = 'bottom',
        useWhileDead = options.useWhileDead,
        canCancel = options.canCancel,
        disable = {
            move = options.controlDisables?.disableMovement,
            car = options.controlDisables?.disableCarMovement,
            combat = options.controlDisables?.disableCombat,
            mouse = options.controlDisables?.disableMouse
        },
        anim = {
            dict = options.animation?.animDict,
            clip = options.animation?.anim
        },
        prop = props,
    }
end

function ProgressBar.Open(options, cb, isQBInput)
    if isQBInput then
        options = convertFromQB(options)
    end
    
    local style = options.style or 'bar'
    local success = style == 'circle' and exports.ox_lib:progressCircle(options) or exports.ox_lib:progressBar(options)
        
    if cb then cb(not success) end
    return success
end

RegisterCommand("progressbar", function()
    ProgressBar.Open({
        duration = 5000,
        label = "Searching",
        disable = {
            move = true,
            combat = true
        },
        anim = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer"
        }
    }, function(cancelled)
        print(cancelled and "Cancelled" or "Complete")
    end)
end)
