
if GetResourceState('qb-input') ~= 'started' or (BridgeClientConfig.InputSystem ~= "qb" and BridgeClientConfig.InputSystem ~= "auto") then return end


-- ox to Qb
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
            placeholder = v.default,
        }
        if v.type == "select" then
            input.text = ""
            input.options = {
                {value = v.value, text = v.label}
            }
        elseif v.type == "checkbox" then
            input.text = ""
            input.options = {
                {value = v.value, text = v.label}
            }
        end
        table.insert(returnData, input)
    end
    return returnData
end

function OpenInput(title, data, isQBFormat, submitText)
    print("Opening input", json.encode(data))
    local input = data.inputs
    if not isQBFormat then
        input = OxToQBInput(data)
    end
    return exports['qb-input']:ShowInput({
        header = title,
        submitText = submitText or "Submit",
        inputs = input
    })    
end