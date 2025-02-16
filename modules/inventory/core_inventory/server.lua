if GetResourceState('core_inventory') ~= 'started' then return end

Inventory = Inventory or {}

Inventory.TestFunction = function(item)
    return 'test funct server inv'
end