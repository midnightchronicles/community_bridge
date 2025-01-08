if GetResourceState('core_inventory') ~= 'started' then return end

Inventory = Inventory or {}
Inventory.TestText = function()
   return 'test'
end