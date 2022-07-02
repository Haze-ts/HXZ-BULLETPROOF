function HXZ_MenuBullet()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'bullet_menu',{
		  title    = "HXZ - Bullet Menu",
		  align = 'top-left',
		  elements = {	  			  
			{label = Lang['take_off_your_bulletproof_vest'],    value = 'take_off'}, 
		  	}
	  },function(data, menu)
        local hxz_val = data.current.value
        if hxz_val == 'take_off' then
            HXZ_RemoveArmour()
        end
	end, function(data, menu)
		menu.close()
	end)
end

function HXZ_OpenShopMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'shop_bullet',{
		  title    = "HXZ - Bullet Menu",
		  align = 'top-left',
		  elements = {	  			  
			{label = Lang['bulletproof'],    value = 'buy'}, 
		  	}
	    },function(data, menu)
        local hxz_val = data.current.value
        if hxz_val == 'buy' then
            TriggerServerEvent('hxz:buyabulletproof')
        end
	end, function(data, menu)
		menu.close()
	end)
end

Citizen.CreateThread(function()
    if Config.EnableCommand then
        RegisterCommand(Config.Command, function()
            HXZ_MenuBullet()
        end)
    end
end)

RegisterNetEvent('hxz:menubullet', function()
    HXZ_MenuBullet()
end)

RegisterNetEvent('hxz-addcomponent')
AddEventHandler('hxz-addcomponent', function()
    lib.progressCircle({
        duration = 2000,
        position = 'middle',
        useWhileDead = false,
        canCancel = true,
        anim = {
            dict = 'clothingtie',
            clip = 'try_tie_negative_a' 
        },
    })
    SetPedComponentVariation(PlayerPedId(), 9, 4, 1, 1)
    SetPedArmour(PlayerPedId(), 100)
    HXZ_CheckArmour()
    ClearPedTasks(PlayerPedId())
end)

function HXZ_CheckArmour()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            print('Controllo effettuato')
            if GetPedArmour(PlayerPedId())  <= 0 then
                SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0)
                break;
            end
        end
    end)
end

function HXZ_RemoveArmour()
    if GetPedArmour(PlayerPedId()) >= 100 then
        lib.progressCircle({
            duration = 2000,
            position = 'middle',
            useWhileDead = false,
            canCancel = true,
            anim = {
                dict = 'clothingtie',
                clip = 'try_tie_negative_a' 
            },
        })
        SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0)
        SetPedArmour(PlayerPedId(), 0)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('hxz:addinventoryitem')
    else
        ESX.ShowNotification(Lang['the_bulletproof_vest_is_worn'])
    end
end

Citizen.CreateThread(function()
    for k,v in pairs(Config.PositionShop) do
        TriggerEvent('gridsystem:registerMarker', {
            name = 'HXZ_BulletShop' ..k,
            pos = vector3(v.x, v.y, v.z),
            scale = vector3(0.6, 0.6, 0.6),
            size = vector3(2.0, 2.0, 1.0),
            msg = '',
            control = 'E',
            type = 22,
            shouldRotate = true,
            color = { r = 51, g = 255, b = 255 },
            action = function()
                lib.hideTextUI()
                HXZ_OpenShopMenu()
            end,
            onEnter = function()
				lib.showTextUI(Lang['press_for_open_the_shop'], {
					position = "top-center",
					icon = 'hand',
					style = {
						borderRadius = 10,
						backgroundColor = '#0000ff',
						color = 'white'
					}
				})
			end,
            onExit = function()
                ESX.UI.Menu.CloseAll()
                lib.hideTextUI()
            end
        })
    end
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    SetPedComponentVariation(PlayerPedId(), 9, 0, 0, 0)
    SetPedArmour(PlayerPedId(), 0)
end)

-- Create blips
CreateThread(function()
    if Config.EnabeBlip then
        for k,v in pairs(Config.PositionShop) do
            local hxz_blip = AddBlipForCoord(v.x, v.y, v.z)

            SetBlipSprite (hxz_blip, 487)
            SetBlipDisplay(hxz_blip, 4)
            SetBlipScale  (hxz_blip, 0.8)
            SetBlipColour (hxz_blip, 46)
            SetBlipAsShortRange(hxz_blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Lang['blip_map'])
            EndTextCommandSetBlipName(hxz_blip)
        end
    end
end)