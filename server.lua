RegisterServerEvent('seatServer')
AddEventHandler('seatServer', function(closestID, veh)
	TriggerClientEvent('seatClient', closestID, veh)
end)
RegisterServerEvent('unSeatServer')
AddEventHandler('unSeatServer', function(closestID)
	TriggerClientEvent('unSeatClient', closestID)
end)