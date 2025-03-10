if GetResourceState('Renewed-Banking') ~= 'started' then return end
Managment = Managment or {}

Managment.GetAccountMoney = function(account)
    return exports['Renewed-Banking']:getAccountMoney(account)
end

Managment.AddAccountMoney = function(account, amount)
    return exports['Renewed-Banking']:addAccountMoney(account, amount)
end

Managment.RemoveAccountMoney = function(account, amount)
    return exports['Renewed-Banking']:removeAccountMoney(account, amount)
end