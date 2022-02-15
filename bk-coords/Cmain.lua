local showing = nil

RegisterCommand("coords", function()
    showing = not showing
    if showing then
        while showing do
            local playerPed = PlayerPedId()
	        local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
            local heading = GetEntityHeading(playerPed)
            SendNUIMessage({
                action = "ShowCoords",
                coordsX = playerX,
                coordsY = playerY,
                coordsZ = playerZ,
                coordsH = heading,
            })
            SendNUIMessage({
                type = 'clipboard',
                data = '' .. vec(playerX, playerY, playerZ, heading)
            })
            Wait(200)
        end
    else
        SendNUIMessage({
            action = "HideCoords",
        })
        SetNuiFocus(false,false)    
    end
end)
