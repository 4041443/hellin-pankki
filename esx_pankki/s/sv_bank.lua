ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bank:lisaa')
AddEventHandler('bank:lisaa', function(amount)
	local _source = source
	
	local xPlayer = ESX.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
        TriggerClientEvent('esx:showNotification', source, 'Virheellinen määrä!', 'error')
	else
		TriggerEvent("esx:rahantalletus", xPlayer.name, amount)
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
        TriggerClientEvent('esx:showNotification', source, 'Talletit: ' .. amount .. '€')
	end
end)


RegisterServerEvent('bank:nosta')
AddEventHandler('bank:nosta', function(amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
        TriggerClientEvent('esx:showNotification', source, 'Virheellinen määrä.')
	else
		TriggerEvent("esx:rahannosto", xPlayer.name, amount)
		xPlayer.removeAccountMoney('bank', tonumber(amount))
		xPlayer.addMoney(amount)
        TriggerClientEvent('esx:showNotification', source, 'Nostit: ' .. amount .. '€')
	end
end)

RegisterServerEvent('bank:saldo')
AddEventHandler('bank:saldo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('currentbalance1', _source, balance)
end)