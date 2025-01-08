RegisterServerEvent("community_bridge:server:alert", function(data)
    local playersByJob = Framework.GetPlayersByJob(data.job)
    for _, src in pairs(playersByJob) do
        TriggerClientEvent("community_bridge:client:alert", src, data)
    end
end)