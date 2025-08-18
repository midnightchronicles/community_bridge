---@diagnostic disable: duplicate-set-field
if GetResourceState('piotreq_gpt') == 'missing' then return end
Dispatch = Dispatch or {}

Dispatch.SendAlert = function(data)
    if not data then return end
    TriggerServerEvent('community_bridge:Server:piotreq_gpt', data)
end

return Dispatch