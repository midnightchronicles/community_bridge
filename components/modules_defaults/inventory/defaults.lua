local DefaultInventory = {
    Open = function()
        print("DefaultInventory: Open called")
    end,
    Close = function()
        print("DefaultInventory: Close called")
    end,
}
return DefaultInventory