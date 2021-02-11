local isCuffed = false
RegisterNetEvent('Cuff')
AddEventHandler('Cuff', function()
	local Ped = PlayerPedId()
	if (DoesEntityExist(Ped)) then
		Citizen.CreateThread(function()
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
            end

            if isCuffed then
                isCuffed = false
                Citizen.Wait(500)
                SetEnableHandcuffs(Ped, false)
                ClearPedTasksImmediately(Ped)
            else
                isCuffed = true
				SetEnableHandcuffs(Ped, true)
				TaskPlayAnim(Ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

        if isCuffed then
            if not IsEntityPlayingAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 3) then
                TaskPlayAnim(GetPlayerPed(PlayerId()), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end

            SetCurrentPedWeapon(PlayerPedId(), 'weapon_unarmed', true)
            
            if not Config.VehEnterCuffed then
                DisableControlAction(1, 23, true) --F | Enter Vehicle
                DisableControlAction(1, 75, true) --F | Exit Vehicle
            end
			DisableControlAction(1, 140, true) --R
			DisableControlAction(1, 141, true) --Q
			DisableControlAction(1, 142, true) --LMB
			SetPedPathCanUseLadders(GetPlayerPed(PlayerId()), false)
			if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) then
				DisableControlAction(0, 59, true) --Vehicle Driving
			end
		end
	end
end)

local Drag = false
local OfficerDrag = -1
RegisterNetEvent('Drag')
AddEventHandler('Drag', function(ID)
	Drag = not Drag
	OfficerDrag = ID
	
	if not Drag then
        DetachEntity(PlayerPedId(), true, false)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if Drag then
            local Ped = GetPlayerPed(GetPlayerFromServerId(OfficerDrag))
            local Ped2 = PlayerPedId()
            AttachEntityToEntity(Ped2, Ped, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            DisableControlAction(1, 140, true) --R
			DisableControlAction(1, 141, true) --Q
			DisableControlAction(1, 142, true) --LMB
        end
    end
end)

RegisterNetEvent('Seat')
AddEventHandler('Seat', function(Veh)
	local Pos = GetEntityCoords(PlayerPedId())
	local EntityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
    local RayHandle = CastRayPointToPoint(Pos.x, Pos.y, Pos.z, EntityWorld.x, EntityWorld.y, EntityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, VehicleHandle = GetRaycastResult(RayHandle)
    if VehicleHandle ~= nil then
		SetPedIntoVehicle(PlayerPedId(), VehicleHandle, 1)
	end
end)

RegisterNetEvent('Unseat')
AddEventHandler('Unseat', function(ID)
	local Ped = GetPlayerPed(ID)
	ClearPedTasksImmediately(Ped)
	PlayerPos = GetEntityCoords(PlayerPedId(),  true)
	local X = PlayerPos.x - 0
	local Y = PlayerPos.y - 0

    SetEntityCoords(PlayerPedId(), X, Y, PlayerPos.z)
end)