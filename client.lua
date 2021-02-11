-- DO NOT TOUCH / EDIT  -

local pluginName = 'Law Enforcement Tools'

local isCop = true                                                       



RegisterCommand('seat', function(source, args, rawCommand)
	if isCop then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				local closestID = GetPlayerServerId(closest)
				local pP = GetPlayerPed(-1)
				local veh = GetVehiclePedIsIn(pP, true)
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'You forced the player you are dragging into the nearest vehicle. (' .. GetPlayerName(closest) .. ')')
				TriggerServerEvent('seatServer', closestID, veh)
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'You are not a cop.')
	end
end)

RegisterCommand('unseat', function(source, args, rawCommand)
	if isCop then
		closest, distance = GetClosestPlayer()
		if closest ~= nil and DoesEntityExist(GetPlayerPed(closest)) then
			if distance -1 and distance < 3 then
				local closestID = GetPlayerServerId(closest)
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'You forced the player in the nearest vehicle out of the vehicle. (' .. GetPlayerName(closest) .. ')')
				TriggerServerEvent('unSeatServer', closestID)
			else
				TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Nearest player is too far away.')
			end
		end
	else
		TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'You are not a cop.')
	end
end)

RegisterNetEvent('seatClient')
AddEventHandler('seatClient', function(veh)
	if handcuffed == true then
		local pP = GetPlayerPed(-1)
		local pos = GetEntityCoords(pP)
		local entityWorld = GetOffsetFromEntityInWorldCoords(pP, 0.0, 20.0, 0.0)
		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, pP, 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		local vehicle = GetVehiclePedIsIn(pP, false)
		
		DetachEntity(pP, true, false)
		Citizen.Wait(100)
		if vehicleHandle ~= nil then
			SetPedIntoVehicle(pP, vehicleHandle, 1)
		end
		SetVehicleDoorsLocked(vehicle, 4)
	end
end)

RegisterNetEvent('unSeatClient')
AddEventHandler('unSeatClient', function(closestID)
	if handcuffed then
		local pP = GetPlayerPed(-1)
		local pos = GetEntityCoords(pP)
		ClearPedTasksImmediately(pP)
		local xnew = pos.x + 2
		local ynew = pos.y + 2
		
		SetEntityCoords(pP, xnew, ynew, pos.z)
		SetEnableHandcuffs(pP, true)
		SetCurrentPedWeapon(pP, GetHashKey('WEAPON_UNARMED'), true)
		DisablePlayerFiring(pP, true)
		FreezeEntityPosition(pP, true)
		handcuffed = true
	end
end)

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', ExampleText, '', '', '', MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function getEntityPlayerAimingAt(player)
	local result, target = GetEntityPlayerIsFreeAimingAt(player)
	return target
end


