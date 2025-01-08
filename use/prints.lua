Prints = {}
local function printMessage(level, color, message)
    if type(message) == 'table' then
        message = json.encode(message)
    end
    print(color .. '[' .. level .. ']:', message)
end

Prints.info = function(message)
    printMessage('INFO', '^5', message)
end

Prints.warn = function(message)
    printMessage('WARN', '^3', message)
end

Prints.error = function(message)
    printMessage('ERROR', '^1', message)
end

Prints.debug = function(message)
    printMessage('DEBUG', '^2', message)
end

return Prints