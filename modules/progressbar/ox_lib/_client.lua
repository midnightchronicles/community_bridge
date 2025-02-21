if GetResourceState('ox_lib') ~= 'started' or (BridgeClientConfig.ProgressBarSystem ~= "ox" and BridgeClientConfig.InputSystem ~= "auto") then return end
ProgressBar = ProgressBar or {}

local function convertFromQB(options)
    if not options then return options end
    
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
        }
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
