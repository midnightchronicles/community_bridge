if GetResourceState('progressbar') ~= 'started' or (BridgeClientConfig.ProgressBarSystem ~= "qb" and BridgeClientConfig.ProgressBarSystem ~= "auto") then return end
ProgressBar = ProgressBar or {}

local function convertFromOx(options)
    if not options then return options end
    
    return {
        name = options.label,
        duration = options.duration,
        label = options.label,
        useWhileDead = options.useWhileDead,
        canCancel = options.canCancel,
        controlDisables = {
            disableMovement = options.disable?.move,
            disableCarMovement = options.disable?.car,
            disableMouse = options.disable?.mouse,
            disableCombat = options.disable?.combat
        },
        animation = {
            animDict = options.anim?.dict,
            anim = options.anim?.clip
        },
        prop = {},
        propTwo = {}
    }
end

function ProgressBar.Open(options, cb, qbFormat)
    if not exports['progressbar'] then return false end
    
    if not qbFormat then
        options = convertFromOx(options)
    end
    
    exports['progressbar']:Progress(options, cb)
end


-- Example usage:
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
