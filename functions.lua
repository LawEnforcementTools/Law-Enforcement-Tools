-- DO NOT EDIT OR THE SCRIPT WILL NOT WORK  

function Notify(Text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    DrawNotification(true, true)
end

function NotifyHelp(Text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(Text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function LoadAnimation(Dict)
    while not HasAnimDictLoaded(Dict) do
        RequestAnimDict(Dict)
        Citizen.Wait(5)
    end
end

function KeyboardInput(TextEntry, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, 'FMMC_KEY_TIP1', '', '', '', '', '', MaxStringLenght)
	BlockInput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local Result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		BlockInput = false
		return Result
	else
		Citizen.Wait(500)
		BlockInput = false
		return nil
	end
end

function GetClosestPlayer()
    local Ped = PlayerPedId()

    for _, Player in ipairs(GetActivePlayers()) do
        if GetPlayerPed(Player) ~= GetPlayerPed(-1) then
            local Ped2 = GetPlayerPed(Player)
            local x, y, z = table.unpack(GetEntityCoords(Ped))
            if (GetDistanceBetweenCoords(GetEntityCoords(Ped2), x, y, z) <  2) then
                return GetPlayerServerId(Player)
            end
        end
    end

    Notify('~r~No Player Nearby!')
    return false
end

function GetDistance(ID)
    local Ped = GetPlayerPed(-1)
    local Ped2 = GetPlayerPed(ID)
    local x, y, z = table.unpack(GetEntityCoords(Ped))
    return GetDistanceBetweenCoords(GetEntityCoords(Ped2), x, y, z)
end

function LEORestrict()
    if Config.LEOAccess == 0 then
        return false
    elseif Config.LEOAccess == 1 then
        return true
    elseif Config.LEOAccess == 2 then
        local Ped = GetEntityModel(GetPlayerPed(-1))

        for _, LEOPeds in pairs(Config.LEOUniforms) do
            local AllowedPed = GetHashKey(LEOPeds.spawncode)

            if Ped == AllowedPed then
                return true
            end
        end
    elseif Config.LEOAccess == 3 then
        return LEOOnduty
    elseif Config.LEOAccess == 4 then
        return LEOAce
    else
        return true
    end
end