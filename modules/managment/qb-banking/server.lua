if GetResourceState('qb-banking') ~= 'started' then return end
Managment = {}

Managment.GetAccountMoney = function(account)
    return exports['qb-banking']:GetAccountBalance(account)
end

Managment.AddAccountMoney = function(account, amount)
    return exports['qb-banking']:AddMoney(account, amount)
end

Managment.RemoveAccountMoney = function(account, amount)
    return exports['qb-banking']:RemoveMoney(account, amount)
end