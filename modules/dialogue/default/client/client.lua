
local promises = {}

function CloseDialogue(name)
    SendNUIMessage({
        type = "close",
        name = name
    })
    promises[name] = nil
end

--- Open a dialogue with the player
--- @param name string
--- @param dialogue string
--- @param options table example = {{  id = string, label = string}}
function OpenDialogue(name, dialogue, options, onSelected, onCancelled)
    SendNUIMessage({
        type = "open",
        text =  dialogue,
        name = name,
        options = options
    })
    SetNuiFocus(true, true)
    local wrappedFunction = function(selected)        
        SetNuiFocus(false, false)
        CloseDialogue(name)
        onSelected(selected)
    end
    promises[name] = wrappedFunction
end

RegisterCommand("dialogue", function()
    OpenDialogue( "Akmed" , "Hello how are you doing my friend?", { 
            {
                label = "Trade with me",
                id = 'something',
            },
            {
                label = "Goodbye",
                id = 'someotherthing',
            },
        },
        function(selectedId)
            if selectedId == 'something' then
                OpenDialogue( "Akmed" , "Thank you for wanting to purchase me lucky charms", { 
                    {
                        label = "fuck russia",
                        id = 'something',
                    },
                    {
                        label = "Goodbye",
                        id = 'someotherthing',
                    },
                },
                function(selectedId)
                    print("fuck russia:", selectedId)
                end
            )
            end
        end
    )
end)

RegisterNuiCallback("dialogue:SelectOption", function(data)
    print("Selected option: " .. data.name)
    local promis = promises[data.name]
    if not promis then return end
    promis(data.id)
end)

-- { label: 'Hello there! this is some long text that i am Dialogueing', id: '1' },
-- { label: 'Trade with me', id: '2' },
-- { label: 'Goodbye', id: '3' }
