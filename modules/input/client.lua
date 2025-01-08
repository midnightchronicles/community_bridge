
if GetResourceState('ox_lib') ~= 'started' and GetResourceState('qb-menu') ~= 'started' then return end
-- {
--     header = "Test",
--     submitText = "Bill",
--     inputs = {
--         {
--             text = "Citizen ID (#)", -- text you want to be displayed as a place holder
--             name = "citizenid", -- name of the input should be unique otherwise it might override
--             type = "text", -- type of the input
--             isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
--             -- default = "CID-1234", -- Default text option, this is optional
--         },
--         {
--             text = "Secret Code (Give to Nobody)", -- text you want to be displayed as a place holder
--             name = "code", -- name of the input should be unique otherwise it might override
--             type = "password", -- type of the input
--             isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
--             -- default = "password123", -- Default text option, this is optional
--         },
--         {
--             text = "Bill Price ($)", -- text you want to be displayed as a place holder
--             name = "billprice", -- name of the input should be unique otherwise it might override
--             type = "number", -- type of the input - number will not allow non-number characters in the field so only accepts 0-9
--             isRequired = false, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
--             -- default = 1, -- Default number option, this is optional
--         },
--         {
--             text = "Bill Type", -- text you want to be displayed as a input header
--             name = "billtype", -- name of the input should be unique otherwise it might override
--             type = "radio", -- type of the input - Radio is useful for "or" options e.g; billtype = Cash OR Bill OR bank
--             options = { -- The options (in this case for a radio) you want displayed, more than 6 is not recommended
--                 { value = "bill", text = "Bill" }, -- Options MUST include a value and a text option
--                 { value = "cash", text = "Cash" }, -- Options MUST include a value and a text option
--                 { value = "bank", text = "Bank" }  -- Options MUST include a value and a text option
--             },
--             -- default = "cash", -- Default radio option, must match a value from above, this is optional
--         },
--         {
--             text = "Include Tax?", -- text you want to be displayed as a input header
--             name = "taxincl", -- name of the input should be unique otherwise it might override
--             type = "checkbox", -- type of the input - Check is useful for "AND" options e.g; taxincle = gst AND business AND othertax
--             options = { -- The options (in this case for a check) you want displayed, more than 6 is not recommended
--                 { value = "gst", text = "10% incl."}, -- Options MUST include a value and a text option
--                 { value = "business", text = "35% incl.", checked = true }, -- Options MUST include a value and a text option, checked = true is default value, optional
--                 { value = "othertax", text = "15% incl."}  -- Options MUST include a value and a text option
--             }
--         },
--         {
--             text = "Some Select", -- text you want to be displayed as a input header
--             name = "someselect", -- name of the input should be unique otherwise it might override
--             type = "select", -- type of the input - Select is useful for 3+ amount of "or" options e.g; someselect = none OR other OR other2 OR other3...etc
--             options = { -- Select drop down options, the first option will by default be selected
--                 { value = "none", text = "None" }, -- Options MUST include a value and a text option
--                 { value = "other", text = "Other"}, -- Options MUST include a value and a text option
--                 { value = "other2", text = "Other2" }, -- Options MUST include a value and a text option
--                 { value = "other3", text = "Other3" }, -- Options MUST include a value and a text option
--                 { value = "other4", text = "Other4" }, -- Options MUST include a value and a text option
--                 { value = "other5", text = "Other5" }, -- Options MUST include a value and a text option
--                 { value = "other6", text = "Other6" }, -- Options MUST include a value and a text option
--             },
--             -- default = 'other3', -- Default select option, must match a value from above, this is optional
--         }
--     },
-- })

