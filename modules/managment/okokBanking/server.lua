if GetResourceState('okokBanking') ~= 'started' then return end
Managment = Managment or {}

Managment.GetAccountMoney = function(account)
    return exports['okokBanking']:GetAccount(account)
end

Managment.AddAccountMoney = function(account, amount)
    return exports['okokBanking']:AddMoney(account, amount)
end

Managment.RemoveAccountMoney = function(account, amount)
    return exports['okokBanking']:RemoveMoney(account, amount)
end