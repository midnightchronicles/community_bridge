


--- Open a dialogue with the player
--- @param name string
--- @param dialogue string
--- @param options table example = {{  id = string, label = string}}
function OpenDialogue(name, dialogue, options)
    SendNUIMessage({
        type = "open",
        text =  dialogue,
        name = name,
        options = options
    })
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
            }
        }
    )
end)


-- { label: 'Hello there! this is some long text that i am Dialogueing', id: '1' },
-- { label: 'Trade with me', id: '2' },
-- { label: 'Goodbye', id: '3' }
