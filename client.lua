
local prevtent = 0
RegisterCommand('kampkur', function(source, args, rawCommand)
    if prevtent ~= 0 then
        SetEntityAsMissionEntity(prevtent)
        DeleteObject(prevtent)
        prevtent = 0
    end
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.95))
    local tents = {
        'prop_skid_tent_01',
        'prop_skid_tent_01b',
        'prop_skid_tent_03',
    }
    local randomint = math.random(1,3)
    local tent = GetHashKey(tents[randomint])
    local prop = CreateObject(tent, x, y, z, true, false, true)
    TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
    exports['mythic_progbar']:Progress({
		name = "kamp_kur",
		duration = 8000,
		label = 'Kamp Kuruyorsun..',
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "",
            anim = "",
        },
        prop = {
            model = "",
        }
    }, function()
        prevtent = prop
        ClearPedTasksImmediately(PlayerPedId())
        TriggerEvent('dr:campfire')
	end)
end, false)

RegisterCommand('Kampkaldır', function(source, args, rawCommand)
    if prevtent == 0 then
       -- TriggerEvent('chatMessage', '', {255,255,255}, '^8Error: ^0no previous tent spawned, or your previous tent has already been deleted.')
    else
        TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
        exports['mythic_progbar']:Progress({
	    	name = "kamp_kaldır",
	    	duration = 8000,
	    	label = 'Kampı Kaldırıyorsun..',
	    	useWhileDead = false,
	    	canCancel = false,
	    	controlDisables = {
	    		disableMovement = true,
	    		disableCarMovement = true,
	    		disableMouse = false,
	    		disableCombat = true,
	    	},
	    	animation = {
                animDict = "",
                anim = "",
            },
            prop = {
                model = "",
            }
        }, function()
            SetEntityAsMissionEntity(prevtent)
            DeleteObject(prevtent)
            prevtent = 0
            TriggerEvent('dr:campfiredel')
            ClearPedTasksImmediately(PlayerPedId())
	    end)
    end
end, false)

local prevfire = 0
RegisterNetEvent('dr:campfire')
AddEventHandler('dr:campfire', function()
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, -1.55))
    local prop = CreateObject(GetHashKey("prop_beach_fire"), x+3.2, y+0.4, z, true, false, true)
    if prevfire ~= 0 then
        SetEntityAsMissionEntity(prevfire)
        DeleteObject(prevfire)
        prevfire = 0
    end
    TaskStartScenarioInPlace(PlayerPedId(), 'world_human_gardener_plant', 0, false)
    exports['mythic_progbar']:Progress({
		name = "kamp_atesi",
		duration = 8000,
		label = 'Kamp Ateşini Yakıyorsun..',
		useWhileDead = false,
		canCancel = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
            animDict = "",
            anim = "",
        },
        prop = {
            model = "",
        }
    }, function()
     --   SetEntityHeading(prop, GetEntityHeading(PlayerPedId()))
      --  PlaceObjectOnGroundProperly(prop)
        prevfire = prop
        ClearPedTasksImmediately(PlayerPedId())
	end)
end)

RegisterNetEvent('dr:campfiredel')
AddEventHandler('dr:campfiredel', function()
    if prevfire == 0 then
      --  TriggerEvent('chatMessage', '', {255,255,255}, '^8Error: ^0no previous campfire spawned, or your previous campfire has already been deleted.')
    else
        SetEntityAsMissionEntity(prevfire)
        DeleteObject(prevfire)
        prevfire = 0
    end
end)


local prevchair = 0

RegisterNetEvent('dr:campdelobject')
AddEventHandler('dr:campdelobject', function()
    local prop = 0
    local deelz = 10
    local deelxy = 2
    for offsety=-2,2 do
        for offsetx=-2,2 do
            for offsetz=-8,8 do
                local CoordFrom = GetEntityCoords(PlayerPedId(), true)
                local CoordTo = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
                local RayHandle = StartShapeTestRay(CoordFrom.x, CoordFrom.y, CoordFrom.z-(offsetz/deelz), CoordTo.x+(offsetx/deelxy), CoordTo.y+(offsety/deelxy), CoordTo.z-(offsetz/deelz), 16, PlayerPedId(), 0)
                local _, _, _, _, object = GetShapeTestResult(RayHandle)
                if object ~= 0 then
                    prop = object
                    break
                end
            end
        end
    end
    if prop == 0 then
       -- TriggerEvent('chatMessage', '', {255,255,255}, '^8Error: ^0could not detect object.')
    else
        SetEntityAsMissionEntity(prop)
        DeleteObject(prop)
    end
end)