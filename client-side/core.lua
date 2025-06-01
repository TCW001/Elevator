local ElevatorCoords = {
	["1"] = {
		["1"] = { -467.81,-1028.62,24.28,87.88 },
		["2"] = { -467.81,-1028.62,29.08,87.88 },
		["3"] = { -467.81,-1028.62,33.68,87.88 }
	}
}

local currentElevator = nil
-- Aqui Coloque a Lógica do seu Marker 3D da sua Base!
CreateThread(function()
	while true do
		local sleep = 1000
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for id, elevator in pairs(ElevatorCoords) do
			for floor, data in pairs(elevator) do
				local pos = vec3(data[1], data[2], data[3])
				local dist = #(coords - pos)

				if dist <= 3.25 then
					sleep = 1

					SetDrawOrigin(pos.x, pos.y, pos.z + 0.5)
					DrawSprite("Textures", "E", 0.0, 0.0, 0.03, 0.03 * GetAspectRatio(false), 0.0, 255, 255, 255, 255)
					ClearDrawOrigin()

					if dist <= 1.25 and IsControlJustPressed(0, 38) then
						currentElevator = id
						SetNuiFocus(true, true)
						SendNUIMessage({
							action = "open",
							data = elevator
						})
					end
				end
			end
		end
		Wait(sleep)
	end
end)

RegisterNUICallback("goToFloor", function(data, cb)
    local floor = ElevatorCoords[currentElevator][data.floor]

    if floor then
        SetEntityCoords(PlayerPedId(), floor[1], floor[2], floor[3])
        SetEntityHeading(PlayerPedId(), floor[4])

        SetNuiFocus(false, false)
        SendNUIMessage({ action = "close" })
    end

    cb("ok")
end)