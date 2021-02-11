RegisterServerEvent('GlobalChat')
AddEventHandler('GlobalChat', function(Color, Prefix, Message)
	TriggerClientEvent('chatMessage', -1, Prefix, Color, Message)
end)

RegisterServerEvent('CuffNear')
AddEventHandler('CuffNear', function(ID)
	if ID == -1 or ID == '-1' then
		if source ~= '' then
			print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to cuff all players^7')
			DropPlayer(source, '\n Attempting to cuff all players')
		else
			print('^1Someone attempted to cuff all players^7')
		end

		return
	end

	if ID ~= false then
		TriggerClientEvent('Cuff', ID)
	end
end)

RegisterServerEvent('DragNear')
AddEventHandler('DragNear', function(ID)
	if ID == -1 or ID == '-1' then
		if source ~= '' then
			print('^1[#' .. source .. '] ' .. GetPlayerName(source) .. '  -  attempted to drag all players^7')
			DropPlayer(source, '\n Attempting to drag all players')
		else
			print('^1Someone attempted to drag all players^7')
		end

		return
	end
	
	if ID ~= false and ID ~= source then
		TriggerClientEvent('Drag', ID, source)
	end
end)

RegisterServerEvent('SeatNear')
AddEventHandler('SeatNear', function(ID, Vehicle)
    TriggerClientEvent('Seat', ID, Vehicle)
end)

RegisterServerEvent('UnseatNear')
AddEventHandler('UnseatNear', function(ID, Vehicle)
    TriggerClientEvent('Unseat', ID, Vehicle)
end)