-- local input = lib.inputDialog('Dialog title', {
--     {type = 'input', label = 'Text input', description = 'Some input description', required = true, min = 4, max = 16},
--     {type = 'number', label = 'Number input', description = 'Some number description', icon = 'hashtag'},
--     {type = 'checkbox', label = 'Simple checkbox'},
--     {type = 'color', label = 'Colour input', default = '#eb4034'},
--     {type = 'date', label = 'Date input', icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"}
--   })


--QB types: text, password, number, radio, checkbox, select,
--
-- "input", "number", "checkbox", "select", "multi-select", "slider", "color", "date", "date-range", "time",  "textarea",
Input = {}


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

-- qb to ox

function QBTypeToOxType(_type)
    if _type == "text" then
        return "input"
    elseif _type == "password" then
        return "input"
    elseif _type == "number" then
        return "number"
    elseif _type == "radio" then
        return "checkbox"
    elseif _type == "checkbox" then
        return "checkbox"
    elseif _type == "select" then
        return "select"
    end
end


function QBToOxInput(data)
    local returnData = {}
    for i, v in pairs(data) do
        local input = {
            label = v.text,
            name = i,
            type = QBTypeToOxType(v.type),
            required = v.isRequired,
            default = v.placeholder,
        }
        if v.type == "select" then
            input.options = {}
            for i, v in pairs(v.options) do
                table.insert(input.options, {value = v.value, label = v.text})
            end
        elseif v.type == "checkbox" then
            for i, v in pairs(v.options) do
                table.insert(returnData, {value = v.value, label = v.text})
            end
        end
        table.insert(returnData, input)
    end
    return returnData
end

--Open menu

function Input.Open(title, data, isQB, submitText)
    if isQB then
        local inputs = data.inputs
        if BridgeClientConfig.InputSystem == "ox" then
            return lib.inputDialog(title, QBToOxInput(inputs))
        elseif BridgeClientConfig.InputSystem == "qb" then
            return exports['qb-input']:ShowInput({
                header = title,
                submitText = submitText or "Submit",
                inputs = inputs
            })
        end
    else
        if BridgeClientConfig.InputSystem == "ox" then
            return lib.inputDialog(title, data)
        elseif BridgeClientConfig.InputSystem == "qb" then
            return exports['qb-input']:ShowInput({
                header = title,
                submitText = submitText or "Submit",
                inputs = OxToQBInput(data)
            })
        end
    end
    return id
end

--[[
-- Unit tests
local thisIsQB = {
    header = "Test",
    submitText = "Bill",
    inputs = {
        {
            text = "Citizen ID (#)", -- text you want to be displayed as a place holder
            name = "citizenid", -- name of the input should be unique otherwise it might override
            type = "text", -- type of the input
            isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
            -- default = "CID-1234", -- Default text option, this is optional
        },
        {
            text = "Secret Code (Give to Nobody)", -- text you want to be displayed as a place holder
            name = "code", -- name of the input should be unique otherwise it might override
            type = "password", -- type of the input
            isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
            -- default = "password123", -- Default text option, this is optional
        },
        {
            text = "Bill Price ($)", -- text you want to be displayed as a place holder
            name = "billprice", -- name of the input should be unique otherwise it might override
            type = "number", -- type of the input - number will not allow non-number characters in the field so only accepts 0-9
            isRequired = false, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
            -- default = 1, -- Default number option, this is optional
        },
        {
            text = "Bill Type", -- text you want to be displayed as a input header
            name = "billtype", -- name of the input should be unique otherwise it might override
            type = "radio", -- type of the input - Radio is useful for "or" options e.g; billtype = Cash OR Bill OR bank
            options = { -- The options (in this case for a radio) you want displayed, more than 6 is not recommended
                { value = "bill", text = "Bill" }, -- Options MUST include a value and a text option
                { value = "cash", text = "Cash" }, -- Options MUST include a value and a text option
                { value = "bank", text = "Bank" }  -- Options MUST include a value and a text option
            },
            -- default = "cash", -- Default radio option, must match a value from above, this is optional
        },
        {
            text = "Include Tax?", -- text you want to be displayed as a input header
            name = "taxincl", -- name of the input should be unique otherwise it might override
            type = "checkbox", -- type of the input - Check is useful for "AND" options e.g; taxincle = gst AND business AND othertax
            options = { -- The options (in this case for a check) you want displayed, more than 6 is not recommended
                { value = "gst", text = "10% incl."}, -- Options MUST include a value and a text option
                { value = "business", text = "35% incl.", checked = true }, -- Options MUST include a value and a text option, checked = true is default value, optional
                { value = "othertax", text = "15% incl."}  -- Options MUST include a value and a text option
            }
        },
        {
            text = "Some Select", -- text you want to be displayed as a input header
            name = "someselect", -- name of the input should be unique otherwise it might override
            type = "select", -- type of the input - Select is useful for 3+ amount of "or" options e.g; someselect = none OR other OR other2 OR other3...etc
            options = { -- Select drop down options, the first option will by default be selected
                { value = "none", text = "None" }, -- Options MUST include a value and a text option
                { value = "other", text = "Other"}, -- Options MUST include a value and a text option
                { value = "other2", text = "Other2" }, -- Options MUST include a value and a text option
                { value = "other3", text = "Other3" }, -- Options MUST include a value and a text option
                { value = "other4", text = "Other4" }, -- Options MUST include a value and a text option
                { value = "other5", text = "Other5" }, -- Options MUST include a value and a text option
                { value = "other6", text = "Other6" }, -- Options MUST include a value and a text option
            },
            -- default = 'other3', -- Default select option, must match a value from above, this is optional
        }
    },
}

local thisIsOx = {
    {type = 'input', label = 'Text input', description = 'Some input description', required = true, min = 4, max = 16},
    {type = 'number', label = 'Number input', description = 'Some number description', icon = 'hashtag'},
    {type = 'checkbox', label = 'Simple checkbox'},
    {type = 'color', label = 'Colour input', default = '#eb4034'},
    {type = 'date', label = 'Date input', icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"}
}

-- qb to ox
RegisterCommand('inputtest1', function()
    Input.Open("Test", thisIsQB, true)
end)

-- ox to qb
RegisterCommand('inputtest2', function()
    Input.Open("Test", thisIsOx, false)
end)
--]]