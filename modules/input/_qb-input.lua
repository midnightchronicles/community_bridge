local resourceName = "qb-input"
local configValue = BridgeClientConfig.InputSystem
if (configValue == "auto" and GetResourceState(resourceName) ~= "started") or (configValue ~= "auto" and configValue ~= resourceName) then return end

function OxTypeToQBType(_type)
    if _type == "input" then
        return "text"
    elseif _type == "number" then
        return "number"
    elseif _type == "checkbox" then
        return "checkbox"
    elseif _type == "select" then
        return "select"
    elseif _type == "multi-select" then
        return "select"
    elseif _type == "slider" then
        return "number"
    elseif _type == "color" then
        return "text"
    elseif _type == "date" then
        return "date"
    elseif _type == "date-range" then
        return "date"
    elseif _type == "time" then
        return "time"
    elseif _type == "textarea" then
        return "text"
    end
end

function OxToQBInput(data)
    local returnData = {}
    for i, v in pairs(data) do
        local input = {
            text = v.label,
            name = i,
            type = OxTypeToQBType(v.type),
            isRequired = v.required,
            default = v.default or "",
        }
        if v.type == "select" then
            input.text = ""
            input.options = {}
            for k, j in pairs(v.options) do
                table.insert(input.options, {value = j.value, text = j.label})
            end
        elseif v.type == "checkbox" then
            input.text = ""
            input.options = {}
            for k, j in pairs(v.options) do
                table.insert(input.options, {value = j.value, text = j.label})
            end
        end
        table.insert(returnData, input)
    end
    return returnData
end

function OpenInput(title, data, isQBFormat, submitText)
    local input = data.inputs
    if not isQBFormat then
        input = OxToQBInput(data)
    end
    local returnData = exports['qb-input']:ShowInput({
        header = title,
        submitText = submitText or "Submit",
        inputs = input
    })
    if not returnData then return end
    if returnData[1] then return returnData end
    --converting to standard format (ox)
    local convertedData = {}
    if isQBFormat then
        for i, v in pairs(input) do
            for k, j in pairs(returnData) do
                if k == v.text then
                    convertedData[tonumber(i)] = j
                end
            end
        end
        return convertedData
    end

    for i, v in pairs(returnData) do
        convertedData[tonumber(i)] = v
    end
    return convertedData
end
