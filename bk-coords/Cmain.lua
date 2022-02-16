local editing = false
local Showing = false

RegisterCommand('coords', function()
	OpenCoords()
end)

RegisterCommand('move', function ()
    if Showing then
        SetNuiFocus(true, true)
        editing = true
    else 
        Notification('You cant move the coords if they are not showing.')
    end
end)

RegisterNUICallback("close", function()
    SendNUIMessage({
        action = "HideCoords",
    })
    SetNuiFocus(false,false)
end)

function OpenCoords()
	Showing = not Showing
	
	if Showing then
	    local playerPed = PlayerPedId()
	    local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
	    local heading = GetEntityHeading(playerPed)
	    SendNUIMessage({
			action = "ShowCoords",
			coordsX = FormatCoord(playerX),
			coordsY = FormatCoord(playerY),
			coordsZ = FormatCoord(playerZ),
			coordsH = FormatCoord(heading),
	    })
	elseif not Showing then
		SendNuiMessage({
			action = "HideCoords",  
		)}
		editing = false
		SetNuiFocus(false, false)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) 
        if editing then
            local coords, heading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()) 
            SendNUIMessage({
                type = 'clipboard',
                data = '' .. vec(coords.x, coords.y, coords.z, heading)
            })
        end
    end
end)

FormatCoord = function(coord)
    if coord == nil then
        return "uknow"
    end
    return tonumber(string.format("%.2f", coord))
end

function Notification (str) 
    SetNotificationTextEntry('STRING')
    AddTextComponentString(str)
    DrawNotification(0, 1)
end
