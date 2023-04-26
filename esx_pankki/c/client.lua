ESX                         = nil
inMenu                      = true
local showblips = false
local atbank = false
local bankMenu = true
local banks = {
  {name="Bank", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Bank", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Bank", id=108, x=-2962.582, y=482.627, z=15.703},
  {name="Bank", id=108, x=-112.202, y=6469.295, z=31.626},
  {name="Bank", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Bank", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Bank", id=108, x=247.25, y=222.87, z=105.28}, --Keskuspankki
  {name="Bank", id=108, x=242.22, y=225.06, z=105.28}, --Keskuspankki
  {name="Bank", id=108, x=252.79, y=221.27, z=105.28}, --Keskuspankki
  {name="Bank", id=108, x=1175.06, y=2706.64, z=38.09},
  {name="Bank", id=108, x=-1075.24, y=-2558.62, z=13.50} --lentokentän pankki
}	

local type = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
end)

if bankMenu then
	Citizen.CreateThread(function()
	while true do
		Wait(50)
		if nearBank() then
			DisplayHelpText("Paina ~INPUT_PICKUP~ käyttääksesi pankkia")
			if IsControlPressed(1, 38) then
				TriggerEvent('pankki:HandNui', 'bank')
			end
		end
        
		if IsControlPressed(1, 322) then
			inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
  end)
end

AddEventHandler('pankki:HandNui', function(trans)
	type = trans
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
	TriggerServerEvent('bank:saldo')
	local ped = GetPlayerPed(-1)
end)

Citizen.CreateThread(function()
	if showblips then
	  for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 1.0)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)

RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
	})
end)


RegisterNUICallback('deposit', function(data)
	if ( type == "atm" and tonumber(data.amount) > 10000 ) then
		ESX.ShowNotification('Et voi tallentaa, kuin maksimissaan 10000$', 'error')
		return
	end
	TriggerServerEvent('bank:lisaa', tonumber(data.amount))
end)

RegisterNUICallback('withdrawl', function(data)
	if ( type == "atm" and tonumber(data.amountw) > 10000 ) then
		ESX.ShowNotification('Et voi nostaa, kuin maksimissaan 10000$', 'error')
		return
	end
	TriggerServerEvent('bank:nosta', tonumber(data.amountw))
end)

RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:saldo')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)

RegisterNUICallback('NUIFocusOff', function()
	if ( type == "atm" ) then
		ClearPedTasks(PlayerPedId())
	end
	type = nil
  	inMenu = false
  	SetNuiFocus(false, false)
  	SendNUIMessage({type = 'closeAll'})
end)


function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return true
		end
	end
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end