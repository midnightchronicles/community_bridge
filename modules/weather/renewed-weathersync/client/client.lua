if GetResourceState('Renewed-Weathersync') ~= 'started' then return end
Weather = {}

Weather.ToggleSync = function(toggle)
    LocalPlayer.state.syncWeather = toggle
end