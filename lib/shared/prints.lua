Prints = Prints or {}
local function printMessage(level, color, message)
    if type(message) == 'table' then
        message = json.encode(message)
    end
    print(color .. '[' .. level .. ']:', message)
end

Prints.Info = function(message)
    printMessage('INFO', '^5', message)
end

Prints.Warn = function(message)
    printMessage('WARN', '^3', message)
end

Prints.Error = function(message)
    printMessage('ERROR', '^1', message)
end

Prints.Debug = function(message)
    printMessage('DEBUG', '^2', message)
end

return Prints