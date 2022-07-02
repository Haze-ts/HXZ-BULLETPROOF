ESX.RegisterUsableItem('bullet', function(source)
    print('Indossando Il giubbotto')
    exports.ox_inventory:RemoveItem(source, 'bullet', 1, nil, nil)
    TriggerClientEvent('hxz-addcomponent', source)
end)

RegisterNetEvent('hxz:addinventoryitem')
AddEventHandler('hxz:addinventoryitem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('bullet', 1)
end)

RegisterNetEvent('hxz:buyabulletproof')
AddEventHandler('hxz:buyabulletproof', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = exports.ox_inventory:GetItem(source, 'money', nil, nil)
    if money.count >= Config.Price then
        xPlayer.removeInventoryItem('money', Config.Price)
        xPlayer.addInventoryItem('bullet', 1)
    else
        TriggerClientEvent('esx:showNotification', source, Lang['you_do_not_have_enough_money'])
    end
end)